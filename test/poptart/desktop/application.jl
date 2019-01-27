using Jive
@useinside module test_poptart_desktop_application

using Test
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Mouse Button Label Slider CheckBox ProgressBar didClick

window1 = Windows.Window(title="A", frame=(x=10,y=20,width=200,height=200))
window2 = Windows.Window(title="B", frame=(x=215,y=20,width=200,height=250))
window3 = Windows.Window(title="C", frame=(x=420,y=20,width=200,height=250))
windows = [window1, window2, window3]
app = Application(windows=windows, title="App", frame=(width=630, height=400))
@test app isa Application
@test !Windows.iscollapsed(app, window1)

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
    @info :didClick (event, slider1.value[])
end

checkbox1 = Checkbox(text="is active", active=Ref{Cint}(true))
put!(window2, Label(text="Checkbox:"), checkbox1)
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

window4 = Windows.Window(title="D", frame=(x=10,y=230,width=125,height=150))
put!(window4, ImageView(path=normpath(@__DIR__, "..", "..", "assets", "julia-tan.png")))
push!(app.windows, window4)

end # module test_poptart_desktop_application
