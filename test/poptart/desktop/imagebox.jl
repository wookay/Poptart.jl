using Jive
@useinside module test_poptart_desktop_imagebox

using Test
using Poptart.Desktop # Application Windows put! remove!
using Poptart.Controls # Canvas
using Poptart.Drawings # ImageBox
using Nuklear # pathof(Nuklear)

window1 = Windows.Window(title="A", frame=(x=20,y=50,width=200,height=200))
window2 = Windows.Window(title="B", frame=(x=250,y=50,width=200,height=200))
app = Application(windows=[window1, window2], title="ImageBox", frame=(width=630, height=400))

canvas = Canvas()
put!(window1, canvas)
put!(window2, canvas)

imagebox1 = ImageBox(path=normpath(pathof(Nuklear), "..", "..", "demo", "julia-tan.png"), rect=(50,50,100,100))
put!(canvas, imagebox1)

end # module test_poptart_desktop_imagebox
