module Themes # Poptart.Desktop

using ..Desktop: UIApplication
using Nuklear.LibNuklear # NK_COLOR_WINDOW nk_rgba nk_style_from_table

export DarkTheme
export set_style!

abstract type CustomTheme end

"""
    abstract type DarkTheme <: CustomTheme end
"""
abstract type DarkTheme <: CustomTheme end

"""
    color_table
"""
color_table

function color_table(::Type{DarkTheme})
    # https://github.com/vurtun/nuklear/blob/master/demo/style.c#L97
    table = Array{nk_color,1}(undef, Int(NK_COLOR_COUNT))
    table[1+Int(NK_COLOR_TEXT)] = nk_rgba(210, 210, 210, 255)
    table[1+Int(NK_COLOR_WINDOW)] = nk_rgba(57, 67, 71, 215)
    table[1+Int(NK_COLOR_HEADER)] = nk_rgba(51, 51, 56, 220)
    table[1+Int(NK_COLOR_BORDER)] = nk_rgba(46, 46, 46, 255)
    table[1+Int(NK_COLOR_BUTTON)] = nk_rgba(48, 83, 111, 255)
    table[1+Int(NK_COLOR_BUTTON_HOVER)] = nk_rgba(58, 93, 121, 255)
    table[1+Int(NK_COLOR_BUTTON_ACTIVE)] = nk_rgba(63, 98, 126, 255)
    table[1+Int(NK_COLOR_TOGGLE)] = nk_rgba(50, 58, 61, 255)
    table[1+Int(NK_COLOR_TOGGLE_HOVER)] = nk_rgba(45, 53, 56, 255)
    table[1+Int(NK_COLOR_TOGGLE_CURSOR)] = nk_rgba(48, 83, 111, 255)
    table[1+Int(NK_COLOR_SELECT)] = nk_rgba(57, 67, 61, 255)
    table[1+Int(NK_COLOR_SELECT_ACTIVE)] = nk_rgba(48, 83, 111, 255)
    table[1+Int(NK_COLOR_SLIDER)] = nk_rgba(50, 58, 61, 255)
    table[1+Int(NK_COLOR_SLIDER_CURSOR)] = nk_rgba(48, 83, 111, 245)
    table[1+Int(NK_COLOR_SLIDER_CURSOR_HOVER)] = nk_rgba(53, 88, 116, 255)
    table[1+Int(NK_COLOR_SLIDER_CURSOR_ACTIVE)] = nk_rgba(58, 93, 121, 255)
    table[1+Int(NK_COLOR_PROPERTY)] = nk_rgba(50, 58, 61, 255)
    table[1+Int(NK_COLOR_EDIT)] = nk_rgba(50, 58, 61, 225)
    table[1+Int(NK_COLOR_EDIT_CURSOR)] = nk_rgba(210, 210, 210, 255)
    table[1+Int(NK_COLOR_COMBO)] = nk_rgba(50, 58, 61, 255)
    table[1+Int(NK_COLOR_CHART)] = nk_rgba(50, 58, 61, 255)
    table[1+Int(NK_COLOR_CHART_COLOR)] = nk_rgba(48, 83, 111, 255)
    table[1+Int(NK_COLOR_CHART_COLOR_HIGHLIGHT)] = nk_rgba(255, 0, 0, 255)
    table[1+Int(NK_COLOR_SCROLLBAR)] = nk_rgba(50, 58, 61, 255)
    table[1+Int(NK_COLOR_SCROLLBAR_CURSOR)] = nk_rgba(48, 83, 111, 255)
    table[1+Int(NK_COLOR_SCROLLBAR_CURSOR_HOVER)] = nk_rgba(53, 88, 116, 255)
    table[1+Int(NK_COLOR_SCROLLBAR_CURSOR_ACTIVE)] = nk_rgba(58, 93, 121, 255)
    table[1+Int(NK_COLOR_TAB_HEADER)] = nk_rgba(48, 83, 111, 255)
    table
end

"""
    set_style!(app::A, ::Type{T}) where {T, A <: UIApplication}
"""
function set_style!(app::A, ::Type{T}) where {T, A <: UIApplication}
    table = color_table(isconcretetype(T) ? T() : T)
    nk_style_from_table(app.nk_ctx, table)
end

end # Poptart.Desktop.Themes
