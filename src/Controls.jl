module Controls # Poptart

export put!, remove!
import ..Interfaces: properties, put!, remove!
using ..Drawings: Drawing
using Nuklear.LibNuklear: NK_TEXT_LEFT
using Colors: RGBA

abstract type UIControl end

export Mouse
include("Controls/Mouse.jl")

export UIControl, willSet, didSet, willSend, didSend, didClick, onHover
include("Controls/uicontrol.jl")

export Button
include("Controls/button.jl")

export Slider
include("Controls/slider.jl")

export Property
include("Controls/property.jl")

export Label, SelectableLabel
include("Controls/label.jl")

export CheckBox
include("Controls/checkbox.jl")

export Radio
include("Controls/radio.jl")

export ComboBox
include("Controls/combobox.jl")

export ProgressBar
include("Controls/progressbar.jl")

export ImageView
include("Controls/imageview.jl")

export Canvas
include("Controls/canvas.jl")

export StaticRow, DynamicRow, Spacing
include("Controls/layout.jl")

export ToolTip
include("Controls/tooltip.jl")

export Chart
include("Controls/chart.jl")

end # module Poptart.Controls
