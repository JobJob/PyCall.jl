using PyCall, BenchmarkTools, DataStructures

# These would be put in __init__
PyCall.pyints[] = [PyObject(i) for i in 0:PyCall.MAX_PYINT]
PyCall.pytuple_type_ptr[] = cglobal(@pysym :PyTuple_Type)

results = OrderedDict{String,Any}()
let
    np = pyimport("numpy")
    nprandint = np["random"]["randint"]
    nprand = np["random"]["rand"]
    res = PyNULL()

    tuplen = 16
    tpl = convert(PyObject, (1:tuplen...))

    tplidx = rand(0:(tuplen-1))
    results["standard get"] = @benchmark get($tpl, PyObject, $tplidx)
    println("standard get:\n"); display(results["standard get"])
    println("--------------------------------------------------")

    tplidx = rand(0:(tuplen-1))
    pytplidx = PyObject(tplidx)
    results["get with pyint"] = @benchmark get($tpl, PyObject, $pytplidx)
    println("get with pyint, tplidx: $tplidx:\n"); display(results["get with pyint"])
    println("--------------------------------------------------")

    tplidx = rand(0:(tuplen-1))
    results["get!"] = @benchmark get!($res, $tpl, PyObject, $tplidx)
    println("get!:\n"); display(results["get!"])
    println("--------------------------------------------------")

    tplidx = rand(0:(tuplen-1))
    pytplidx = PyObject(tplidx)
    results["get! with pyint"] = @benchmark get!($res, $tpl, PyObject, $pytplidx)
    println("get! with pyint, tplidx: $tplidx:\n"); display(results["get! with pyint"])
    println("--------------------------------------------------")

    tplidx = rand(0:(tuplen-1))
    results["get! pyint < $(PyCall.MAX_PYINT)"] = @benchmark getpyint!($res, $tpl, PyObject, $tplidx)
    println("get! pyint < $(PyCall.MAX_PYINT), tplidx: $tplidx:\n"); display(results["get! pyint < $(PyCall.MAX_PYINT)"])
    println("--------------------------------------------------")

    tplidx = rand(0:(tuplen-1))
    results["getwpyisinst!"] = @benchmark getwpyisinst!($res, $tpl, PyObject, $tplidx)
    println("getwpyisinst!:\n"); display(results["getwpyisinst!"])
    println("--------------------------------------------------")

    tplidx = rand(0:(tuplen-1))
    results["getwcheck!"] = @benchmark getwcheck!($res, $tpl, PyObject, $tplidx)
    println("getwcheck!:\n"); display(results["getwcheck!"])
    println("--------------------------------------------------")

    tplidx = rand(0:(tuplen-1))
    results["pytuple_GET_ITEM!"] = @benchmark pytuple_GET_ITEM!($res, $tpl, PyObject, $tplidx)
    println("pytuple_GET_ITEM!:\n"); display(results["pytuple_GET_ITEM!"])
    println("--------------------------------------------------")
end

println("")
println("Mean times")
println("----------")
foreach((r)->println(rpad(r[1],20), ": ", mean(r[2])), results)
