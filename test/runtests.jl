ENV["POPTART_AUTO_CLOSE"] = true

using Jive
travis_skip = haskey(ENV, "TRAVIS") && ENV["TRAVIS_OS_NAME"] == "osx" ? ["cimgui", "poptart/desktop"] : []
runtests(@__DIR__, skip=["revise.jl", travis_skip...])
