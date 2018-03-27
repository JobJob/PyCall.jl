using PyCall, BenchmarkTools

results = Dict{String,Any}()

let
    np = pyimport("numpy")
    nprand = np["random"]["rand"]
    nprand_pyo(sz...) = pycall(nprand, PyObject, sz...)
    nprand2d_wrap = PyFuncWrap(nprand, typeof((Int, Int)))

    arr_size = (2,2)
    
    results["nprand_pyo"] = @benchmark $nprand_pyo($arr_size...)
    println("nprand_pyo:\n", results["nprand_pyo"])

    results["nprand2d_wrap"] = @benchmark $nprand2d_wrap($arr_size...)
    println("nprand2d_wrap:\n", results["nprand2d_wrap"])

    # args already set by nprand2d_wrap calls above
    results["nprand2d_wrap_noargs"] = @benchmark $nprand2d_wrap()
    println("nprand2d_wrap_noargs:\n", results["nprand2d_wrap_noargs"])
end
results
