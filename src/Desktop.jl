module Desktop # Poptart

using ..Controls
include("Desktop/types.jl")

export Windows, Window, put!, remove!
include("Desktop/Windows.jl")
using .Windows: Window

include("Desktop/Shortcuts.jl")

export Application, pause, resume
include("Desktop/application.jl")

export FontAtlas
include("Desktop/FontAtlas.jl")

end # module Poptart.Desktop
