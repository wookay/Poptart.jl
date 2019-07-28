# module Poptart.Drawings

function scale(element::DrawingElement, x::Real)
    scale(element, (x, x))
end

function scale(element::DrawingElement, (x, y))
    transform(element, *, (x, y))
end

function translate(element::DrawingElement, x::Real)
    translate(element, (x, x))
end

function translate(element::DrawingElement, (x, y))
    transform(element, +, (x, y))
end

function transform(element::Line, f, (x, y))::Line
    points = (point -> broadcast(f, point, (x, y))).(element.points)
    Line(points=points, thickness=element.thickness, color=element.color)
end

function transform(element::Rect, f, (x, y))::Rect
    from = broadcast(f, element.rect[1:2], (x, y))
    to   = broadcast(f, element.rect[3:4], (x, y))
    Rect(rect=(from..., to...), rounding=element.rounding, thickness=element.thickness, color=element.color)
end

function transform(element::RectMultiColor, f, (x, y))::RectMultiColor
    from = broadcast(f, element.rect[1:2], (x, y))
    to   = broadcast(f, element.rect[3:4], (x, y))
    RectMultiColor(rect=(from..., to...), left=element.left, top=element.top, right=element.right, bottom=element.bottom)
end

function transform(element::Circle, f, (x, y))::Circle
    from = broadcast(f, element.rect[1:2], (x, y))
    to   = broadcast(f, element.rect[3:4], (x, y))
    Circle(rect=(from..., to...), thickness=element.thickness, color=element.color)
end

function transform(element::Triangle, f, (x, y))::Triangle
    points = (point -> broadcast(f, point, (x, y))).(element.points)
    Triangle(points=points, thickness=element.thickness, color=element.color)
end

function transform(element::Arc, f, (x, y))::Arc
    center = broadcast(f, element.center, (x, y))
    Arc(center=center, radius=element.radius, angle=element.angle, thickness=element.thickness, color=element.color)
end

function transform(element::Curve, f, (x, y))::Curve
    startPoint = broadcast(f, element.startPoint, (x, y))
    control1   = broadcast(f, element.control1, (x, y))
    control2   = broadcast(f, element.control2, (x, y))
    endPoint   = broadcast(f, element.endPoint, (x, y))
    Curve(startPoint=startPoint, control1=control1, control2=control2, endPoint=endPoint, thickness=element.thickness, color=element.color)
end

function transform(element::Polyline, f, (x, y))::Polyline
    points = (point -> broadcast(f, point, (x, y))).(element.points)
    Polyline(points=points, thickness=element.thickness, color=element.color)
end

function transform(element::Polygon, f, (x, y))::Polygon
    points = (point -> broadcast(f, point, (x, y))).(element.points)
    Polygon(points=points, thickness=element.thickness, color=element.color)
end

function transform(element::TextBox, f, (x, y))::TextBox
    from = broadcast(f, element.rect[1:2], (x, y))
    to   = broadcast(f, element.rect[3:4], (x, y))
    TextBox(text=element.text, rect=(from..., to...), color=element.color)
end

function scale(tup::Tuple{T,T}, x::Real) where {T <: Real}
    scale(tup, (x, x))
end

function scale(tup::Tuple{T,T}, (x, y)) where {T <: Real}
    transform(tup, *, (x, y))
end

function translate(tup::Tuple{T,T}, x::Real) where {T <: Real}
    translate(tup, (x, x))
end

function translate(tup::Tuple{T,T}, (x, y)) where {T <: Real}
    transform(tup, +, (x, y))
end

function transform(tup::Tuple{T,T}, f, (x, y))::Tuple{T,T} where {T <: Real}
    broadcast(f, tup, (x, y))
end

# module Poptart.Drawings
