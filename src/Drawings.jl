module Drawings # Poptart

import ..Interfaces: properties
using Colors: RGBA

export Line, Rect, RectMultiColor, Circle, Quad, Triangle, Arc, Pie, Curve, Polyline, Polygon, TextBox, ImageBox
export stroke, fill
export translate, scale, translate!, scale!

abstract type DrawingElement end

include("Drawings/drawing_elements.jl")
include("Drawings/transform.jl")

end # module Poptart.Drawings
