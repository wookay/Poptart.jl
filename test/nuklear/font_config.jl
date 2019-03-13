module test_nuklear_font_config

using Test
using Poptart.Desktop.FontAtlas: FontConfig
using Nuklear # pathof(Nuklear)
using Nuklear.LibNuklear

cfg = FontConfig(0)
cfg.oversample_h = 1
cfg.oversample_v = 1
cfg.range = nk_font_korean_glyph_ranges()
@test cfg.oversample_h == 0x01

font_path = normpath(pathof(Nuklear), "..", "..", "demo", "extra_font", "Roboto-Light.ttf")

atlas = nk_create_font_atlas()
GC.@preserve atlas begin
    nk_font_atlas_init_default(atlas)

    font = nk_font_atlas_add_from_file(atlas, font_path, 20, Ref(nk_font_config(cfg)))
    font_handle = nk_get_font_handle(font)

    @test font isa Ptr{nk_font}
    @test font_handle isa Ptr{nk_user_font}
end

end # module test_nuklear_font_config
