using Jive
@useinside module test_poptart_desktop_chart

using Test
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Chart MixedChart

window1 = Windows.Window(title="Chart", frame=(x=5,y=20,width=200,height=300))
window2 = Windows.Window(title="Colored", frame=(x=210,y=20,width=200,height=300))
window3 = Windows.Window(title="MixedChart", frame=(x=415,y=20,width=200,height=300))
Application(windows=[window1, window2, window3], title="App", frame=(width=630, height=400))

using Nuklear.LibNuklear: NK_CHART_LINES, NK_CHART_COLUMN
using Colors: RGBA

lines_chart1 = Chart(items=rand(10), chart_type=NK_CHART_LINES, min=0, max=1, frame=(height=100,))
column_chart1 = Chart(items=rand(10), chart_type=NK_CHART_COLUMN, min=0, max=1, frame=(height=100,))
put!(window1, lines_chart1, column_chart1)

normalColor    = RGBA(0.8,0.8,0.8,1)
highlightColor = RGBA(0.1, 0.7,0.8,1)
lines_chart2 = Chart(items=rand(10), chart_type=NK_CHART_LINES, min=0, max=1, frame=(height=100,), color=normalColor, highlight=highlightColor)
column_chart2 = Chart(items=rand(10), chart_type=NK_CHART_COLUMN, min=0, max=1, frame=(height=100,), color=normalColor, highlight=highlightColor)
put!(window2, lines_chart2, column_chart2)

mixed = MixedChart(items=[lines_chart1, lines_chart2], frame=(height=100,))
put!(window3, mixed)

end # module test_poptart_desktop_chart
