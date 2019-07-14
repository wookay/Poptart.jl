# module Poptart.Controls

"""
    Label(; text::String, [frame])
"""
Label

@UI Label quote
    function Label(; label::String="", text::String, kwargs...)
        props = Dict{Symbol, Any}(:label => label, :text => text, pairs(kwargs)...)
        new(props, Dict{Symbol, Vector}())
    end
end

function properties(control::Label)
    (properties(super(control))..., :label, :text, )
end

# module Poptart.Controls
