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

export Label, SelectableLabel
include("Controls/label.jl")

export Checkbox
include("Controls/checkbox.jl")

export Radio
include("Controls/radio.jl")

export ProgressBar
include("Controls/progressbar.jl")

export ImageView
include("Controls/imageview.jl")

end # module Poptart.Controls
