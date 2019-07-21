using Jive
@useinside module test_poptart_desktop_animate

using Test
using Poptart.Desktop # Application Window put!
using Poptart.Animations # animate lerp Ease Linear EaseIn EaseOut EaseInOut Second
using Poptart.Controls # Canvas
using Poptart.Drawings # Line stroke
using Colors: RGBA

canvas = Canvas()
window1 = Window(items=[canvas], title="Drawings", frame=(x=10, y=10, width=480, height=380))
app = Application(windows=[window1], title="App", frame=(width=500, height=400))

button1 = Button(title="animate", frame=(width=80, height=30))
put!(window1, button1)

strokeColor = RGBA(0, 0.7, 0, 1)
line1 = Line(points=[(95, 100), (100, 100)], thickness=10, color=strokeColor)
line2 = Line(points=[(95, 150), (100, 150)], thickness=10, color=strokeColor)
line3 = Line(points=[(95, 200), (100, 200)], thickness=10, color=strokeColor)
line4 = Line(points=[(95, 250), (100, 250)], thickness=10, color=strokeColor)
line5 = Line(points=[(95, 300), (100, 300)], thickness=10, color=strokeColor)
put!(canvas, stroke(line1), stroke(line2), stroke(line3), stroke(line4), stroke(line5))

didClick(button1) do event
    timings = [(line1, Ease, 100),
               (line2, Linear, 150),
               (line3, EaseIn, 200),
               (line4, EaseOut, 250),
               (line5, EaseInOut, 300)]
    for (line, timing, y) in timings
        animate(timing=timing, duration=0.5) do Δt
            x = lerp(100, 300, Δt)
            line.points = [(100, y), (x, y)]
        end
    end
end

a1 = animate(timing=Ease, duration=0.5) do Δt
    x = lerp(100, 300, Δt)
    line1.points = [(100, 100), (x, 100)]
end
repeat(a1, 3)

end # module test_poptart_desktop_controls
