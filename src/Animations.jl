module Animations # Poptart

export CubicBezier, Ease, Linear, EaseIn, EaseOut, EaseInOut
include("Animations/timing-functions.jl")

export Second
include("Animations/periods.jl")

include("Animations/chronicle.jl")

export animate, lerp
include("Animations/animate.jl")

end # module Poptart.Animations
