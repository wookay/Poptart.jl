using Jive
@useinside module test_poptart_desktop_drawings

using Test
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Mouse Button Label Slider CheckBox ProgressBar didClick
using Poptart.Drawings # Line Rect stroke fill
using Colors: RGBA

window1 = Windows.Window(title="A", frame=(x=10,y=20,width=400,height=300))
windows = [window1]
app = Application(windows=windows, title="App", frame=(width=630, height=400))

canvas = Canvas()
put!(window1, canvas)

line1 = Line(points=[(50, 100), (150, 200)], thickness=10, color=RGBA(0,0.7,0,1))
rect1 = Rect(rect=(200, 70, 100, 100), rounding=5, thickness=10, color=RGBA(0,0.5,1,1))
rect2 = Rect(rect=(200, 200, 100, 100), rounding=5, color=RGBA(0.7,0,0.1,0.9))
put!(canvas, stroke(line1), stroke(rect1), fill(rect2))

end # module test_poptart_desktop_drawings
