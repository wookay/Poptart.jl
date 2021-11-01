using Poptart.Desktop
using CImGui

function Desktop.custom_fonts(::Application)
    io::Ptr{CImGui.ImGuiIO} = CImGui.igGetIO()
    fonts = unsafe_load(io.Fonts)
    glyph_ranges = CImGui.GetGlyphRangesDefault(fonts)
                       #  GetGlyphRangesKorean
                       #  GetGlyphRangesJapanese
                       #  GetGlyphRangesChineseFull
                       #  GetGlyphRangesChineseSimplifiedCommon
                       #  GetGlyphRangesCyrillic
                       #  GetGlyphRangesThai
    font_path = normpath(pathof(CImGui), "../..", "fonts", "Roboto-Medium.ttf")
    CImGui.AddFontFromFileTTF(fonts, font_path, 25, C_NULL, glyph_ranges)
end

app = Application()
push!(first(app.windows).items, InputText(buf="Hello world"))

Desktop.exit_on_esc() = true
!isinteractive() && wait(app.closenotify)
