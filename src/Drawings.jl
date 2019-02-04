module Drawings # Poptart

import ..Interfaces: properties

export Line, Rect, RectMultiColor, Circle, Triangle, Arc, Curve, Polyline, Polygon
export stroke, fill, draw

abstract type DrawingElement end

# @DrawingElement
function build_drawing_element(sym::Symbol, props::Vector{Symbol})
    quot = quote
        struct $sym <: DrawingElement
            props::Dict{Symbol, Any}

            function $sym(; props...)
                new(Dict{Symbol, Any}(props...))
            end
        end # struct

        function Base.getproperty(drawing::$sym, prop::Symbol)
            if prop in fieldnames($sym)
                getfield(drawing, prop)
            elseif prop in properties(drawing)
                drawing.props[prop]
            else
                throw(KeyError(prop))
            end
        end

        function Base.setproperty!(drawing::$sym, prop::Symbol, val)
            if prop in fieldnames($sym)
                setfield!(drawing, prop, val)
            elseif prop in properties(drawing)
                drawing.props[prop] = val
            else
                throw(KeyError(prop))
            end
        end

        function properties(::$sym)
            ($props...,)
        end
    end # quote
    esc(quot)
end

macro DrawingElement(sym::Symbol, props::Expr)
    build_drawing_element(sym, Vector{Symbol}(props.args))
end

"""
    Line(; points::Vector{<:Tuple}, thickness, color)
"""
Line

@DrawingElement Line (points, thickness, color)

"""
    Rect(; rect, rounding, [thickness], color)
"""
Rect

@DrawingElement Rect (rect, rounding, thickness, color)

"""
    RectMultiColor(; rect, left, top, right, bottom)
"""
RectMultiColor

@DrawingElement RectMultiColor (rect, left, top, right, bottom)

"""
    Circle(; rect, [thickness], color)
"""
Circle

@DrawingElement Circle (rect, thickness, color)

"""
    Triangle(; points::Vector{<:Tuple}, [thickness], color)
"""
Triangle

@DrawingElement Triangle (points, thickness, color)

"""
    Arc(; center, radius, angle, [thickness], color)
"""
Arc

@DrawingElement Arc (center, radius, angle, thickness, color)

"""
    Curve(; startPoint, control1, control2, endPoint, thickness, color)
"""
Curve

@DrawingElement Curve (startPoint, control1, control2, endPoint, thickness, color)

"""
    Polyline(; points::Vector{<:Tuple}, thickness, color)
"""
Polyline

@DrawingElement Polyline (points, thickness, color)

"""
    Polygon(; points::Vector{<:Tuple}, [thickness], color)
"""
Polygon

@DrawingElement Polygon (points, thickness, color)

@DrawingElement Image ()
@DrawingElement Text ()

struct Drawing{paint}
    element::E where {E <: DrawingElement}
end

"""
    Drawings.stroke(element::E) where {E <: DrawingElement}
"""
function stroke(element::E) where {E <: DrawingElement}
    Drawing{stroke}(element)
end

"""
    Drawings.fill(element::E) where {E <: DrawingElement}
"""
function Base.fill(element::E) where {E <: DrawingElement}
    Drawing{fill}(element)
end

function draw(element::E) where {E <: DrawingElement}
    Drawing{draw}(element)
end

end # module Poptart.Drawings
