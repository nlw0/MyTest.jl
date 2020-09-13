function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    Base.precompile(Tuple{typeof(dofit),Matrix{Float64},Matrix{Float64}})
end
