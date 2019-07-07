module FontAtlas # module Poptart.Desktop

using CImGui

function add_font(path::String, size_pixels; font_cfg=C_NULL, glyph_ranges::Union{Nothing,Symbol}=nothing)
    io = CImGui.GetIO()
    fontAtlas = io.Fonts
    if glyph_ranges === nothing
        ranges = C_NULL
    else
        f = getfield(CImGui, Symbol(:GetGlyphRanges, glyph_ranges))
        ranges = f(fontAtlas)
    end
    CImGui.AddFontFromFileTTF(fontAtlas, path, size_pixels, font_cfg, ranges)
end

end # module Poptart.Desktop.FontAtlas
