# module Poptart.Controls

"""
    Slider(; label::String, range, value, [frame])
"""
Slider

@UI Slider

function properties(control::Slider)
    (properties(super(control))..., :block, :label, :range, :value, )
end

function Slider(f::Function; kwargs...)
    Slider(; block=f, kwargs...)
end

# module Poptart.Controls
