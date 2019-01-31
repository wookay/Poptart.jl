using Revise, Jive
using Poptart
watch(@__DIR__, sources=[pathof(Poptart)]) do path
    @info :changed path
    revise()
    runtests(@__DIR__, targets=ARGS, skip=["revise.jl"])
end
# Jive.stop(watch)
