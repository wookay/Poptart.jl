module test_poptart_drawings_textbox

using Test
using Poptart.Controls # Canvas
using Poptart.Drawings # TextBox
using Poptart.Desktop # Font FontAtlas
using Nuklear # pathof(Nuklear)
using Nuklear.LibNuklear: nk_font_chinese_glyph_ranges
using Colors: RGBA

font_path = normpath(pathof(Nuklear), "..", "..", "demo", "extra_font", "Roboto-Light.ttf")
font = Font(name="Roboto-Light", path=font_path, height=30, glyph_ranges=nk_font_chinese_glyph_ranges())
push!(FontAtlas.fonts, font)

canvas = Canvas()
textColor = RGBA(0.8, 0.7, 0.8, 0.9)
textbox = TextBox(text="Hello", font="Roboto-Light", rect=(1,1,10,10), color=textColor)
put!(canvas, textbox)

@test textbox.text == "Hello"

# FontAtlas.clear()

end # module test_poptart_drawings_textbox
