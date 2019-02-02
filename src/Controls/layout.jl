# module Poptart.Controls

"""
    StaticRow(widgets::Vector{<:UIControl}; height, width, [cols])
"""
StaticRow

@UI StaticRow quote
    widgets::Vector{<:UIControl}
    function StaticRow(widgets::Vector{<:UIControl}; props...)
        new(Dict{Symbol, Any}(props...), Dict{Symbol, Vector}(), widgets)
    end
end

function properties(control::StaticRow)
    (properties(super(control))..., :height, :width, :cols, )
end

"""
    DynamicRow(widgets::Vector{<:UIControl}; height, [cols])
"""
DynamicRow

@UI DynamicRow quote
    widgets::Vector{<:UIControl}
    function DynamicRow(widgets::Vector{<:UIControl}; props...)
        new(Dict{Symbol, Any}(props...), Dict{Symbol, Vector}(), widgets)
    end
end

function properties(control::DynamicRow)
    (properties(super(control))..., :height, :cols, )
end

# module Poptart.Controls
