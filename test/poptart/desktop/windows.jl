using Jive
@useinside module test_poptart_desktop_windows

using Test
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Popup
using Nuklear.LibNuklear # NK_POPUP_STATIC NK_WINDOW_CLOSABLE

window1 = Windows.Window(name="Name", title="Title", frame=(x=10,y=10,width=80,height=80))
window2 = Windows.Window(title="B", frame=(x=100,y=10,width=200,height=80))
Application(windows=[window1, window2])

popup1 = Popup([Label(text="Hello"), Label(text="World")]; show=false, popup_type=NK_POPUP_STATIC, title="About", flags=NK_WINDOW_CLOSABLE, frame=(x=20, y=30, width=300, height=190))
put!(window1, popup1)

menu = [Menu([MenuItem(callback=() -> nothing, label="Hide", align=NK_TEXT_LEFT),
              MenuItem(callback=() -> (popup1.show = true), label="About", align=NK_TEXT_LEFT)],
             text="MENU", align=NK_TEXT_LEFT, row_width=50, frame=(width=120,height=200)),
        Menu([MenuItem(callback=() -> nothing, label="Hide", align=NK_TEXT_LEFT),
              MenuItem(callback=() -> (popup1.show = true), label="About", align=NK_TEXT_LEFT)],
             text="ADVANCED", align=NK_TEXT_LEFT, row_width=100, frame=(width=120,height=200)),
        ]
menubar1 = MenuBar(menu; show=true, row_height=25)
put!(window2, menubar1)

end # module test_poptart_desktop_windows
