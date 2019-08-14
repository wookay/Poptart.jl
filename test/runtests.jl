ENV["POPTART_AUTO_CLOSE"] = true

using Jive

if haskey(ENV, "TRAVIS")
    travis_skip = ENV["TRAVIS_OS_NAME"] == "linux" ? [] : ["cimgui", "poptart/desktop"]
else
    travis_skip = []
end
runtests(@__DIR__, skip=["revise.jl", travis_skip...])
