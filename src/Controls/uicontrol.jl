# module Poptart.Controls

abstract type UIControl end

struct Super{C}
end

function super(::C) where {C <: UIControl}
    Super{C}
end


# Set
function willSet(block, control::C, prop::Symbol) where {C <: UIControl}
    control.observers[:willSet] = block
end

function didSet(block, control::C, prop::Symbol) where {C <: UIControl}
    control.observers[:didSet] = block
end

# Send
function willSend(block, control::C) where {C <: UIControl}
    control.observers[:willSend] = block
end

function didSend(block, control::C) where {C <: UIControl}
    control.observers[:didSend] = block
end

macro UI(sym::Symbol)
    quot = quote
        struct $sym <: UIControl
            props::Dict{Symbol, Any}
            observers::Dict{Symbol, Any}

            function $sym(; props...)
                new(Dict{Symbol, Any}(props...), Dict{Symbol, Any}())
            end
        end # struct

        function Base.getproperty(control::$sym, prop::Symbol)
            if prop in (:props, :observers)
                getfield(control, prop)
            elseif prop in properties(control)
                control.props[prop]
            end
        end

        function Base.setproperty!(control::$sym, prop::Symbol, val)
            if prop in (:props, :observers)
                setfield!(control, prop, val)
            elseif prop in properties(control)
                haskey(control.observers, :willSet) && control.observers[:willSet](val)
                control.props[prop] = val
                haskey(control.observers, :didSet) && control.observers[:didSet](val)
            end
        end
    end # quote
    esc(quot)
end

function properties(::Type{Super{C}}) where {C <: UIControl}
    (:frame, )
end

# module Poptart.Controls
