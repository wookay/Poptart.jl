using Jive
@useinside module test_poptart_desktop_drawings

using Test
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Mouse Button Label Slider CheckBox ProgressBar didClick
using Poptart.Drawings
using Colors: RGBA

window1 = Windows.Window(title="A", frame=(x=10,y=20,width=200,height=200))
windows = [window1]
app = Application(windows=windows, title="App", frame=(width=630, height=400))

canvas = Canvas()
put!(window1, canvas)

line = Line(points=[(50, 60), (100, 150)], thickness=10, color=RGBA(0,1,0,1))
put!(canvas, stroke(line))

end # module test_poptart_desktop_drawings
