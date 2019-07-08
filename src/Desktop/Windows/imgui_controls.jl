# module Poptart.Desktop.Windows


function imgui_item(block, imctx::Ptr, item::Button)
    CImGui.Button(item.title) && @async Mouse.leftClick(item)
end

function imgui_item(block, imctx::Ptr, item::Slider)
    if item.range isa UnitRange{Int}
        step = 1
    else
        step = item.range.step
    end
    if item.value isa Ref{Cint}
        f = CImGui.SliderInt
    elseif item.value isa Ref{Cfloat}
        f = CImGui.SliderFloat
    end
    label = item.label
    min = minimum(item.range)
    max = maximum(item.range)
    f(label, item.value, min, max) && @async Mouse.leftClick(item)
end

function imgui_item(block, imctx::Ptr, item::Label)
    CImGui.LabelText("", item.text)
end

function imgui_item(block, imctx::Ptr, item::Canvas)
    draw_list = CImGui.GetWindowDrawList()
    window_pos = CImGui.GetCursorScreenPos()
    for drawing in item.items
        imgui_drawing_item(imctx, draw_list, window_pos, drawing, drawing.element)
    end
end

using Jive # @onlyonce
function imgui_item(block, imctx::Ptr, item::Any)
    @onlyonce begin
        @info "not implemented" item
    end
end

function remove_imgui_item(item::Any)
end

# module Poptart.Desktop.Windows
