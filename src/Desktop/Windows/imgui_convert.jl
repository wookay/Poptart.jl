# module Poptart.Desktop.Windows

function Base.:+(a::ImVec2, b::ImVec2)::ImVec2
    ImVec2(a.x + b.x, a.y + b.y)
end

function Base.:+(a::ImVec2, b::Tuple{Float64, Float64})::ImVec2
    ImVec2(a.x + b[1], a.y + b[2])
end

function Base.:+(a::ImVec2, n::T)::ImVec2 where {T <: Real}
    ImVec2(a.x + n, a.y + n)
end

function Base.:-(a::ImVec2, n::T)::ImVec2 where {T <: Real}
    ImVec2(a.x - n, a.y - n)
end

function ImVec4(a::ImVec2, b::ImVec2)::ImVec4
    ImVec4(a.x, a.y, b.x, b.y)
end

function ImVec2(a::ImVec4, ::typeof(min))::ImVec2
    ImVec2(a.x, a.y)
end

function ImVec2(a::ImVec4, ::typeof(max))::ImVec2
    ImVec2(a.z, a.w)
end

function imgui_offset_vec2(offset::ImVec2, pos::Tuple{<:Real,<:Real})::ImVec2
    ImVec2(offset.x + pos[1], offset.y + pos[2])
end

function imgui_offset_rect(offset::ImVec2, rect::Tuple{<:Real,<:Real,<:Real,<:Real})::Tuple{ImVec2,ImVec2}
    (x, y) = (rect[1], rect[2])
    (ImVec2(offset.x + x,  offset.y + y), ImVec2(offset.x + x + rect[3], offset.y + y + rect[4]))
end

function rect_contains_pos(rect::ImVec4, p::ImVec2)::Bool
    p.x >= ImVec2(rect, min).x && p.y >= ImVec2(rect, min).y && p.x < ImVec2(rect, max).x && p.y < ImVec2(rect, max).y
end

function rect_contains_pos(center::ImVec2, radius::Real, p::ImVec2)::Bool
    rect_contains_pos(ImVec4(ImVec2(center.x - radius, center.y - radius), ImVec2(center.x + radius, center.y + radius)), p)
end

function imgui_color(c::RGBA)::ImU32
    col = (c.r, c.g, c.b, c.alpha)
    CImGui.ColorConvertFloat4ToU32(ImVec4(col...))
end

function imgui_glubytes(img::Array{ColorTypes.RGB{FixedPointNumbers.Normed{UInt8,8}},2})
    transpose(RGBA{Normed{UInt8,8}}.(img))
end

function imgui_glubytes(img::Array{ColorTypes.Gray{FixedPointNumbers.Normed{UInt8,8}},2})
    transpose(RGBA{Normed{UInt8,8}}.(img))
end

# module Poptart.Desktop.Windows
