using Zygote: gradient, forwarddiff
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Chart MixedChart

window1 = Windows.Window(title="gradient", frame=(x=10,y=20,width=300,height=300))
closenotify = Condition()
Application(windows=[window1], title="Zygote", frame=(width=350, height=400), closenotify=closenotify)

using Nuklear.LibNuklear: NK_CHART_LINES, NK_CHART_COLUMN
using Colors: RGBA


x_values = []
y_values = []

f = sin

for n in 0:0.5:2pi
    push!(x_values, f(n))
    (val,) = gradient(n) do x
        forwarddiff(f, x)
    end
    push!(y_values, val)
end

normalColor    = RGBA(0.8, 0.8, 0.8, 0.5)
highlightColor = RGBA(0.7, 0.7, 0.8, 1)
lines_chart1   = Chart(items=x_values, chart_type=NK_CHART_LINES, min=minimum(x_values), max=maximum(x_values), frame=(height=100,), color=normalColor, highlight=highlightColor)

normalColor    = RGBA(0.3, 0.8, 0.3, 1)
highlightColor = RGBA(0.1, 0.7, 0.8, 1)
lines_chart2   = Chart(items=y_values, chart_type=NK_CHART_LINES, min=minimum(y_values), max=maximum(y_values), frame=(height=100,), color=normalColor, highlight=highlightColor)

mixed = MixedChart(items=[lines_chart1, lines_chart2], frame=(height=100,))
put!(window1, mixed)

Base.JLOptions().isinteractive==0 && wait(closenotify)
