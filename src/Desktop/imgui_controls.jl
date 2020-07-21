# module Poptart.Desktop

macro cstatic_var(exprs...)
    global_sym = gensym(:cstatic_var)
    expr = exprs[1]
    epilogue = exprs[end]
    l, r = expr.args
    insert!(epilogue.args, 1, quote
        global $global_sym
        $l = $global_sym
    end)
    push!(epilogue.args, :($global_sym = $l))
    quote
        global $global_sym = $(esc(r))
        $(esc(epilogue))
    end
end

# CImGui.InputText
function imgui_control_item(imctx::Ptr, item::InputText)
    null = '\0'
    nullpad_buf = rpad(item.buf, item.buf_size, null)
    value = @cstatic_var buf=nullpad_buf begin
        changed = CImGui.InputText(item.label, buf, item.buf_size)
    end
    if changed
        item.buf, = split(value, null)
    end
end

# CImGui.Text
function imgui_control_item(imctx::Ptr, item::Label)
    CImGui.Text(item.text)
end

# CImGui.SliderInt, CImGui.SliderFloat
function _imgui_slider_item(item::Slider, value, f::Union{typeof(CImGui.SliderInt), typeof(CImGui.SliderFloat)}, refvalue::Ref)
    v_min = minimum(item.range)
    v_max = maximum(item.range)
    if f(item.label, refvalue, v_min, v_max)
        typ = typeof(value)
        item.value = typ(refvalue[])
        @async Mouse.leftClick(item)
    end
end

function _imgui_slider_item(item::Slider, value::Integer)
    f = CImGui.SliderInt
    refvalue = Ref{Cint}(value)
    _imgui_slider_item(item, value, f, refvalue)
end

function _imgui_slider_item(item::Slider, value::AbstractFloat)
    f = CImGui.SliderFloat
    refvalue = Ref{Cfloat}(value)
    _imgui_slider_item(item, value, f, refvalue)
end

function imgui_control_item(imctx::Ptr, item::Slider)
    _imgui_slider_item(item, item.value)
end

function imgui_control_item(imctx::Ptr, item::Button)
    CImGui.Button(item.title) && @async Mouse.leftClick(item)
end

function imgui_control_item(imctx::Ptr, item::Canvas)
    draw_list = CImGui.GetWindowDrawList()
    window_pos = CImGui.GetCursorScreenPos()
    for drawing in item.items # :items
        imgui_drawing_item(draw_list, window_pos, drawing, drawing.element)
    end
end

# module Poptart.Desktop
