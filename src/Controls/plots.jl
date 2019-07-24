# module Poptart.Controls

"""
    ScatterPlot(; x::AbstractVector, y::AbstractVector, label::String, [scale], [frame])
"""
ScatterPlot
@UI ScatterPlot

function properties(control::ScatterPlot)
    (properties(super(control))..., :x, :y, :label, :scale, )
end

"""
    Spy(; A::AbstractMatrix, label::String, [frame])
"""
Spy
@UI Spy

function properties(control::Spy)
    (properties(super(control))..., :A, :label, )
end

"""
    BarPlot(; captions::Vector{String}, values::Vector{Number}, label::String, [frame])
"""
BarPlot
@UI BarPlot

function properties(control::BarPlot)
    (properties(super(control))..., :captions, :values, :label, )
end

"""
    LinePlot(; values::AbstractVector, label::String, [overlay_text], [scale], [frame])
"""
LinePlot
@UI LinePlot

function properties(control::LinePlot)
    (properties(super(control))..., :values, :label, :overlay_text, :scale, )
end

"""
    Histogram(; values::AbstractVector, label::String, [overlay_text], [scale], [frame])
"""
Histogram
@UI Histogram

function properties(control::Histogram)
    (properties(super(control))..., :values, :label, :overlay_text, :scale, )
end

# module Poptart.Controls
