module Mouse # Poptart.Controls

using ..Controls: UIControl

function haskey_and_broadcast_event(control::C, event) where {C <: UIControl}
    haskey(control.observers, :willSend) && broadcast(f -> f(event), control.observers[:willSend])
    haskey(control.observers, :didSend) && broadcast(f -> f(event), control.observers[:didSend])
end

function click(control::C; kwargs...) where {C <: UIControl}
    event = (action=click, kwargs...)
    haskey_and_broadcast_event(control, event)
end

function double_click(control::C; kwargs...) where {C <: UIControl}
    event = (action=double_click, kwargs...)
    haskey_and_broadcast_event(control, event)
end

end # module Poptart.Controls.Mouse
