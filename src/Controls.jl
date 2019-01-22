module Controls # Poptart

export UIControl, willSet, didSet, willSend, didSend
include("Controls/uicontrol.jl")

export Button
include("Controls/button.jl")

export Slider
include("Controls/slider.jl")

end # module Poptart.Controls
