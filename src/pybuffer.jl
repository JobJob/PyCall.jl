# Python buffer protocol: this is a NumPy-array-like facility to get raw
# pointers to contiguous buffers of data underlying other objects,
# with support for describing multiple dimensions, strides, etc.
#     (thanks to @jakebolewski for his work on this)

#############################################################################
# mirror of Py_buffer struct in Python Include/object.h

struct Py_buffer
    buf::Ptr{Cvoid}
    obj::PyPtr
    len::Cssize_t
    itemsize::Cssize_t

    readonly::Cint
    ndim::Cint
    format::Ptr{Cchar}
    shape::Ptr{Cssize_t}
    strides::Ptr{Cssize_t}
    suboffsets::Ptr{Cssize_t}

    # some opaque padding fields to account for differences between
    # Python versions (the structure changed in Python 2.7 and 3.3)
    internal0::Ptr{Cvoid}
    internal1::Ptr{Cvoid}
    internal2::Ptr{Cvoid}
end

mutable struct PyBuffer
    buf::Py_buffer
    PyBuffer() = begin
        b = new(Py_buffer(C_NULL, C_NULL, 0, 0,
                          0, 0, C_NULL, C_NULL, C_NULL, C_NULL,
                          C_NULL, C_NULL, C_NULL))
        @compat finalizer(pydecref, b)
        return b
    end
end

function pydecref(o::PyBuffer)
    # note that PyBuffer_Release sets o.obj to NULL, and
    # is a no-op if o.obj is already NULL
    # TODO change to `Ref{PyBuffer}` when 0.6 is dropped.
    ccall(@pysym(:PyBuffer_Release), Cvoid, (Any,), o)
    o
end

#############################################################################
# Array-like accessors for PyBuffer.

Base.ndims(b::PyBuffer) = UInt(b.buf.ndim)

# from the Python docs: If shape is NULL as a result of a PyBUF_SIMPLE
# or a PyBUF_WRITABLE request, the consumer must disregard itemsize
# and assume itemsize == 1.
Base.length(b::PyBuffer) = b.buf.shape == C_NULL ? Int(b.buf.len) : Int(div(b.buf.len, b.buf.itemsize))

Base.sizeof(b::PyBuffer) = Int(b.buf.len)
Base.pointer(b::PyBuffer) = b.buf.buf

function Base.size(b::PyBuffer)
    b.buf.ndim <= 1 && return (length(b),)
    @assert b.buf.shape != C_NULL
    return tuple(Int[unsafe_load(b.buf.shape, i) for i=1:b.buf.ndim]...)
end
# specialize size(b, d) for efficiency (avoid tuple construction)
function Base.size(b::PyBuffer, d::Integer)
    d > b.buf.ndim && return 1
    d < 0 && throw(BoundsError())
    b.buf.ndim <= 1 && return length(b)
    @assert b.buf.shape != C_NULL
    return Int(unsafe_load(b.buf.shape, d))
end

# stride in bytes for i-th dimension
function Base.stride(b::PyBuffer, d::Integer)
    d > b.buf.ndim && return length(b) # as in base
    d < 0 && throw(BoundsError())
    if b.buf.strides == C_NULL
        if b.buf.ndim == 1
            return b.buf.shape == C_NULL ? 1 : Int(b.buf.itemsize)
        else
            error("unknown buffer strides")
        end
    end
    return Int(unsafe_load(b.buf.strides, d))
end

# TODO change to `Ref{PyBuffer}` when 0.6 is dropped.
iscontiguous(b::PyBuffer) =
    1 == ccall((@pysym :PyBuffer_IsContiguous), Cint,
               (Any, Cchar), b, 'A')

#############################################################################
# pybuffer constant values from Include/object.h
const PyBUF_MAX_NDIM = convert(Cint, 64) # == 0x0040 ? and not in spec
const PyBUF_SIMPLE    = convert(Cint, 0)
const PyBUF_WRITABLE  = convert(Cint, 0x0001)
const PyBUF_FORMAT    = convert(Cint, 0x0004)
const PyBUF_ND        = convert(Cint, 0x0008)
const PyBUF_STRIDES        = convert(Cint, 0x0010) | PyBUF_ND
const PyBUF_C_CONTIGUOUS   = convert(Cint, 0x0020) | PyBUF_STRIDES
const PyBUF_F_CONTIGUOUS   = convert(Cint, 0x0040) | PyBUF_STRIDES
const PyBUF_ANY_CONTIGUOUS = convert(Cint, 0x0080) | PyBUF_STRIDES
const PyBUF_INDIRECT       = convert(Cint, 0x0100) | PyBUF_STRIDES

# construct a PyBuffer from a PyObject, if possible
function PyBuffer(o::Union{PyObject,PyPtr}, flags=PyBUF_SIMPLE)
    b = PyBuffer()
    # TODO change to `Ref{PyBuffer}` when 0.6 is dropped.
    @pycheckz ccall((@pysym :PyObject_GetBuffer), Cint,
                     (PyPtr, Any, Cint), o, b, flags)
    return b
