using Base: sigatomic_begin, sigatomic_end
using PyCall: @pycheckz, TypeTuple, pydecref_

"""
Low-level version of `pycall(o, ...)` that always returns `PyObject`.
"""
function _pycall_legacy!(ret::PyObject, o::Union{PyObject,PyPtr}, args, kwargs)
    # oargs = map(PyObject, args)
    nargs = length(args)
    sigatomic_begin()
    pyargsptr = @pycheckn ccall((@pysym :PyTuple_New), PyPtr, (Int,), nargs)
    try
        # arg = PyObject(@pycheckn ccall((@pysym :PyTuple_New), PyPtr, (Int,),
        #                                nargs))
        for i = 1:nargs
            pyarg = PyObject(args[i])
            @pycheckz ccall((@pysym :PyTuple_SetItem), Cint,
                             (PyPtr,Int,PyPtr), pyargsptr, i-1, pyarg)
                             # (PyPtr,Int,PyPtr), arg, i-1, oargs[i])
            pyincref(pyarg) # PyTuple_SetItem steals the reference
            # pyincref(oargs[i]) # PyTuple_SetItem steals the reference
        end
    catch

    end
    try
        if isempty(kwargs)
            # ret = PyObject(@pycheckn ccall((@pysym :PyObject_Call), PyPtr,
            #                               (PyPtr,PyPtr,PyPtr), o, pyargsptr, C_NULL))
                                          # (PyPtr,PyPtr,PyPtr), o, arg, C_NULL))
            kw = C_NULL
        else
            #kw = PyObject((AbstractString=>Any)[string(k) => v for (k, v) in kwargs])
            kw = PyObject(Dict{AbstractString, Any}([Pair(string(k), v) for (k, v) in kwargs]))
            # ret = PyObject(@pycheckn ccall((@pysym :PyObject_Call), PyPtr,
            #                                 (PyPtr,PyPtr,PyPtr), o, pyargsptr, kw))
                                            # (PyPtr,PyPtr,PyPtr), o, arg, kw))
        end
        pydecref_(ret.o)
        ret.o = @pycheckn ccall((@pysym :PyObject_Call), PyPtr,
                                        (PyPtr,PyPtr,PyPtr), o, pyargsptr, kw)
        # return ret::PyObject
        return ret
    finally
        sigatomic_end()
    end
end

"""
    pycall(o::Union{PyObject,PyPtr}, returntype::TypeTuple, args...; kwargs...)

Call the given Python function (typically looked up from a module) with the given args... (of standard Julia types which are converted automatically to the corresponding Python types if possible), converting the return value to returntype (use a returntype of PyObject to return the unconverted Python object reference, or of PyAny to request an automated conversion)
"""
pycall_legacy(o::Union{PyObject,PyPtr}, returntype::TypeTuple, args...; kwargs...) =
    return convert(returntype, _pycall_legacy!(PyNULL(), o, args, kwargs)) #::returntype

pycall_legacy(o::Union{PyObject,PyPtr}, ::Type{PyAny}, args...; kwargs...) =
    return convert(PyAny, _pycall_legacy!(PyNULL(), o, args, kwargs))

pycall_legacy!(ret::PyObject, o::Union{PyObject,PyPtr}, returntype::TypeTuple, args...; kwargs...) =
    return convert(returntype, _pycall_legacy!(ret, o, args, kwargs)) #::returntype

pycall_legacy!(ret::PyObject, o::Union{PyObject,PyPtr}, ::Type{PyAny}, args...; kwargs...) =
    return convert(PyAny, _pycall_legacy!(ret, o, args, kwargs))
