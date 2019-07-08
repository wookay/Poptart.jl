# module Poptart.Controls

struct Super{C}
end

function super(::C) where {C <: UIControl}
    Super{C}
end


function haskey_push_or_set!(block, control::C, sym::Symbol) where {C <: UIControl}
    if haskey(control.observers, sym)
        push!(control.observers[sym], block)
    else
        control.observers[sym] = Any[block]
    end
end

# Set
function willSet(block, control::C, prop::Symbol) where {C <: UIControl}
    haskey_push_or_set!(block, control, :willSet)
end

function didSet(block, control::C, prop::Symbol) where {C <: UIControl}
    haskey_push_or_set!(block, control, :didSet)
end

# Send
function willSend(block, control::C) where {C <: UIControl}
    haskey_push_or_set!(block, control, :willSend)
end

function didSend(block, control::C) where {C <: UIControl}
    haskey_push_or_set!(block, control, :didSend)
end

"""
    didClick(block, control::C) where {C <: UIControl}
"""
function didClick(block, control::C) where {C <: UIControl}
    haskey_push_or_set!(control, :didSend) do event
        (event.action === Mouse.leftClick) && block(event)
    end
end

# @UI
function build_ui(sym::Symbol, constructor::Expr)
    quot = quote
        struct $sym <: UIControl
            props::Dict{Symbol, Any}
            observers::Dict{Symbol, Vector}
        end # struct

        function Base.getproperty(control::$sym, prop::Symbol)
            if prop in fieldnames($sym)
                getfield(control, prop)
            elseif prop in properties(control)
                control.props[prop]
            else
                throw(KeyError(prop))
            end
        end

        function Base.setproperty!(control::$sym, prop::Symbol, val)
            if prop in fieldnames($sym)
                setfield!(control, prop, val)
            elseif prop in properties(control)
                haskey(control.observers, :willSet) && broadcast(f -> f(val), control.observers[:willSet])
                control.props[prop] = val
                haskey(control.observers, :didSet) && broadcast(f -> f(val), control.observers[:didSet])
            else
                throw(KeyError(prop))
            end
        end
    end # quote
    append!(quot.args[2].args[end].args, constructor.args)
    esc(quot)
end

macro UI(sym::Symbol, constructor::Expr)
    build_ui(sym, constructor)
end

macro UI(sym::Symbol)
    build_ui(sym, quote
        function $sym(; kwargs...)
            new(Dict{Symbol, Any}(kwargs...), Dict{Symbol, Vector}())
        end
    end)
end

function properties(::Type{Super{C}}) where {C <: UIControl}
    (:frame, )
end

# module Poptart.Controls
