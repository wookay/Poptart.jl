# module Poptart.Controls

@UI ScatterPlot

function properties(control::ScatterPlot)
    (properties(super(control))..., :label, :x, :y, :scale, )
end


@UI LinePlot

function properties(control::LinePlot)
    (properties(super(control))..., :label, :values, :scale, )
end


@UI Histogram

function properties(control::Histogram)
    (properties(super(control))..., :label, :values, :scale, )
end

# module Poptart.Controls
