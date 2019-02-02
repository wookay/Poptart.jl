using Jive
@useinside module test_poptart_desktop_layout

using Test
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Button Radio StaticRow DynamicRow

window1 = Windows.Window(title="A", frame=(x=10,y=20,width=200,height=200))
window2 = Windows.Window(title="B", frame=(x=215,y=20,width=200,height=350))
window3 = Windows.Window(title="C", frame=(x=420,y=20,width=200,height=250))
Application(windows=[window1, window2, window3], title="App", frame=(width=630, height=400))

button = Button(title="Hello")
put!(window1, button)
put!(window2, StaticRow([button], height=50, width=100))
put!(window3, DynamicRow([button], height=50))

radio1 = Radio(options=(easy=0, normal=1, hard=2, Symbol("very hard")=>3), value=1)
put!(window1, radio1)
put!(window2, StaticRow([radio1], height=25, width=80, cols=2))
put!(window3, DynamicRow([radio1], height=25, cols=2))

end # module test_poptart_desktop_layout
