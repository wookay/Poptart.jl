# module Poptart.Controls

"""
    ImageView(; path::String, [frame])
"""
ImageView

@UI ImageView quote
    function ImageView(; kwargs...)
        props = Dict{Symbol, Any}(kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers)
    end
end

function properties(control::ImageView)
    (properties(super(control))..., :path, )
end

# module Poptart.Controls
