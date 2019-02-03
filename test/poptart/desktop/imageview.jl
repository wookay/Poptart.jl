using Jive
@useinside module test_poptart_desktop_imageview

using Test
using Poptart.Desktop # Application Windows put! remove!
using Poptart.Controls # ImageView
using Nuklear

window1 = Windows.Window(title="A", frame=(x=10,y=20,width=200,height=200))
window2 = Windows.Window(title="B", frame=(x=220,y=20,width=200,height=200))
app = Application(windows=[window1, window2], title="App", frame=(width=630, height=400))

imageview1 = ImageView(path=normpath(pathof(Nuklear), "..", "..", "demo", "julia-tan.png"))
put!(window1, imageview1)

put!(window2, imageview1)
remove!(window2, imageview1)

end # module test_poptart_desktop_imageview
