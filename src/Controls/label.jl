# module Poptart.Controls

"""
    Label(; text::String, [frame])
"""
Label

@UI Label quote
    function Label(; text::String, kwargs...)
        props = Dict{Symbol, Any}(:text => text, pairs(kwargs)...)
        new(props, Dict{Symbol, Vector}())
    end
end

function properties(control::Label)
    (properties(super(control))..., :text, )
end

# module Poptart.Controls
