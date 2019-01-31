# module Poptart.Controls

"""
    ImageView(; path::String)
"""
ImageView

@UI ImageView quote
    function ImageView(; props...)
        new(Dict{Symbol, Any}(props...), Dict{Symbol, Vector}())
    end
end

function properties(control::ImageView)
    (properties(super(control))..., :path, )
end

# module Poptart.Controls
