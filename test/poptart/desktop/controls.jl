module test_poptart_desktop_controls

using Test
using Poptart.Desktop # Application Window put!
using Poptart.Controls # Mouse Button Slider didClick
using Colors: RGBA

window1 = Window(title="A", frame=(x=10,y=20,width=200,height=200))
app = Application(windows=[window1], title="App", frame=(width=630, height=400))
@test app isa Application

button = Button(title="Hello", frame=(width=80, height=30))
put!(window1, button)
observered = []
didClick(button) do event
    push!(observered, (didClick, button, event))
end
Mouse.leftClick(button)
@test observered == [(didClick, button, (action=Mouse.leftClick,))]

label1 = Label(text="Range:")
slider1 = Slider(label="Int", range=1:10, value=5)
slider2 = Slider(label="Float", range=1:10, value=2.0)
put!(window1, label1, slider1, slider2)

end # module test_poptart_desktop_controls
