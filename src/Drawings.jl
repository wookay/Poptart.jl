module Drawings # Poptart

import ..Props: properties

export Line, Rect, Circle, Triangle, Arc, Curve, Polyline, Polygon
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

@DrawingElement Line (points, thickness, color)
@DrawingElement Rect (rect, color)
@DrawingElement Circle (rect, color)
@DrawingElement Triangle (points, color)
@DrawingElement Arc (center, radius, angle, color)
@DrawingElement Curve (startPoint, control1, control2, endPoint, thickness, color)
@DrawingElement Polyline (points, thickness, color)
@DrawingElement Polygon (points, thickness, color)

@DrawingElement Image ()
@DrawingElement Text ()

struct Drawing{paint}
    element::E where {E <: DrawingElement}
end

function stroke(element::E) where {E <: DrawingElement}
    Drawing{stroke}(element)
end

function Base.fill(element::E) where {E <: DrawingElement}
    Drawing{fill}(element)
end

function draw(element::E) where {E <: DrawingElement}
    Drawing{draw}(element)
end

end # module Poptart.Drawings
