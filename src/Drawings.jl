module Drawings # Poptart

import ..Interfaces: properties
using Colors: RGBA

export Line, Rect, RectMultiColor, Circle, Quad, Triangle, Arc, Pie, Curve, Polyline, Polygon
export TextBox
export stroke, fill
export scale, translate

abstract type DrawingElement end

include("Drawings/drawing_elements.jl")
include("Drawings/transform.jl")

end # module Poptart.Drawings
