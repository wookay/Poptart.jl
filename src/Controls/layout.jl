# module Poptart.Controls

"""
    StaticRow(widgets::Vector{<:UIControl}; height, width, [cols])
"""
StaticRow

@UI StaticRow quote
    # props::Dict{Symbol, Any}
    # observers::Dict{Symbol, Vector}
    widgets::Vector{<:UIControl}
    function StaticRow(widgets::Vector{<:UIControl}; kwargs...)
        props = Dict{Symbol, Any}(kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, widgets)
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
    function DynamicRow(widgets::Vector{<:UIControl}; kwargs...)
        props = Dict{Symbol, Any}(kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, widgets)
    end
end

function properties(control::DynamicRow)
    (properties(super(control))..., :height, :cols, )
end

# module Poptart.Controls
