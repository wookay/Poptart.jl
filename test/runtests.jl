ENV["POPTART_AUTO_CLOSE"] = true

using Jive
runtests(@__DIR__, skip=["revise.jl"])
