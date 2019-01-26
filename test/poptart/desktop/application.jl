using Jive
@useinside module test_poptart_desktop_application

using Test
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Mouse Button Label Slider CheckBox ProgressBar didClick

window1 = Windows.Window(title="A", frame=(x=10,y=20,width=200,height=200))
window2 = Windows.Window(title="B", frame=(x=220,y=20,width=200,height=320))
windows = [window1, window2]
Application(windows=windows, title="App", frame=(width=430, height=350))

button = Button(title="Hello", frame=(width=80, height=30))
put!(window1, button)

slider1 = Slider(range=1:10, value=Ref{Cint}(5))
slider2 = Slider(range=1.0:10.0, value=Ref{Cfloat}(2.0))
put!(window2, Label(text="Slider:"), slider1, slider2)

observered = []

didClick(button) do event
    push!(observered, (didClick, button, event))
    @info :didClick event
end

Mouse.click(button)
@test observered == [(didClick, button, (action=Mouse.click,))]

didClick(slider1) do event
    @info :didClick (event, Int(slider1.value[]))
end

checkbox1 = CheckBox(text="Active", active=Ref{Cint}(true))
put!(window2, Label(text="CheckBox:"), checkbox1)

didClick(checkbox1) do event
    if Bool(checkbox1.active[])
        checkbox1.text = "Active"
    else
        checkbox1.text = "Inactive"
    end
    @info :didClick (event, Bool(checkbox1.active[]))
end

progress1 = ProgressBar(value=Ref{Csize_t}(20), max=100, modifyable=true)
put!(window2, Label(text="ProgressBar:"), progress1)

didClick(progress1) do event
    @info :didClick (event, Int(progress1.value[]))
end

option1 = OptionLabel(options=(easy=0, normal=1, hard=2), value=1)
put!(window2, Label(text="OptionLabel:"), option1)

didClick(option1) do event
    @info :didClick (event, option1.value)
end

end # module test_poptart_desktop_application
