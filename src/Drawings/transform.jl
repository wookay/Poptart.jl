# module Poptart.Drawings

function transform(tup::Tuple{Real,Real}, f, xy::Tuple{Real,Real})::Tuple{Real,Real}
    broadcast(f, tup, xy)
end

"""
    translate(tup::Tuple{Real,Real}, xy::Tuple{Real,Real})
"""
function translate(tup::Tuple{Real,Real}, xy::Tuple{Real,Real})
    transform(tup, +, xy)
end

"""
    translate(tup::Tuple{Real,Real}, x::Real)
"""
function translate(tup::Tuple{Real,Real}, x::Real)
    translate(tup, (x, x))
end

"""
    scale(tup::Tuple{Real,Real}, xy::Tuple{Real,Real})
"""
function scale(tup::Tuple{Real,Real}, xy::Tuple{Real,Real})
    transform(tup, *, xy)
end

"""
    scale(tup::Tuple{Real,Real}, x::Real)
"""
function scale(tup::Tuple{Real,Real}, x::Real)
    scale(tup, (x, x))
end

function transform(tup::Tuple{Real,Real,Real,Real}, f, xy::Tuple{Real,Real})::Tuple{Real,Real,Real,Real}
    a = broadcast(f, tup[1:2], xy)
    b = broadcast(f, tup[3:4], xy)
    tuple(a..., b...)
end

"""
    translate(tup::Tuple{Real,Real,Real,Real}, xy::Tuple{Real,Real})
"""
function translate(tup::Tuple{Real,Real,Real,Real}, xy::Tuple{Real,Real})
    transform(tup, +, xy)
end

"""
    translate(tup::Tuple{Real,Real,Real,Real}, x::Real)
"""
function translate(tup::Tuple{Real,Real,Real,Real}, x::Real)
    translate(tup, (x, x))
end

"""
    scale(tup::Tuple{Real,Real,Real,Real}, xy::Tuple{Real,Real})
"""
function scale(tup::Tuple{Real,Real,Real,Real}, xy::Tuple{Real,Real})
    transform(tup, *, xy)
end

"""
    scale(tup::Tuple{Real,Real,Real,Real}, x::Real)
"""
function scale(tup::Tuple{Real,Real,Real,Real}, x::Real)
    scale(tup, (x, x))
end

"""
    translate!(element::Union{Line, Triangle, Quad, Polyline, Polygon}, xy::Tuple{Real,Real})
"""
function translate!(element::Union{Line, Triangle, Quad, Polyline, Polygon}, xy::Tuple{Real,Real})
    points = element.points
    element.points = (tup -> translate(tup, xy)).(points)
    (points = element.points, )
end

"""
    scale!(element::Union{Line, Triangle, Quad, Polyline, Polygon}, xy::Tuple{Real,Real})
"""
function scale!(element::Union{Line, Triangle, Quad, Polyline, Polygon}, xy::Tuple{Real,Real})
    points = element.points
    element.points = (tup -> scale(tup, xy)).(points)
    (points = element.points, )
end

"""
    translate!(element::Union{Circle, Arc, Pie}, xy::Tuple{Real,Real})
"""
function translate!(element::Union{Circle, Arc, Pie}, xy::Tuple{Real,Real})
    element.center = translate(element.center, xy)
    (center = element.center, )
end

"""
    translate!(element::Curve, xy::Tuple{Real,Real})
"""
function translate!(element::Curve, xy::Tuple{Real,Real})
    element.startPoint = translate(element.startPoint, xy)
    element.control1 = translate(element.control1, xy)
    element.control2 = translate(element.control2, xy)
    element.endPoint = translate(element.endPoint, xy)
    (startPoint = element.startPoint, control1 = element.control1, control2 = element.control2, endPoint = element.endPoint)
end

"""
    scale!(element::Curve, xy::Tuple{Real,Real})
"""
function scale!(element::Curve, xy::Tuple{Real,Real})
    element.startPoint = scale(element.startPoint, xy)
    element.control1 = scale(element.control1, xy)
    element.control2 = scale(element.control2, xy)
    element.endPoint = scale(element.endPoint, xy)
    (startPoint = element.startPoint, control1 = element.control1, control2 = element.control2, endPoint = element.endPoint)
end

"""
    translate!(element::Union{Rect, RectMultiColor, TextBox}, xy::Tuple{Real,Real})
"""
function translate!(element::Union{Rect, RectMultiColor, TextBox}, xy::Tuple{Real,Real})
    element.rect = translate(element.rect, xy)
    (rect = element.rect, )
end

"""
    scale!(element::Union{Rect, RectMultiColor, TextBox}, xy::Tuple{Real,Real})
"""
function scale!(element::Union{Rect, RectMultiColor, TextBox}, xy::Tuple{Real,Real})
    element.rect = scale(element.rect, xy)
    (rect = element.rect, )
end

"""
    translate!(element::ImageBox, xy::Tuple{Real,Real})
"""
function translate!(element::ImageBox, xy::Tuple{Real,Real})
    if element.rect !== nothing
        element.rect = translate(element.rect, xy)
    end
    (rect = element.rect, )
end

"""
    scale!(element::ImageBox, xy::Tuple{Real,Real})
"""
function scale!(element::ImageBox, xy::Tuple{Real,Real})
    if element.rect !== nothing
        element.rect = scale(element.rect, xy)
    end
    (rect = element.rect, )
end

"""
    scale!(element::Union{Line, Rect, RectMultiColor, Triangle, Quad, Polyline, Polygon, Curve, Rect, RectMultiColor, TextBox, ImageBox}, x::Real)
"""
function scale!(element::Union{Line, Rect, RectMultiColor, Triangle, Quad, Polyline, Polygon, Curve, Rect, RectMultiColor, TextBox, ImageBox}, x::Real)
    scale!(element, (x, x))
end

"""
    scale!(element::Union{Circle, Arc, Pie}, x::Real)
"""
function scale!(element::Union{Circle, Arc, Pie}, x::Real)
    element.radius *= x
    (radius = element.radius, )
end

# module Poptart.Drawings
