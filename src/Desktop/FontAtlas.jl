module FontAtlas # module Poptart.Desktop

using CImGui

function add_font(path::String, size_pixels; font_cfg=C_NULL, glyph_ranges::Union{Nothing,Symbol}=nothing)
    fontAtlas = CImGui.GetIO().Fonts
    if glyph_ranges === nothing
        ranges = C_NULL
    else
        f = getfield(CImGui, Symbol(:GetGlyphRanges, glyph_ranges))
        ranges = f(fontAtlas)
    end
    CImGui.AddFontFromFileTTF(fontAtlas, path, size_pixels, font_cfg, ranges)
end

function add_font_bundle(font=(name="DroidSans.ttf", size=20))
    fonts_dir = normpath(dirname(pathof(CImGui)), "..", "fonts")
    fontAtlas = CImGui.GetIO().Fonts
    # CImGui.AddFontDefault(fontAtlas) # "ProggyTiny.ttf"  13
    CImGui.AddFontFromFileTTF(fontAtlas, joinpath(fonts_dir, font.name), font.size)
end

end # module Poptart.Desktop.FontAtlas
