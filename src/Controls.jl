module Controls # Poptart

export put!, remove!
import ..Interfaces: properties, put!, remove!
using ..Drawings: Drawing, TextBox, ImageBox
using Colors: RGBA

abstract type UIControl end

export UIControl, willSet, didSet, willSend, didSend, didClick
include("Controls/uicontrol.jl")

export Canvas
include("Controls/canvas.jl")

end # module Poptart.Controls
