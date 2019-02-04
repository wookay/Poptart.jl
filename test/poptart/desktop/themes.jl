using Jive
@useinside module test_poptart_desktop_themes

using Test
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Button
using Nuklear.LibNuklear # set_style NK_COLOR_WINDOW nk_rgba

window1 = Windows.Window(title="A", frame=(x=10,y=20,width=200,height=200))
app = Application(windows=[window1], title="App", frame=(width=630, height=400))
button = Button(title="Hello", frame=(width=80, height=30))
put!(window1, button)

using Poptart.Desktop.Themes # WhiteTheme DarkTheme color_table set_style!

set_style!(app, DarkTheme)

struct Nyan <: DarkTheme
end

function Themes.color_table(::Nyan)
    table = Themes.color_table(DarkTheme)
    table[1+Int(NK_COLOR_WINDOW)] = nk_rgba(57, 167, 71, 215)
    table
end

set_style!(app, Nyan)

set_style!(app, WhiteTheme)

end # module test_poptart_desktop_themes
