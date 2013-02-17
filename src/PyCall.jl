module PyCall

export pyinitialize, pyfinalize, pycall, pyimport, pyglobal, PyObject,
       pyfunc, PyPtr, pyincref, pydecref, pyversion

import Base.convert
import Base.ref
import Base.show

typealias PyPtr Ptr{Void} # type for PythonObject* in ccall

#########################################################################
# Wrapper around Python's C PyObject* type, with hooks to Python reference
# counting and conversion routines to/from C and Julia types.

type PyObject
    o::PyPtr # the actual PyObject*

    # For copy-free wrapping of arrays, the PyObject may reference a
    # pointer to Julia array data.  In this case, we must keep a
    # reference to the Julia object inside the PyObject so that the
    # former is not garbage collected before the latter.
    keep::Any

    function PyObject(o::PyPtr, keep::Any)
        po = new(o, keep)
        finalizer(po, pydecref)
        return po
    end
end

PyObject(o::PyPtr) = PyObject(o, nothing) # no Julia object to keep

function pydecref(o::PyObject)
    ccall(pyfunc(:Py_DecRef), Void, (PyPtr,), o.o)
    o.o = C_NULL
end

pyincref(o::PyObject) = ccall(pyfunc(:Py_IncRef), Void, (PyPtr,), o)

# conversion to pass PyObject as ccall arguments:
convert(::Type{PyPtr}, po::PyObject) = po.o

# use constructor for generic conversions to PyObject
convert(::Type{PyObject}, o) = PyObject(o)
PyObject(o::PyObject) = o

#########################################################################

# Global configuration variables.  Note that, since Julia does not allow us
# to attach type annotations to globals, we need to annotate these explicitly
# as initialized::Bool and libpython::Ptr{Void} when we use them.
initialized = false # whether Python is initialized
libpython = C_NULL # Python shared library (from dlopen)

libpython_name(python::String) =
  replace(readall(`$python -c "import distutils.sysconfig; print distutils.sysconfig.get_config_var('LDLIBRARY')"`),
          r"\.so(\.[0-9\.]+)?\s*$|\.dll\s*$", "", 1)

pyfunc(func::Symbol) = dlsym(libpython::Ptr{Void}, func)

# initialize the Python interpreter (no-op on subsequent calls)
function pyinitialize(python::String)
    global initialized
    global libpython
    if (!initialized::Bool)
        if isdefined(:dlopen_global) # see Julia issue #2317
            libpython::Ptr{Void} = dlopen_global(libpython_name(python))
        else # Julia 0.1 - can't support inter-library dependencies
            libpython::Ptr{Void} = dlopen(libpython_name(python))
        end
        ccall(pyfunc(:Py_InitializeEx), Void, (Int32,), 0)
        initialized::Bool = true
    end
    return
end

pyinitialize() = pyinitialize("python") # default Python executable name
libpython_name() = libpython_name("python") # ditto

# end the Python interpreter and free associated memory
function pyfinalize()
    global initialized
    global libpython
    if (initialized::Bool)
        npyfinalize()
        gc() # collect/decref any remaining PyObjects
        ccall(pyfunc(:Py_Finalize), Void, ())
        dlclose(libpython::Ptr{Void})
        libpython::Ptr{Void} = C_NULL
        initialized::Bool = false
    end
    return
end

# Return the Python version as a Julia VersionNumber<
pyversion() = VersionNumber(convert((Int,Int,Int,String,Int), 
                                    pyimport("sys")["version_info"])[1:3]...)

#########################################################################
# Conversions of simple types (numbers and strings)

# conversions from Julia types to PyObject:

PyObject(i::Unsigned) = PyObject(ccall(pyfunc(:PyInt_FromSize_t),
                                       PyPtr, (Uint,), i))
PyObject(i::Integer) = PyObject(ccall(pyfunc(:PyInt_FromSsize_t),
                                      PyPtr, (Int,), i))

PyObject(b::Bool) = 
  PyObject(ccall(pyfunc(:PyBool_FromLong),
                 PyPtr, (OS_NAME == :Windows ? Int32 : Int,), b))

