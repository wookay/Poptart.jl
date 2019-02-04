using Jive
@useinside module test_poptart_desktop_windows

using Test
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Popup
using Nuklear.LibNuklear # NK_POPUP_STATIC NK_WINDOW_CLOSABLE

window1 = Windows.Window(name="Name", title="Title", frame=(x=10,y=10,width=80,height=80))
window2 = Windows.Window(title="B", frame=(x=100,y=10,width=80,height=80))
Application(windows=[window1, window2])

popup1 = Popup([Label(text="Hello"), Label(text="World")]; show=true, popup_type=NK_POPUP_STATIC, title="About", flags=NK_WINDOW_CLOSABLE, frame=(x=20, y=60, width=300, height=190))
put!(window1, popup1)

end # module test_poptart_desktop_windows
