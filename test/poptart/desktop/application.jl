using Jive
@useinside module test_poptart_desktop_application

using Test
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Mouse Button Label Slider CheckBox ProgressBar SelectableLabel Radio didClick

window1 = Windows.Window(title="A", frame=(x=10,y=20,width=200,height=200))
window2 = Windows.Window(title="B", frame=(x=215,y=20,width=200,height=350))
window3 = Windows.Window(title="C", frame=(x=420,y=20,width=200,height=250))
app = Application(windows=[window1, window2, window3], title="App", frame=(width=630, height=400))
@test app isa Application
@test !Windows.is_collapsed(app, window1)
Windows.set_bounds(app, window1, (x=10,y=20,width=200,height=200))

button = Button(title="Hello", frame=(width=80, height=30))
put!(window1, button)
observered = []
didClick(button) do event
    push!(observered, (didClick, button, event))
    @info :didClick event
end
Mouse.leftClick(button)
@test observered == [(didClick, button, (action=Mouse.leftClick,))]

slider1 = Slider(range=1:10, value=Ref{Cint}(5))
slider2 = Slider(range=1:10, value=Ref{Cfloat}(2.0))
put!(window2, Label(text="Slider:"), slider1, slider2)
didClick(slider1) do event
    @info :didClick (event, slider1.value[])
end

property1 = Property(name="property1", range=1:10, value=Ref{Cint}(5))
property2 = Property(name="property2", range=1:10, value=Ref{Cdouble}(2.0))
property3 = Property(name="property3", range=1:10, value=Ref{Cfloat}(8.0))
put!(window2, Label(text="Property:"), property1, property2, property3)
didClick(property1) do event
    @info :didClick (event, property1.value[])
end

checkbox1 = CheckBox(text="is active", active=Ref{Cint}(true))
put!(window2, Label(text="CheckBox:"), checkbox1)
didClick(checkbox1) do event
    if Bool(checkbox1.active[])
        checkbox1.text = "is active"
    else
        checkbox1.text = "is not active"
    end
    @info :didClick (event, Bool(checkbox1.active[]))
end

progress1 = ProgressBar(value=Ref{Csize_t}(20), max=100, modifyable=true)
put!(window2, Label(text="ProgressBar:"), progress1)
didClick(progress1) do event
    @info :didClick (event, Int(progress1.value[]))
end

selectable1 = SelectableLabel(text="* selectable", selected=Ref{Cint}(false))
put!(window3, selectable1)
didClick(selectable1) do event
    @info :didClick (event, selectable1.selected[])
end

radio1 = Radio(options=(easy=0, normal=1, hard=2, Symbol("very hard")=>3), value=1)
put!(window3, Label(text="Radio:"), radio1)
didClick(radio1) do event
    @info :didClick (event, radio1.value)
end

combobox1 = ComboBox(options=(easy=0, normal=1, hard=2, Symbol("very hard")=>3), value=1)
put!(window3, Label(text="ComboBox:"), combobox1)
didClick(combobox1) do event
    @info :didClick (event, combobox1.value)
end

end # module test_poptart_desktop_application
