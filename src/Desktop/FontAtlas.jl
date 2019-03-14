module FontAtlas # Poptart.Desktop

using Nuklear: LibNuklear
using .LibNuklear: nk_rune, nk_font, nk_user_font, nk_size, nk_font_coord_type, nk_vec2, nk_baked_font
using .LibNuklear: nk_get_font_handle, nk_font_default_glyph_ranges, nk_font_atlas_add_from_file, nk_font_config, nk_style_set_font, nk_set_default_font, nk_font_atlas_add_default
using Nuklear.GLFWBackend: glfw
using Jive # @onlyonce

mutable struct FontConfig
    next::Ptr{nk_font_config}
    ttf_blob::Ptr{Cvoid}
    ttf_size::nk_size
    ttf_data_owned_by_atlas::Cuchar
    merge_mode::Cuchar
    pixel_snap::Cuchar
    oversample_v::Cuchar
    oversample_h::Cuchar
    padding::NTuple{3, Cuchar}
    size::Cfloat
    coord_type::nk_font_coord_type
    spacing::nk_vec2
    range::Ptr{nk_rune}
    font::Ptr{nk_baked_font}
    fallback_glyph::nk_rune
    n::Ptr{nk_font_config}
    p::Ptr{nk_font_config}
    function FontConfig(pixel_height::Real)
        c = nk_font_config(pixel_height)
        new(c.next, c.ttf_blob, c.ttf_size, c.ttf_data_owned_by_atlas, c.merge_mode, c.pixel_snap, c.oversample_v, c.oversample_h, c.padding, c.size, c.coord_type, c.spacing, c.range, c.font, c.fallback_glyph, c.n, c.p)
    end
end

nk_font_config(c::FontConfig) = nk_font_config(c.next, c.ttf_blob, c.ttf_size, c.ttf_data_owned_by_atlas, c.merge_mode, c.pixel_snap, c.oversample_v, c.oversample_h, c.padding, c.size, c.coord_type, c.spacing, c.range, c.font, c.fallback_glyph, c.n, c.p)

struct Font
    name::String
    path::Union{String, Nothing}
    height::Real
    glyph_ranges::Ptr{nk_rune}
    function Font(; name::String="", path=nothing, height=20, glyph_ranges=nk_font_default_glyph_ranges())
        fontname = isempty(name) ? basename(path) : name
        new(fontname, path, height, glyph_ranges)
    end
end

fonts = Set{Font}()
fontstore = Dict{String, Ptr{nk_font}}()

function get_font_handle(font::Font)::Ptr{nk_user_font}
    get_font_handle(font.name)
end

function get_font_handle(fontname::String)::Ptr{nk_user_font}
    if haskey(fontstore, fontname)
        fontptr = FontAtlas.fontstore[fontname]
        nk_get_font_handle(fontptr)
    else
        @onlyonce begin
            buf = IOBuffer()
            context = IOContext(buf, :color => true)
            print(context, "FontAtlas: Font ")
            printstyled(context, fontname, color=:cyan)
            println(context, " not found")
            io = stdout
            print(io, String(take!(buf)))
        end
        C_NULL
    end
end

const DEFAULT_FONT = "POPTART_DEFAULT_FONT"

function setup_font_atlas()
    fontstore[DEFAULT_FONT] = nk_font_atlas_add_default(glfw.atlas, 15, C_NULL)
    for font in fonts
        height = font.height
        cfg = FontConfig(height)
        cfg.oversample_h = 1
        cfg.oversample_v = 1
        cfg.range = font.glyph_ranges
        fontptr = nk_font_atlas_add_from_file(glfw.atlas, font.path, height, Ref(nk_font_config(cfg)))
        fontstore[font.name] = fontptr
    end
end

function setup_default_font(nk_ctx::Ptr{LibNuklear.nk_context})
    nk_style_set_font(nk_ctx, nk_get_font_handle(fontstore[DEFAULT_FONT]))
end

function clear()
    empty!(fonts)
    empty!(fontstore)
end

end # Poptart.Desktop.FontAtlas
