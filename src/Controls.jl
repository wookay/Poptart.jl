module Controls # Poptart

abstract type UIControl end

export Mouse
include("Controls/Mouse.jl")

export UIControl, willSet, didSet, willSend, didSend, didClick
include("Controls/uicontrol.jl")

export Button
include("Controls/button.jl")

export Slider
include("Controls/slider.jl")

export Label
include("Controls/label.jl")

end # module Poptart.Controls