end

function PyBuffer!(b::PyBuffer, o::Union{PyObject,PyPtr}, flags=PyBUF_SIMPLE)
    # TODO change to `Ref{PyBuffer}` when 0.6 is dropped.
    @pycheckz ccall((@pysym :PyObject_GetBuffer), Cint,
                     (PyPtr, Any, Cint), o, b, flags)
    return b
end

#############################################################################

# recursive function to write buffer dimension by dimension, starting at
# dimension d with the given pointer offset (in bytes).
function writedims(io::IO, b::PyBuffer, offset, d)
    n = 0
    s = stride(b, d)
    if d < b.buf.ndim
        for i = 1:size(b,d)
            n += writedims(io, b, offset, d+1)
            offset += s
        end
    else
        @assert d == b.buf.ndim
        p = convert(Ptr{UInt8}, pointer(b)) + offset
        for i = 1:size(b,d)
            # would be nicer not to write this one byte at a time,
            # but the alternative seems to be to create an Array
            # object on each loop iteration.
            for j = 1:b.buf.itemsize
                n += write(io, unsafe_load(p))
                p += 1
            end
            p += s
        end
    end
    return n
end

function Base.write(io::IO, b::PyBuffer)
    b.buf.obj != C_NULL || error("attempted to write NULL buffer")

    if iscontiguous(b)
        # (note that 0-dimensional buffers are always contiguous)
        return write(io, pointer_to_array(convert(Ptr{UInt8}, pointer(b)),
                                          sizeof(b)))
    else
        return writedims(io, b, 0, 1)
    end
end

# ref: https://github.com/numpy/numpy/blob/v1.14.2/numpy/core/src/multiarray/buffer.c#L966
const pybuf_typestrs = Dict("?"=>Bool,
                           "b"=>Int8,        "B"=>UInt8,
                           "h"=>Int16,       "H"=>UInt16,
                           "i"=>Int32,       "I"=>UInt32,
                           "l"=>Int64,       "L"=>UInt64,
                           "q"=>Int128,      "Q"=>UInt128,
                           "e"=>Float16,     "f"=>Float32,
                           "d"=>Float64,     "g"=>Void, # Float128?
                           "c8"=>ComplexF32, "c16"=>ComplexF64,)
                            # "O"=>PyPtr, "O$(div(Sys.WORD_SIZE,8))"=>PyPtr)

       #                     case '?': return NPY_BOOL;
       # case 'b': return NPY_BYTE;
       # case 'B': return NPY_UBYTE;
       # case 'h': return native ? NPY_SHORT : NPY_INT16;
       # case 'H': return native ? NPY_USHORT : NPY_UINT16;
       # case 'i': return native ? NPY_INT : NPY_INT32;
       # case 'I': return native ? NPY_UINT : NPY_UINT32;
       # case 'l': return native ? NPY_LONG : NPY_INT32;
       # case 'L': return native ? NPY_ULONG : NPY_UINT32;
       # case 'q': return native ? NPY_LONGLONG : NPY_INT64;
       # case 'Q': return native ? NPY_ULONGLONG : NPY_UINT64;
       # case 'e': return NPY_HALF;
       # case 'f': return complex ? NPY_CFLOAT : NPY_FLOAT;
       # case 'd': return complex ? NPY_CDOUBLE : NPY_DOUBLE;
       # case 'g': return native ? (complex ? NPY_CLONGDOUBLE : NPY_LONGDOUBLE) : -1;

function PyArrayUsingBuffer(o::PyObject)
    npb = PyBuffer(o, Cint(PyBUF_WRITABLE | PyBUF_FORMAT | PyBUF_ND | PyBUF_STRIDES | PyBUF_ANY_CONTIGUOUS))
    # TODO get type
    info = PyArray_Info(Float64, true, collect(size(npb)), [stride(npb, i) for i in 1:npb.buf.ndim], convert(Ptr{Cvoid}, npb.buf.buf), npb.buf.readonly==1)
    PyArray{info.T, length(info.sz)}(o, info)
end

function ArrayFromBuffer(o::PyObject)
    npb = PyBuffer(o, Cint(PyBUF_WRITABLE | PyBUF_FORMAT | PyBUF_ND | PyBUF_STRIDES | PyBUF_ANY_CONTIGUOUS))
    typestr = unsafe_string(convert(Ptr{UInt8}, npb.buf.format))
    if length(typestr) > 1 && (ENDIAN_BOM == 0x04030201 && typestr[1] == '>') ||
       (ENDIAN_BOM == 0x01020304 && typestr[1] == '<')
        error("Only native endian format allowed, typestr: '$typestr'")
    end
    T = pybuf_typestrs[typestr[end:end]]
    T == Void && error("Array datatype '$typestr' not supported")
    unsafe_wrap(Array, convert(Ptr{T}, npb.buf.buf), size(npb), false)
end

#############################################################################
