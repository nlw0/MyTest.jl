module MyTest

using ForwardDiff
using LeastSquaresOptim
using CoordinateTransformations
using LinearAlgebra: norm


# struct HarrisDistortion{V} <: Transformation
#     κ::V
# end

# function (H::HarrisDistortion{V})(x) where {V}
#     χ = norm(x)
#     g = max(0, 1 - 2 * H.κ * χ^2)^-(1//2)
#     g * x
# end

# function Base.inv(H::HarrisDistortion)
#     HarrisDistortion(-H.κ)
# end

function gendata()
    psim = randn(6)
    M = reshape(psim[1:4], 2,2)
    v = psim[4:5]
    # Dist = HarrisDistortion(randn()*0.2)
    T = AffineMap(M, v) #∘ Dist

    Npt = 111
    xx = rand(2,Npt)
    yy = mapslices(T, xx, dims=1)

    xx, yy, psim
end

# result = optimize!(LeastSquaresProblem(x = p0, f! = residue!, output_length = prod(size(yy)), autodiff=:forward), LevenbergMarquardt())

function dofit(xx,yy)
    function residue!(out, p)
        xx, yy

        OO = reshape(out, 2, :)
        M = reshape(p[1:4], 2,2)
        v = p[5:6]
        # Dist = HarrisDistortion(p[7])
        T = AffineMap(M,v) #∘ Dist
        OO .= yy - mapslices(T, xx, dims=1)
        nothing
    end

    p0 = [1.0, 0.0, 0.0, 1.0, 0.0, 0.0] #, 0.0]

    optimize!(LeastSquaresProblem(x = p0, f! = residue!, output_length = prod(size(yy)), autodiff=:forward), LevenbergMarquardt())
end

include("precompile.jl")
_precompile_()

end # module
