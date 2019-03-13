module Controls # Poptart

export put!, remove!
import ..Interfaces: properties, put!, remove!
using ..Drawings: Drawing, TextBox
using Nuklear.LibNuklear: NK_TEXT_LEFT, NK_POPUP_STATIC, NK_WINDOW_CLOSABLE, NK_WINDOW_BORDER, NK_TREE_TAB, NK_MINIMIZED
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

export Chart, MixedChart
include("Controls/chart.jl")

export ImageView
include("Controls/imageview.jl")

export StaticRow, DynamicRow, Spacing, Group
include("Controls/layout.jl")

export ToolTip
include("Controls/tooltip.jl")

export Popup
include("Controls/popup.jl")

export MenuBar, Menu, MenuItem
include("Controls/menubar.jl")

export Contextual, ContextualItem
include("Controls/contextual.jl")

export TreeItem
include("Controls/tree.jl")

export Canvas, TextBox
include("Controls/canvas.jl")

end # module Poptart.Controls