PyObject(r::Real) = PyObject(ccall(pyfunc(:PyFloat_FromDouble),
                                   PyPtr, (Float64,), r))

PyObject(c::Complex) = PyObject(ccall(pyfunc(:PyComplex_FromDoubles),
                                      PyPtr, (Float64,Float64), 
                                      real(c), imag(c)))

# fixme: PyString_* was renamed to PyBytes_* in Python 3.x?
PyObject(s::String) = PyObject(ccall(pyfunc(:PyString_FromString),
                                     PyPtr, (Ptr{Uint8},), bytestring(s)))

# conversions to Julia types from PyObject

convert{T<:Integer}(::Type{T}, po::PyObject) = 
  convert(T, ccall(pyfunc(:PyInt_AsSsize_t), Int, (PyPtr,), po))

convert(::Type{Bool}, po::PyObject) = 
  convert(Bool, ccall(pyfunc(:PyInt_AsSsize_t), Int, (PyPtr,), po))

convert{T<:Real}(::Type{T}, po::PyObject) = 
  convert(T, ccall(pyfunc(:PyFloat_AsDouble), Float64, (PyPtr,), po))

convert{T<:Complex}(::Type{T}, po::PyObject) = 
  convert(T, 
          complex128(ccall(pyfunc(:PyComplex_RealAsDouble), 
                           Float64, (PyPtr,), po),
                     ccall(pyfunc(:PyComplex_ImagAsDouble), 
                           Float64, (PyPtr,), po)))

convert(::Type{String}, po::PyObject) =
  bytestring(ccall(pyfunc(:PyString_AsString), 
                   Ptr{Uint8}, (PyPtr,), po))

#########################################################################
# Tuple conversion

function PyObject(t::(Any...)) 
    o = PyObject(ccall(pyfunc(:PyTuple_New), PyPtr, (Int,), length(t)))
    if o.o == C_NULL
        error("failure creating Python tuple")
    end
    for i = 1:length(t)
        oi = PyObject(t[i])
        if 0 != ccall(pyfunc(:PyTuple_SetItem), Int32, (PyPtr,Int,PyPtr),
                      o, i-1, oi)
            error("error setting Python tuple")
        end
        pyincref(oi) # PyTuple_SetItem steals the reference
    end
    return o
end

function convert(tt::(Type...), o::PyObject)
    len = ccall(pyfunc(:PySequence_Size), Int, (PyPtr,), o)
    if len != length(tt)
        throw(BoundsError())
    end
    ntuple(len, i ->
           convert(tt[i], PyObject(ccall(pyfunc(:PySequence_GetItem), PyPtr, 
                                         (PyPtr, Int), o, i-1))))
end

#########################################################################
# Lists and 1d arrays.  TODO: Use NumPy arrays to share data where possible.

function PyObject(v::AbstractVector)
    o = PyObject(ccall(pyfunc(:PyList_New), PyPtr, (Int,), length(v)))
    if o.o == C_NULL
        error("failure creating Python list")
    end
    for i = 1:length(v)
        oi = PyObject(v[i])
        if 0 != ccall(pyfunc(:PyList_SetItem), Int32, (PyPtr,Int,PyPtr),
                      o, i-1, oi)
            error("error setting Python tuple")
        end
        pyincref(oi) # PyList_SetItem steals the reference
    end
    return o
end

function convert{T}(::Type{Vector{T}}, o::PyObject)
    len = ccall(pyfunc(:PySequence_Size), Int, (PyPtr,), o)
    [ convert(T, PyObject(ccall(pyfunc(:PySequence_GetItem), PyPtr, 
                                (PyPtr, Int), o, i-1))) for i in 1:len ]
end

#########################################################################
# Dictionaries (TODO: no-copy conversion?)

function PyObject(d::Associative)
    o = PyObject(ccall(pyfunc(:PyDict_New), PyPtr, ()))
    if o == C_NULL
        error("failure creating Python dictionary")
    end
    for k in keys(d)
        if 0 != ccall(pyfunc(:PyDict_SetItem), Int32, (PyPtr,PyPtr,PyPtr),
                      o, PyObject(k), PyObject(d[k]))
            error("error setting Python dictionary item")
        end
    end
    return o
