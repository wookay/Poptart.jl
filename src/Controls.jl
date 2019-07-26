module Controls # Poptart

export put!, remove!
import ..Interfaces: properties, put!, remove!
using ..Drawings: Drawing, TextBox
using Colors: RGBA

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

export Canvas
include("Controls/canvas.jl")

export ScatterPlot, Spy, BarPlot, LinePlot, Histogram
include("Controls/plots.jl")

export Group, Separator, SameLine, NewLine, Spacing
include("Controls/layouts.jl")

end # module Poptart.Controls
