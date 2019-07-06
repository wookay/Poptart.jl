module Drawings # Poptart

import ..Interfaces: properties
using Colors: RGBA

export Line, Rect, RectMultiColor, Circle, Triangle, Arc, Curve, Polyline, Polygon
export TextBox, ImageBox
export stroke, fill
export scale, translate

abstract type DrawingElement end

include("Drawings/drawing_elements.jl")
# include("Drawings/transform.jl")

end # module Poptart.Drawings
