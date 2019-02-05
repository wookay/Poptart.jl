# module Poptart.Controls

"""
    Chart(chart_items::Vector; chart_type, min, max, [color::Union{Nothing,RGBA}=nothing, highlight::Union{Nothing,RGBA}=nothing], [frame])
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

"""
    MixedChart(charts::Vector{Chart}; [frame])
"""
MixedChart

@UI MixedChart quote
    charts::Vector{Chart}
    function MixedChart(charts::Vector{Chart}; kwargs...)
        props = Dict{Symbol, Any}(pairs(kwargs)...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, charts)
    end
end

function properties(control::MixedChart)
    (properties(super(control))..., )
end

# module Poptart.Controls
