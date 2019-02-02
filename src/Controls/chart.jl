# module Poptart.Controls

"""
    Chart(chart_items::Vector; chart_type, min::Cfloat, max::Cfloat, [color::Union{Nothing,RGBA}=nothing, highlight::Union{Nothing,RGBA}=nothing], kwargs...)
"""
Chart

@UI Chart quote
    chart_items::Vector
    function Chart(chart_items::Vector; chart_type, min, max, color::Union{Nothing,RGBA}=nothing, highlight::Union{Nothing,RGBA}=nothing, kwargs...)
        props = Dict{Symbol, Any}(:chart_type => chart_type, :min => Cfloat(min), :max => Cfloat(max), :color => color, :highlight => highlight, pairs(kwargs)...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, chart_items)
    end
end

function properties(control::Chart)
    (properties(super(control))..., :chart_type, :min, :max, :color, :highlight, )
end

# module Poptart.Controls