end

function convert{K,V}(::Type{Dict{K,V}}, o::PyObject)
    d = Dict{K,V}()
    # arrays to pass key, value, and pos pointers to PyDict_Next
    ka = Array(PyPtr, 1)
    va = Array(PyPtr, 1)
    pa = zeros(Int, 1) # must be initialized to zero
    while 0 != ccall(pyfunc(:PyDict_Next), Int32, 
                     (PyPtr, Ptr{Int}, Ptr{PyPtr}, Ptr{PyPtr}),
                     o, pa, ka, va)
        ko = PyObject(ka[1])
        vo = PyObject(va[1])
        merge!(d, (K=>V)[convert(K, ko) => convert(V, vo)])
        ko.o = C_NULL # borrowed reference, don't decref
        vo.o = C_NULL # borrowed reference, don't decref
    end
    return d
end

#########################################################################
# NumPy conversions (multidimensional arrays)

include("numpy.jl")

#########################################################################
# Pretty-printing PyObject

function show(io::IO, o::PyObject)
    if o.o == C_NULL
        print(io, "PyObject NULL")
    else
        s = ccall(pyfunc(:PyObject_Str), PyPtr, (PyPtr,), o)
        if (s == C_NULL)
            s = ccall(pyfunc(:PyObject_Repr), PyPtr, (PyPtr,), o)
            if (s == C_NULL)
                return print(io, "PyObject $(o.o)")
            end
        end
        print(io, "PyObject $(convert(String, PyObject(s)))")
    end
end

#########################################################################
# For o::PyObject, make o["foo"] and o[:foo] equivalent to o.foo in Python

function ref(o::PyObject, s::String)
    p = ccall(pyfunc(:PyObject_GetAttrString), PyPtr,
              (PyPtr, Ptr{Uint8}), o, bytestring(s))
    if p == C_NULL
        throw(KeyError(s))
    end
    return PyObject(p)
end

ref(o::PyObject, s::Symbol) = ref(o, string(s))

#########################################################################

function pyimport(name::String)
    pyinitialize()
    mod = PyObject(ccall(pyfunc(:PyImport_ImportModule), PyPtr,
                         (Ptr{Uint8},), bytestring(name)))
    # fixme: check for errors
    return mod
end

pyimport(name::Symbol) = pyimport(string(name))

# look up a global variable (in module __main__)
function pyglobal(name::String)
    pyinitialize()
    # fixme: check for errors
    return PyObject(ccall(pyfunc(:PyObject_GetAttrString), PyPtr,
                          (PyPtr, Ptr{Uint8}), 
                          ccall(pyfunc(:PyImport_AddModule), PyPtr,
                                (Ptr{Uint8},), bytestring("__main__")),
                          bytestring(name)))
end

pyglobal(name::Symbol) = pyglobal(string(name))

#########################################################################

function pycall(o::PyObject, returntype::Union(Type,(Type...)), args...)
    pyinitialize()
    oargs = map(PyObject, args)
    # would rather call PyTuple_Pack, but calling varargs functions
    # with ccall and argument splicing seems problematic right now.
    arg = PyObject(ccall(pyfunc(:PyTuple_New), PyPtr, (Int,), 
                         length(args)))
    if arg.o == C_NULL
        error("failure creating Python argument tuple")
    end
    for i = 1:length(args)
        if 0 != ccall(pyfunc(:PyTuple_SetItem), Int32, (PyPtr,Int,PyPtr),
                      arg, i-1, oargs[i])
            error("error setting Python argument tuple")
        end
        # PyTuple_SetItem steals the reference.  (Note: Don't
        # set oargs[i].o to C_NULL here, since the original arg
        # might itself have been a PyObject and we don't want
        # it to "lose" its object.  IncRef instead.)
        pyincref(oargs[i])
    end
    ret = PyObject(ccall(pyfunc(:PyObject_CallObject), PyPtr,
                         (PyPtr,PyPtr), o, arg))
    if ret.o == C_NULL
        error("failure calling Python function")
    end
    jret = convert(returntype, ret)
    # TODO: check for errors
    return jret
end

#########################################################################

end # module PyCall
