module Drawings # Poptart

export Line
export stroke, fill, draw

abstract type DrawingElement end

# @DrawingElement
function build_drawing_element(sym::Symbol, constructor::Expr)
    quot = quote
        struct $sym <: DrawingElement
            props::Dict{Symbol, Any}
            $constructor
        end # struct
    end # quote
    esc(quot)
end

macro DrawingElement(sym::Symbol, constructor::Expr)
    build_drawing_element(sym, constructor)
end

macro DrawingElement(sym::Symbol)
    build_drawing_element(sym, quote
        function $sym(; props...)
            new(Dict{Symbol, Any}(props...))
        end
    end)
end

@DrawingElement Line

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
