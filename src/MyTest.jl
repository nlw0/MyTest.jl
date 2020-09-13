module MyTest

using ForwardDiff
using LeastSquaresOptim
using CoordinateTransformations
using LinearAlgebra: norm


function gendata()
    psim = randn(6)
    M = reshape(psim[1:4], 2,2)
    v = psim[4:5]
    T = AffineMap(M, v)

    Npt = 111
    xx = rand(2,Npt)
    yy = mapslices(T, xx, dims=1)

    xx, yy, psim
end

result = optimize!(LeastSquaresProblem(x = p0, f! = residue!, output_length = prod(size(yy)), autodiff=:forward), LevenbergMarquardt())

function dofit(xx,yy)
    function residue!(out, p)
        xx, yy

        OO = reshape(out, 2, :)
        M = reshape(p[1:4], 2,2)
        v = p[5:6]
        T = AffineMap(M,v)
        OO .= yy - mapslices(T, xx, dims=1)
        nothing
    end

    p0 = [1.0, 0.0, 0.0, 1.0, 0.0, 0.0] #, 0.0]

    optimize!(LeastSquaresProblem(x = p0, f! = residue!, output_length = prod(size(yy)), autodiff=:forward), LevenbergMarquardt())
end

include("precompile.jl")
_precompile_()

end # module
