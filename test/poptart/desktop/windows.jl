using Jive
@useinside module test_poptart_desktop_windows

using Test
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Popup
using Nuklear.LibNuklear # NK_POPUP_STATIC NK_WINDOW_CLOSABLE

window1 = Windows.Window(name="Name", title="Title", frame=(x=10,y=10,width=80,height=80))
window2 = Windows.Window(title="B", frame=(x=100,y=10,width=200,height=120))
Application(windows=[window1, window2])

popup1 = Popup([Label(text="Hello"), Label(text="World")]; show=false, title="About", frame=(x=20, y=30, width=300, height=190))
put!(window1, popup1)

menu = [Menu(items=[MenuItem(callback=() -> nothing, label="Hide"),
              MenuItem(callback=() -> (popup1.show = true), label="About")],
             text="MENU", row_width=50, size=(width=120,height=200)),
        Menu(items=[MenuItem(callback=() -> nothing, label="Hide"),
              MenuItem(callback=() -> (popup1.show = true), label="About")],
             text="ADVANCED", row_width=100, size=(width=120,height=200)),
        ]
menubar1 = MenuBar(items=menu; show=true, row_height=25)
put!(window2, menubar1)

contextual1 = Contextual(items=[ContextualItem(callback=() -> (popup1.show = true), label="About")], size=(width=100, height=300))
put!(window2, contextual1)

end # module test_poptart_desktop_windows
