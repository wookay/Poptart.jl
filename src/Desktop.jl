module Desktop # Poptart

using ..Controls
include("Desktop/types.jl")

export Windows, Window, put!, remove!
include("Desktop/Windows.jl")
using .Windows: Window

export Application
include("Desktop/application.jl")

end # module Poptart.Desktop
