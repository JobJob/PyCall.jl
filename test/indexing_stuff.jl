################################################################################
############################ PyCall Indexing Stuff #############################
################################################################################
#---
using Compat: ind2sub
methods(ind2sub)
#---
pointer(x, 10)
#---
xr
#---
@benchmark x[:,:,:]
#---
IndexStyle(xr)
A = xr
@benchmark to_indices(A, (:,:,:,1))
#---
const inds = to_indices(A, (:,:,:,1))
@benchmark Base._getindex(IndexStyle(A), A, inds...)
#---
using Profile
#---
Profile.clear()
@profile x[:,:,:,1]
#---

#---
using ProfileView
ProfileView.view()
#---
@which xr[:,:,:,1]
#---
@benchmark xr[:,:,:,1]
#---
@benchmark xjl[1]
#---
const i2sc = CartesianIndices(x)
@benchmark x[i2sc[7]]
#---
@benchmark x[7,1,1]
#---
@benchmark xjl[7,1,1]
#---
IndexStyle(typeof(x))
#---
Base.broadcastable(1)
#---
@code_typed x[7]
#---
out = net(obs)
outs = [net[1:i](obs) for i in 1:length(net)]
#---
################################################################################
################################################################################
################################################################################
# Array indecing benchmarks, for upcoming PyCall PR
using BenchmarkTools
testarr(dims...) = reshape(1:prod(dims), dims...) |> collect

mutable struct SArr{T,N} <: DenseArray{T,N}
    a::Array{T,N}
end
Base.stride(a::SArr, i::Integer) = Base.stride(a.a, i)
Base.strides(a::SArr)            = Base.strides(a.a)
Base.unsafe_convert(::Type{Ptr{T}}, a::SArr{T}) where {T} =
    Base.unsafe_convert(Ptr{T}, a.a)
Base.size(a::SArr) = size(a.a)
Base.getindex(a::SArr, i...) = getindex(a.a, i...)
#---
sa = SArr(zeros(3,2))
@benchmark sa[4]
#---
################################################################################
################################################################################
################################################################################
