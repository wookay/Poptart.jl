module Desktop # Poptart

using ..Controls

include("Desktop/types.jl")

export Windows, put!, remove!
include("Desktop/Windows.jl")

export Application
include("Desktop/application.jl")

include("Desktop/Themes.jl")

end # module Poptart.Desktop
