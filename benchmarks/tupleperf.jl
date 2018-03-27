using PyCall, BenchmarkTools

results = Dict{String,Any}()
let
    np = pyimport("numpy")
    nprandint = np["random"]["randint"]
    nprand = np["random"]["rand"]
    res = PyNULL()

    tuplen = 16
    tpl = convert(PyObject, (1:tuplen...))

    # tplidx = rand(0:(tuplen-1))
    # results["standard get"] = @benchmark get($tpl, PyObject, $tplidx)
    # println("standard get:\n", results["standard get"])
    #
    # tplidx = rand(0:(tuplen-1))
    # results["get!"] = @benchmark get!($res, $tpl, PyObject, $tplidx)
    # println("get!:\n", results["get!"])
    #
    # tplidx = rand(0:(tuplen-1))
    # results["get with pyint"] = @benchmark getpyint($tpl, PyObject, $tplidx)
    # println("get with pyint, tplidx: $tplidx:\n", results["get with pyint"])
    #
    # tplidx = rand(0:(tuplen-1))
    # results["get! with pyint"] = @benchmark getpyint!($res, $tpl, PyObject, $tplidx)
    # println("get! with pyint, tplidx: $tplidx:\n", results["get! with pyint"])
    #
    # tplidx = rand(0:(tuplen-1))
    # results["gettplidx"] = @benchmark gettplidx($tpl, PyObject, $tplidx)
    # println("gettplidx:\n", results["gettplidx"])
    #
    tplidx = rand(0:(tuplen-1))
    results["gettplidx!"] = @benchmark gettplidx!($res, $tpl, PyObject, $tplidx)
    println("gettplidx!:\n", results["gettplidx!"])

    tplidx = rand(0:(tuplen-1))
    results["getwcheck!"] = @benchmark getwcheck!($res, $tpl, PyObject, $tplidx)
    println("getwcheck!:\n", results["getwcheck!"])

    tplidx = rand(0:(tuplen-1))
    results["getwpyisinst!"] = @benchmark getwpyisinst!($res, $tpl, PyObject, $tplidx)
    println("getwpyisinst!:\n", results["getwpyisinst!"])

    tplidx = rand(0:(tuplen-1))
    results["pytuple_get_item!"] = @benchmark pytuple_get_item!($res, $tpl, PyObject, $tplidx)
    println("pytuple_get_item!:\n", results["pytuple_get_item!"])
end
results
