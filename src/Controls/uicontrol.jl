# module Poptart.Controls

abstract type UIControl end

function willSet(block, control::C, prop::Symbol) where {C <: UIControl}
end

function didSet(block, control::C, prop::Symbol) where {C <: UIControl}
end

function willSend(block, control::C) where {C <: UIControl}
end

function didSend(block, control::C) where {C <: UIControl}
end

function Base.setproperty!(control::C, prop::Symbol, val) where {C <: UIControl}
    if prop in (:frame,)
    else
        setproperty!(control, prop, val)
    end
end

# module Poptart.Controls
