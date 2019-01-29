module Desktop # Poptart

using ..Controls

include("Desktop/types.jl")

export Windows
include("Desktop/Windows.jl")

export Application
include("Desktop/application.jl")

end # module Poptart.Desktop
