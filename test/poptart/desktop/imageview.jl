using Jive
@useinside module test_poptart_desktop_imageview

using Test
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # ImageView
using Nuklear

window1 = Windows.Window(title="A", frame=(x=10,y=20,width=200,height=200))
Application(windows=[window1], title="App", frame=(width=630, height=400))

put!(window1, ImageView(path=normpath(pathof(Nuklear), "..", "..", "demo", "julia-tan.png")))

end # module test_poptart_desktop_imageview
