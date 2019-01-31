using Jive
travis_skip = haskey(ENV, "TRAVIS") ? ["poptart/desktop"] : []
runtests(@__DIR__, skip=["revise.jl", travis_skip...])
