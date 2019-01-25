using Jive
@useinside module test_poptart_desktop_application

using Test
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Mouse Button Label Slider didClick

window1 = Windows.Window(title="A", frame=(x=10,y=20,width=200,height=200))
window2 = Windows.Window(title="B", frame=(x=220,y=20,width=200,height=200))
windows = [window1, window2]
Application(windows=windows, title="App", frame=(width=430, height=300))

button = Button(title="Hello", frame=(width=80, height=30))
put!(window1, button)

label = Label(text="Range:")
slider1 = Slider(range=1:10, value=Ref{Cint}(5))
slider2 = Slider(range=1.0:10.0, value=Ref{Cfloat}(2.0))
put!(window2, label, slider1, slider2)

observered = []

didClick(button) do event
    push!(observered, (didClick, button, event))
    @info :didClick event
end

didClick(slider1) do event
    push!(observered, (didClick, slider1, event))
    @info :didClick (event, slider1.value)
end

Mouse.click(button)

@test observered == [(didClick, button, (action=Mouse.click,))]

end # module test_poptart_desktop_application
