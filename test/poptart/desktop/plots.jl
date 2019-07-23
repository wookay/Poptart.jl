module test_poptart_desktop_plots

using Test
using Poptart.Desktop # Application Window put!
using Poptart.Controls # ScatterPlot LinePlot Histogram
using Colors: RGBA
using CImGui: ShowMetricsWindow

window1 = Window(title="A", frame=(width=200,height=200))
app = Application(windows=[window1], title="App", frame=(width=630, height=400))

using Random
Random.seed!()

x = rand(10)
y = rand(length(x))
plot1 = ScatterPlot(label="ScatterPlot", x=x, y=y, frame=(width=150, height=100))
put!(window1, plot1)

A = [1 0 3 4 5;
     0 1 0 6 0;
     5 0 0 1 2;]
plot2 = Spy(label="Spy", A=A, frame=(width=150, height=100))
put!(window1, plot2)

values = rand(10)
plot3 = LinePlot(label="LinePlot", values=values, scale=(min=0, max=1), frame=(width=150, height=80))
put!(window1, plot3)

plot4 = Histogram(values=values, scale=(min=0, max=1.1), frame=(width=150, height=100), overlay_text="Histogram")
put!(window1, plot4)

window1.post_callback = ShowMetricsWindow

end # module test_poptart_desktop_plots
