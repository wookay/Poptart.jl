using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Button Label Slider didClick

window1 = Windows.Window(title="A", frame=(x=10,y=20,width=200,height=200))
window2 = Windows.Window(title="B", frame=(x=220,y=20,width=200,height=200))
Application(windows=[window1, window2], title="App", frame=(width=430, height=300))

button = Button(title="Hello", frame=(width=80, height=30))
put!(window1, button)

label = Label(text="Range:")
slider1 = Slider(label="slider1", range=1:10, value=5)
slider2 = Slider(label="slider2", range=1.0:10.0, value=2.0)
put!(window2, label, slider1, slider2)

didClick(button) do event
    @info :didClick event
end

didClick(slider1) do event
    @info :didClick (event, slider1.value)
end

didClick(slider2) do event
    @info :didClick (event, slider2.value)
end
