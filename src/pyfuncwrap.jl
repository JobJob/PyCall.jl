struct PyFuncWrap{P<:Union{PyObject,PyPtr}, AT<:Tuple, N, RT}
    o::P
    oargs::Vector{PyObject}
    pyargsptr::PyPtr
    ret::PyObject
end

"""
```
PyFuncWrap(o::P, argtypes::Type{AT}, returntype::Type{RT})
```

Wrap a callable PyObject/PyPtr to reduce the number of allocations made for
passing its arguments, and its return value, sometimes providing a speedup.
Mainly useful for functions called in a tight loop, particularly if their
arguments don't change.
```
@pyimport numpy as np
rand22fn =
```
"""
function PyFuncWrap(o::P, argtypes::Type{AT}, returntype::Type{RT}=PyObject) where
        {P<:Union{PyObject,PyPtr}, AT<:Tuple, RT}
    isvatuple(AT) && error("Vararg functions not supported, arg signature provided: $AT")
    N = tuplen(AT)
    oargs = Array{PyObject}(N)
    pyargsptr = ccall((@pysym :PyTuple_New), PyPtr, (Int,), N)
    return PyFuncWrap{P, AT, N, RT}(o, oargs, pyargsptr, PyNULL())
end

function setargs(pf::PyFuncWrap{P, AT, N, RT}, args...) where {P, AT, RT, N}
    for i = 1:N
        setarg(pf, args[i], i)
    end
    nothing
end

function setarg(pf::PyFuncWrap{P, AT, N, RT}, arg, i::Int=1) where {P, AT, N, RT}
    pf.oargs[i] = PyObject(arg)
    @pycheckz ccall((@pysym :PyTuple_SetItem), Cint,
                     (PyPtr,Int,PyPtr), pf.pyargsptr, i-1, pf.oargs[i])
    pyincref(pf.oargs[i]) # PyTuple_SetItem steals the reference
    nothing
end

function (pf::PyFuncWrap{P, AT, N, RT})(args...)::RT where {P, AT, N, RT}
    setargs(pf, args...)
    return pf()
end

"""
Warning: if pf(args) or setargs(pf, ...) hasn't been called yet, this will likely segfault
"""
function (pf::PyFuncWrap{P, AT, N, RT})()::RT where {P, AT, N, RT}
    sigatomic_begin()
    try
        kw = C_NULL
        retptr = ccall((@pysym :PyObject_Call), PyPtr, (PyPtr,PyPtr,PyPtr), pf.o,
                        pf.pyargsptr, kw)
        pyincref_(retptr)
        pf.ret.o = retptr
    finally
        sigatomic_end()
    end
    convert(RT, pf.ret)
end
