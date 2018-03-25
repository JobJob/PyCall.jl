using Compat.Test, PyCall, Compat

pyutf8(s::PyObject) = pycall(s["encode"], PyObject, "utf-8")
pyutf8(s::String) = pyutf8(PyObject(s))


const np = pyimport("numpy")

# buffers
let b = PyCall.PyBuffer(pyutf8("test string"))
    @test ndims(b) == 1
    @test (length(b),) == (length("test string"),) == (size(b, 1),) == size(b)
    @test stride(b, 1) == 1
    @test PyCall.iscontiguous(b) == true
end

@testset "Non-native-endian" begin
    wrong_endian_str = ENDIAN_BOM == 0x01020304 ? "<" : ">"
    wrong_endian_arr = pycall(np["ndarray"], PyObject, 2; buffer=UInt8[0,1,3,2],
                                                    dtype=wrong_endian_str*"i2")
    @test_throws ErrorException ArrayFromBuffer(wrong_endian_arr)
end
