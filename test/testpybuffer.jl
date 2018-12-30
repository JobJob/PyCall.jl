using Compat.Test, PyCall, Compat
using PyCall: f_contiguous, PyBUF_ND_CONTIGUOUS, array_format

pyutf8(s::PyObject) = pycall(s["encode"], PyObject, "utf-8")
pyutf8(s::String) = pyutf8(PyObject(s))

@testset "PyBuffer" begin
    np = pyimport("numpy")
    nparr = np["array"]
    listpy = pybuiltin("list")
    arrpyo(args...; kwargs...)  = pycall(nparr, PyObject, args...; kwargs...)
    listpyo(args...) = pycall(listpy, PyObject, args...)
    pytestarray(sz::Int...; order="C") =
        pycall(arrpyo(1.0:prod(sz), "d")["reshape"], PyObject, sz, order=order)

    @testset "String Buffers" begin
        b = PyCall.PyBuffer(pyutf8("test string"))
        @test ndims(b) == 1
        @test (length(b),) == (length("test string"),) == (size(b, 1),) == size(b)
        @test stride(b, 1) == 1
        @test PyCall.iscontiguous(b) == true
    end

    if !npy_initialized
        println(stderr, "Warning: skipping array related buffer tests since NumPy not available")
    else
        np = pyimport("numpy")
        listpy = pybuiltin("list")
        arrpyo(args...; kwargs...) =
            pycall(np["array"], PyObject, args...; kwargs...)
        listpyo(args...) = pycall(listpy, PyObject, args...)
        pytestarray(sz::Int...; order="C") =
            pycall(arrpyo(1.0:prod(sz), "d")["reshape"], PyObject, sz, order=order)

        # f_contiguous(T, sz, st)
        @testset "f_contiguous 1D" begin
            # contiguous case: stride == sizeof(T)
            @test f_contiguous(Float64, (4,), (8,)) == true
            # non-contiguous case: stride != sizeof(T)
            @test f_contiguous(Float64, (4,), (16,)) == false
        end

        @testset "f_contiguous 2D" begin
            # contiguous: st[1] == sizeof(T), st[2] == st[1]*sz[1]
            @test f_contiguous(Float64, (4, 2), (8, 32)) == true
            # non-contiguous: stride != sizeof(T), but st[2] == st[1]*sz[1]
            @test f_contiguous(Float64, (4, 2), (16, 64)) == false
            # non-contiguous: stride == sizeof(T), but st[2] != st[1]*sz[1]
            @test f_contiguous(Float64, (4, 2), (8, 64)) == false
        end

        @testset "copy f_contig 1d" begin
            apyo = arrpyo(1.0:10.0, "d")
            pyarr = PyArray(apyo)
            jlcopy = copy(pyarr)
            @test pyarr.f_contig == true
            @test pyarr.c_contig == true
            @test all(jlcopy .== pyarr)
            # check it's not aliasing the same data
            jlcopy[1] = -1.0
            @test pyarr[1] == 1.0
        end

        @testset "copy c_contig 2d" begin
            apyo = pytestarray(2,3) # arrpyo([[1,2,3],[4,5,6]], "d")
            pyarr = PyArray(apyo)
            jlcopy = copy(pyarr)
            @test pyarr.c_contig == true
            @test pyarr.f_contig == false
            # check all is in order
            for i in 1:size(pyarr, 1)
                for j in 1:size(pyarr, 1)
                    @test jlcopy[i,j] == pyarr[i,j]
                end
            end
            # check it's not aliasing the same data
            jlcopy[1,1] = -1.0
            @test pyarr[1,1] == 1.0
        end

        @testset "Non contiguous PyArrays" begin
            @testset "1d non-contiguous" begin
                # create an array of four Int32s, with stride 8
                nparr = pycall(np["ndarray"], PyObject, 4,
                                buffer=UInt32[1,0,1,0,1,0,1,0],
                                dtype="i4", strides=(8,))
                pyarr = PyArray(nparr)

                # The convert goes via a PyArray then a `copy`
                @test convert(PyAny, nparr) == [1, 1, 1, 1]

                @test eltype(pyarr) == Int32
                @test sizeof(eltype(pyarr)) == 4
                @test pyarr.info.st == (8,)
                # not f_contig because not contiguous
                @test pyarr.f_contig == false
                @test copy(pyarr) == Int32[1, 1, 1, 1]
            end

            @testset "2d non-contiguous" begin
                nparr = pycall(np["ndarray"], PyObject,
                                buffer=UInt32[1,0,2,0,1,0,2,0,
                                              1,0,2,0,1,0,2,0], order="f",
                                dtype="i4", shape=(2, 4), strides=(8,16))
                pyarr = PyArray(nparr)

                # The convert goes via a PyArray then a `copy`
                @test convert(PyAny, nparr) == [1 1 1 1; 2 2 2 2]
                pyarr = convert(PyArray, nparr)
                @test eltype(pyarr) == Int32
                @test pyarr.info.st == (8, 16)
                # not f_contig because not contiguous
                @test pyarr.f_contig == false
                @test copy(pyarr) == Int32[1 1 1 1; 2 2 2 2]
            end
        end

        @testset "NoCopyArray 1d" begin
            ao = arrpyo(1.0:10.0, "d")
            pybuf = PyBuffer(ao, PyBUF_ND_CONTIGUOUS)
            T, native_byteorder = array_format(pybuf)
            @test T == Float64
            @test native_byteorder == true
            @test size(pybuf) == (10,)
            @test strides(pybuf) == (1,) .* sizeof(T)
            nca = NoCopyArray(ao)
            @test !(nca isa PermutedDimsArray)
            @test nca isa Array
            @test nca[3] == ao[3]
            @test nca[4] == ao[4]
        end

        @testset "NoCopyArray 1d" begin
            ao = arrpyo(1.0:10.0, "d")
            pybuf = PyBuffer(ao, PyBUF_ND_CONTIGUOUS)
            T, native_byteorder = array_format(pybuf)
            @test T == Float64
            @test native_byteorder == true
            @test size(pybuf) == (10,)
            @test strides(pybuf) == (1,) .* sizeof(T)
            nca = NoCopyArray(ao)
            @test !(nca isa PermutedDimsArray)
            @test nca isa Array
            @test nca[3] == ao[3]
            @test nca[4] == ao[4]
        end

        @testset "NoCopyArray 2d f-contig" begin
            ao = arrpyo(reshape(1.0:12.0, (3,4)), "d", order="F")
            pybuf = PyBuffer(ao, PyBUF_ND_CONTIGUOUS)
            T, native_byteorder = array_format(pybuf)
            @test T == Float64
            @test native_byteorder == true
            @test size(pybuf) == (3,4)
            @test strides(pybuf) == (1, 3) .* sizeof(T)
            nca = NoCopyArray(ao)
            @test !(nca isa PermutedDimsArray)
            # @show typeof(nca) (nca isa Array)
            @test nca isa Array
            @test size(nca) == (3,4)
            @test strides(nca) == (1,3)
            @test nca[3,2] == ao[3,2]
            @test nca[2,3] == ao[2,3]
        end

    @testset "isbuftype" begin
        @test isbuftype(PyObject(0)) == false
        @test isbuftype(listpyo((1.0:10.0...,))) == false
        @test isbuftype(arrpyo(1.0:10.0, "d")) == true
        @test isbuftype(PyObject([1:10...])) == true
    end
end
