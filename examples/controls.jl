using Poptart.Desktop # Application Window Button Label Slider didClick

window1 = Window(title="A", frame=(x=10,y=20,width=200,height=200))
window2 = Window(title="B", frame=(x=220,y=20,width=200,height=200))
app = Application(windows=[window1, window2], title="App", frame=(width=430, height=300))

button = Button(title="Hello")
push!(window1.items, button)

label = Label(text="Range:")
slider1 = Slider(label="slider1", range=1:10, value=5)
slider2 = Slider(label="slider2", range=1.0:10.0, value=2.0)
push!(window2.items, label, slider1, slider2)

didClick(button) do event
    @info :didClick event
end

didClick(slider1) do event
    @info :didClick (event, slider1.value)
end

didClick(slider2) do event
    @info :didClick (event, slider2.value)
end

Desktop.exit_on_esc() = true
Base.JLOptions().isinteractive==0 && wait(app.closenotify)
