# module Poptart.Drawings

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
    Line(; points::Vector{<:Tuple}, thickness, color::RGBA)
"""
Line
@DrawingElement Line (points, thickness, color)

"""
    Rect(; rect, rounding, [thickness], color::RGBA)
"""
Rect
@DrawingElement Rect (rect, rounding, thickness, color)

"""
    RectMultiColor(; rect, color_upper_left::RGBA, color_upper_right::RGBA, color_bottom_left::RGBA, color_bottom_right::RGBA)
"""
RectMultiColor
@DrawingElement RectMultiColor (rect, color_upper_left, color_upper_right, color_bottom_left, color_bottom_right)

"""
    Circle(; center, radius, color::RGBA, [num_segments], [thickness])
"""
Circle
@DrawingElement Circle (center, radius, color, num_segments, thickness)

"""
    Triangle(; points::Vector{<:Tuple}, [thickness], color::RGBA)
"""
Triangle
@DrawingElement Triangle (points, thickness, color)

"""
    Arc(; center, radius, angle, [num_segments], [thickness], color::RGBA)
"""
Arc
@DrawingElement Arc (center, radius, angle, num_segments, thickness, color)

"""
    Pie(; center, radius, angle, [num_segments], [thickness], color::RGBA)
"""
Pie
@DrawingElement Pie (center, radius, angle, num_segments, thickness, color)

"""
    Curve(; startPoint, control1, control2, endPoint, thickness, color::RGBA)
"""
Curve
@DrawingElement Curve (startPoint, control1, control2, endPoint, thickness, color)

"""
    Polyline(; points::Vector{<:Tuple}, thickness, color::RGBA)
"""
Polyline
@DrawingElement Polyline (points, thickness, color)

"""
    Polygon(; points::Vector{<:Tuple}, [thickness], color::RGBA)
"""
Polygon
@DrawingElement Polygon (points, thickness, color)

"""
    TextBox(; text::String, rect, color::RGBA)
"""
TextBox
@DrawingElement TextBox (text, rect, color)


struct Drawing{paint}
    element::E where {E <: DrawingElement}
end

function stroke_and_fill(element::E) where {E <: DrawingElement}
    Drawing{stroke_and_fill}(element)
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

function stroke(drawing::Drawing{stroke})
    drawing
end

function stroke(drawing::Drawing{fill})
    Drawing{stroke_and_fill}(drawing.element)
end

function stroke(drawing::Drawing{stroke_and_fill})
    drawing
end

function Base.fill(drawing::Drawing{stroke})
    Drawing{stroke_and_fill}(drawing.element)
end

function Base.fill(drawing::Drawing{fill})
    drawing
end

function Base.fill(drawing::Drawing{stroke_and_fill})
    drawing
end

function draw(element::E) where {E <: DrawingElement}
    Drawing{draw}(element)
end

function Base.convert(::Type{Drawing}, element::Union{TextBox})
    Drawing{draw}(element)
end

# module Poptart.Drawings
