using Jive
travis = haskey(ENV, "TRAVIS") ? ["poptart/desktop/application.jl"] : []
runtests(@__DIR__, skip=["revise.jl", travis...])
