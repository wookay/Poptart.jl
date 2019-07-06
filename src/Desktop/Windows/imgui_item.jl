# module Poptart.Desktop.Windows

using Jive

function imgui_item(block, imctx::Ptr, item::Canvas)
    draw_list = CImGui.GetWindowDrawList()
    window_pos = CImGui.GetCursorScreenPos()
    for drawing in item.items
        imgui_drawing_item(imctx, draw_list, window_pos, drawing, drawing.element)
    end
end

function imgui_item(block, imctx::Ptr, item::Any)
    @onlyonce begin
        @info "not implemented" item
    end
end

function remove_imgui_item(item::Any)
end

# module Poptart.Desktop.Windows
