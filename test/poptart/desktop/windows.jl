module test_poptart_desktop_windows

using Test
using Poptart.Desktop

window1 = Windows.Window(name="Name", title="Title", frame=(x=10,y=10,width=80,height=80))
window2 = Windows.Window(title="B", frame=(x=100,y=10,width=80,height=80))
Application(windows=[window1, window2])

end # module test_poptart_desktop_windows
