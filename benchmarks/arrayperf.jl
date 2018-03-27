using PyCall, BenchmarkTools

results = Dict{String,Any}()

let
    np = pyimport("numpy")
    nprand = np["random"]["rand"]

    nprand_pyo(sz...) = pycall(nprand, PyObject, sz...)
    nprand_pya(sz...) = pycall(nprand, PyArray, sz...)

    function nprand_pybufarr(sz...)
        apyobj = pycall(nprand, PyObject, sz...)
        arr = ArrayFromBuffer(apyobj)
        arr
    end

    function nprand_setdata!(arr::PyArray, sz...)
        apyobj = pycall(nprand, PyObject, sz...)
        setdata!(arr, apyobj)
        arr
    end
    arr_size = (2,2)

    results["nprand_pya"] = @benchmark $nprand_pya($arr_size...)
    println("nprand_pya:\n", results["nprand_pya"])

    results["nprand_pybufarr"] = @benchmark $nprand_pybufarr($arr_size...)
    println("nprand_pybufarr:\n", results["nprand_pybufarr"])

    pyarr = nprand_pya(arr_size...)
    results["nprand_setdata!"] = @benchmark $nprand_setdata!($pyarr, $arr_size...)
    println("nprand_setdata!:\n", results["nprand_setdata!"])

    arr_size = (100,100)

    results["nprand_pya"] = @benchmark $nprand_pya($arr_size...)
    println("nprand_pya:\n", results["nprand_pya"])

    results["nprand_pybufarr"] = @benchmark $nprand_pybufarr($arr_size...)
    println("nprand_pybufarr:\n", results["nprand_pybufarr"])

    pyarr = nprand_pya(arr_size...)
    results["nprand_setdata!"] = @benchmark $nprand_setdata!($pyarr, $arr_size...)
    println("nprand_setdata!:\n", results["nprand_setdata!"])

end
results
