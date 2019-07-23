using Poptart.Desktop # Application Window put!
using Poptart.Controls # LinePlot
using Poptart.Animations
using Colors: RGBA

frame = (width=500, height=500)
window1 = Window(title="CubicBezier", frame=frame)
closenotify = Condition()
app = Application(windows=[window1], title="App", frame=frame, closenotify=closenotify)

for sym in (:Ease, :Linear, :EaseIn, :EaseOut, :EaseInOut)
    timing = getfield(Animations, sym)
    values = timing.(0:0.1:1)
    plot = LinePlot(label=string(sym, "\n", timing), values=values, scale=(min=0, max=1), frame=(width=150, height=80))
    put!(window1, plot)
end

Base.JLOptions().isinteractive==0 && wait(closenotify)
