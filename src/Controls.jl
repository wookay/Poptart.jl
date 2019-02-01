module Controls # Poptart

import ..Props: properties

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

export CheckBox
include("Controls/checkbox.jl")

export Radio
include("Controls/radio.jl")

export ProgressBar
include("Controls/progressbar.jl")

export ImageView
include("Controls/imageview.jl")

export Canvas
include("Controls/canvas.jl")

end # module Poptart.Controls
