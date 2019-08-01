# module Poptart.Drawings

# @DrawingElement
function build_drawing_element(sym::Symbol, props::Vector{Union{Symbol, Expr}})
    prop_names = []
    params = Expr(:parameters)
    dict_args = Pair[]
    for expr in props
        if expr isa Expr && expr.head == :(=)
            push!(prop_names, first(expr.args))
            push!(params.args, Expr(:kw, expr.args...))
            push!(dict_args, =>(expr.args...))
        elseif expr isa Symbol
            push!(prop_names, expr)
        end
    end
    push!(params.args, Expr(:(...), :kwargs))

    quot = quote
        struct $sym <: DrawingElement
            props::Dict{Symbol, Any}

            function $sym($params)
                new(Dict{Symbol, Any}($dict_args..., kwargs...))
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
            ($prop_names...,)
        end
    end # quote
    esc(quot)
end

macro DrawingElement(sym::Symbol, props::Expr)
    build_drawing_element(sym, Vector{Union{Symbol, Expr}}(props.args))
end

"""
    Line(; points::Vector{<:Tuple}, [thickness=3], [color::RGBA])
"""
Line
@DrawingElement Line (points, thickness=3, color)

"""
    Rect(; rect, [rounding], [thickness=3], [color::RGBA])
"""
Rect
@DrawingElement Rect (rect, rounding, thickness=3, color)

"""
    RectMultiColor(; rect, color_upper_left::RGBA, color_upper_right::RGBA, color_bottom_left::RGBA, color_bottom_right::RGBA)
"""
RectMultiColor
@DrawingElement RectMultiColor (rect, color_upper_left, color_upper_right, color_bottom_left, color_bottom_right)

"""
    Circle(; center::Tuple, [radius], [num_segments], [thickness=3], [color::RGBA])
"""
Circle
@DrawingElement Circle (center, radius, num_segments, thickness=3, color)

"""
    Quad(; points::Vector{<:Tuple}, [thickness=3], [color::RGBA])
"""
Quad
@DrawingElement Quad (points, thickness=3, color)

"""
    Triangle(; points::Vector{<:Tuple}, [thickness=3], [color::RGBA])
"""
Triangle
@DrawingElement Triangle (points, thickness=3, color)

"""
    Arc(; center, angle, [radius], [num_segments], [thickness=3], [color::RGBA])
"""
Arc
@DrawingElement Arc (center, angle, radius, num_segments, thickness=3, color)

"""
    Pie(; center, angle, [radius], [num_segments], [thickness=3], [color::RGBA])
"""
Pie
@DrawingElement Pie (center, angle, radius, num_segments, thickness=3, color)

"""
    Curve(; startPoint, control1, control2, endPoint, [thickness=3], [color::RGBA])
"""
Curve
@DrawingElement Curve (startPoint, control1, control2, endPoint, thickness=3, color)

"""
    Polyline(; points::Vector{<:Tuple}, [thickness=3], [color::RGBA])
"""
Polyline
@DrawingElement Polyline (points, thickness=3, color)

"""
    Polygon(; points::Vector{<:Tuple}, [thickness=3], [color::RGBA])
"""
Polygon
@DrawingElement Polygon (points, thickness=3, color)

"""
    TextBox(; text::String, rect::Tuple, [font_size], [color::RGBA])
"""
TextBox
@DrawingElement TextBox (text, rect, font_size, color)


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
