# module Poptart.Desktop.Windows

config = Dict{Symbol, Any}(
    :default_layout_height => 25,
)

# layout
nuklear_no_layout(nk_ctx::Ptr{LibNuklear.nk_context}, item::UIControl) = nothing

function nuklear_layout(nk_ctx::Ptr{LibNuklear.nk_context}, item::UIControl)
    if haskey(item.props, :frame)
        frame = item.frame
        if haskey(frame, :height)
            if haskey(frame, :width)
                nk_layout_row_static(nk_ctx, frame.height, frame.width, 1)
            else
                nk_layout_row_dynamic(nk_ctx, frame.height, 1)
            end
        else
            nk_layout_row_dynamic(nk_ctx, config[:default_layout_height], 1)
        end
    else
        nk_layout_row_dynamic(nk_ctx, config[:default_layout_height], 1)
    end
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::StaticRow; layout=nuklear_no_layout)
    cols = haskey(item.props, :cols) ? item.cols : length(item.widgets)
    nk_layout_row_static(nk_ctx, item.row_height, item.row_width, cols)
    block(nk_ctx, item)
    for widget in item.widgets
        nuklear_item(nk_ctx, widget; layout=nuklear_no_layout) do nk_ctx, item
        end
    end
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::DynamicRow; layout=nuklear_no_layout)
    cols = haskey(item.props, :cols) ? item.cols : length(item.widgets)
    nk_layout_row_dynamic(nk_ctx, item.row_height, cols)
    block(nk_ctx, item)
    for widget in item.widgets
        nuklear_item(nk_ctx, widget; layout=nuklear_no_layout) do nk_ctx, item
        end
    end
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::Spacing; layout=nuklear_no_layout)
    cols = haskey(item.props, :cols) ? item.cols : length(item.widgets)
    nk_spacing(nk_ctx, cols)
    block(nk_ctx, item)
    for widget in item.widgets
        nuklear_item(nk_ctx, widget; layout=nuklear_no_layout) do nk_ctx, item
        end
    end
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::Group; layout=nuklear_no_layout)
    cols = haskey(item.props, :cols) ? item.cols : length(item.widgets)
    nk_layout_row_static(nk_ctx, item.row_height, item.row_width, cols)
    block(nk_ctx, item)
    if isempty(item.title)
        group_began = nk_group_begin(nk_ctx, item.name, item.flags)
    else
        group_began = nk_group_begin_titled(nk_ctx, item.name, item.title, item.flags)
    end
    if Bool(group_began)
        for widget in item.widgets
            nuklear_item(nk_ctx, widget) do nk_ctx, item
            end
        end
        nk_group_end(nk_ctx)
    end
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::Button; layout=nuklear_layout)
    layout(nk_ctx, item)
    block(nk_ctx, item)
    Bool(nk_button_label(nk_ctx, item.title)) && @async Mouse.leftClick(item)
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::Label; layout=nuklear_layout)
    layout(nk_ctx, item)
    block(nk_ctx, item)
    if item.color === nothing
        nk_label(nk_ctx, item.text, item.alignment)
    else
        color = nuklear_color(item.color)
        nk_label_colored(nk_ctx, item.text, item.alignment, color)
    end
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::SelectableLabel; layout=nuklear_layout)
    layout(nk_ctx, item)
    Bool(nk_selectable_label(nk_ctx, item.text, NK_TEXT_LEFT, item.selected)) && @async Mouse.leftClick(item)
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::Slider; layout=nuklear_layout)
    layout(nk_ctx, item)
    block(nk_ctx, item)
    if item.range isa UnitRange{Int}
        step = 1
    else
        step = item.range.step
    end
    if item.value isa Ref{Cint}
        f = nk_slider_int
    elseif item.value isa Ref{Cfloat}
        f = nk_slider_float
    end
    min = minimum(item.range)
    max = maximum(item.range)
    Bool(f(nk_ctx, min, item.value, max, step)) && @async Mouse.leftClick(item)
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::Property; layout=nuklear_layout)
    layout(nk_ctx, item)
    block(nk_ctx, item)
    if item.range isa UnitRange{Int}
        step = 1
    else
        step = item.range.step
    end
    if item.value isa Ref{Cint}
        f = nk_property_int
    elseif item.value isa Ref{Cfloat}
        f = nk_property_float
    elseif item.value isa Ref{Cdouble}
        f = nk_property_double
    end
    min = minimum(item.range)
    max = maximum(item.range)
    inc_per_pixel = 1
    old_value = item.value[]
    f(nk_ctx, item.name, min, item.value, max, step, inc_per_pixel)
    old_value != item.value[] && @async Mouse.leftClick(item)
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::CheckBox; layout=nuklear_layout)
    layout(nk_ctx, item)
    block(nk_ctx, item)
    Bool(nk_checkbox_label(nk_ctx, item.text, item.active)) && @async Mouse.leftClick(item)
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::Radio; layout=nuklear_layout)
    layout(nk_ctx, item)
    block(nk_ctx, item)
    for (name, value) in pairs(item.options)
        if Bool(nk_option_label(nk_ctx, String(name), item.value == value))
            if item.value != value
                item.value = value
                @async Mouse.leftClick(item)
            end
        end
    end
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::ComboBox; layout=nuklear_layout)
    layout(nk_ctx, item)
    block(nk_ctx, item)
    selected = String(findfirst(isequal(item.value), item.options))
    (width, height) = (nk_widget_width(nk_ctx), config[:default_layout_height] * (length(item.options) + 1))
    if haskey(item.props, :frame)
        if haskey(item.frame, :width)
            width = item.frame.width
        end
        if haskey(item.frame, :height)
            height = item.frame.height
        end
    end
    if Bool(nk_combo_begin_label(nk_ctx, selected, nk_vec2(width, height)))
        nk_layout_row_dynamic(nk_ctx, config[:default_layout_height], 1);
        for (name, value) in pairs(item.options)
            if Bool(nk_combo_item_label(nk_ctx, String(name), NK_TEXT_LEFT))
                if item.value != value
                    item.value = value
                    @async Mouse.leftClick(item)
                end
            end
        end
        nk_combo_end(nk_ctx)
    end
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::ProgressBar; layout=nuklear_layout)
    layout(nk_ctx, item)
    block(nk_ctx, item)
    Bool(nk_progress(nk_ctx, item.value, item.max, item.modifyable ? NK_MODIFIABLE : NK_FIXED)) && @async Mouse.leftClick(item)
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::MenuItem; layout=nuklear_layout)
    layout(nk_ctx, item)
    block(nk_ctx, item)
    Bool(nk_menu_item_label(nk_ctx, item.label, item.align)) && Base.invokelatest(item.callback)
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::Menu; layout=nuklear_no_layout)
    layout(nk_ctx, item)
    block(nk_ctx, item)
    size = nuklear_vec2(item.size)
    nk_layout_row_push(nk_ctx, item.row_width)
    if Bool(nk_menu_begin_label(nk_ctx, item.text, item.align, size))
        for menu_item in item.items
            nuklear_item(nk_ctx, menu_item) do nk_ctx, menu_item
            end
        end
        nk_menu_end(nk_ctx)
    end
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::MenuBar; layout=nuklear_no_layout)
    layout(nk_ctx, item)
    block(nk_ctx, item)
    if Bool(item.show)
        nk_menubar_begin(nk_ctx)
        cols = length(item.items)
        nk_layout_row_begin(nk_ctx, NK_STATIC, item.row_height, cols)
        for menu in item.items
            nuklear_item(nk_ctx, menu) do nk_ctx, menu
            end
        end
        nk_menubar_end(nk_ctx)
    end
end

struct InputContext
    input::nk_input
end

function mouse_pos(nk_ctx::Ptr{LibNuklear.nk_context})
    ptr = Ptr{InputContext}(nk_ctx)
    ctx = unsafe_load(ptr)
    ctx.input.mouse.pos
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::Canvas; layout=nuklear_no_layout)
    painter = nk_window_get_canvas(nk_ctx)
    total_space = nk_window_get_content_region(nk_ctx)
    nk_layout_row_dynamic(nk_ctx, total_space.h, 1)

    Bool(nk_widget_is_mouse_clicked(nk_ctx, NK_BUTTON_LEFT)) && @async Mouse.leftClick(item, pos=mouse_pos(nk_ctx))
    Bool(nk_widget_is_mouse_clicked(nk_ctx, NK_BUTTON_RIGHT)) && @async Mouse.rightClick(item, pos=mouse_pos(nk_ctx))
    block(nk_ctx, item)

    window_pos = nk_window_get_position(nk_ctx)
    for drawing in item.items
        nuklear_drawing_item(nk_ctx, painter, window_pos, drawing, drawing.element)
    end
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::ToolTip; layout=nuklear_no_layout)
    layout(nk_ctx, item)
    block(nk_ctx, item)
    nk_tooltip(nk_ctx, item.text)
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::Popup; layout=nuklear_no_layout)
    if Bool(item.show)
        layout(nk_ctx, item)
        block(nk_ctx, item)
        rect = nuklear_rect(item.frame)
        if Bool(nk_popup_begin(nk_ctx, item.popup_type, item.title, item.flags, rect))
            for widget in item.widgets
                nuklear_item(nk_ctx, widget) do nk_ctx, item
                end
            end
            nk_popup_end(nk_ctx)
        else
            item.show = false
        end
    end
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::ContextualItem; layout=nuklear_layout)
    layout(nk_ctx, item)
    block(nk_ctx, item)
    Bool(nk_contextual_item_label(nk_ctx, item.label, item.align)) && Base.invokelatest(item.callback)
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::Contextual; layout=nuklear_layout)
    layout(nk_ctx, item)
    block(nk_ctx, item)
    size = nuklear_vec2(item.size)
    bounds = nk_widget_bounds(nk_ctx)
    if haskey(item.props, :trigger_bounds)
        bounds = nuklear_rect(item.trigger_bounds)
    end
    if Bool(nk_contextual_begin(nk_ctx, item.flags, size, bounds))
        for contextual_item in item.items
            nuklear_item(nk_ctx, contextual_item) do nk_ctx, item
            end
        end
        nk_contextual_end(nk_ctx)
    end
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::TreeItem; layout=nuklear_layout)
    layout(nk_ctx, item)
    block(nk_ctx, item)
    if Bool(nk_tree_push(nk_ctx, item.tree_type, item.title, item.state))
        for widget in item.widgets
            nuklear_item(nk_ctx, widget) do nk_ctx, item
            end
        end
        nk_tree_pop(nk_ctx)
    end
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, chart::Chart; layout=nuklear_layout)
    layout(nk_ctx, chart)
    block(nk_ctx, chart)
    if chart.color !== nothing && chart.highlight !== nothing
        color = nuklear_color(chart.color)
        highlight = nuklear_color(chart.highlight)
        chart_begin = nk_chart_begin_colored(nk_ctx, chart.chart_type, color, highlight, length(chart.items), chart.min, chart.max)
    else
        chart_begin = nk_chart_begin(nk_ctx, chart.chart_type, length(chart.items), chart.min, chart.max)
    end
    if Bool(chart_begin)
        nk_chart_push.(nk_ctx, chart.items)
        nk_chart_end(nk_ctx)
    end
end

function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::MixedChart; layout=nuklear_layout)
    if isempty(item.items)
    elseif length(item.items) == 1
        nuklear_item(block, nk_ctx, item, layout=layout)
    else
        layout(nk_ctx, item)
        block(nk_ctx, item)
        chart = first(item.items)
        if chart.color !== nothing && chart.highlight !== nothing
            color = nuklear_color(chart.color)
            highlight = nuklear_color(chart.highlight)
            chart_begin = nk_chart_begin_colored(nk_ctx, chart.chart_type, color, highlight, length(chart.items), chart.min, chart.max)
        else
            chart_begin = nk_chart_begin(nk_ctx, chart.chart_type, length(chart.items), chart.min, chart.max)
        end
        if Bool(chart_begin)
            for chart in item.items[2:end]
                if chart.color !== nothing && chart.highlight !== nothing
                    color = nuklear_color(chart.color)
                    highlight = nuklear_color(chart.highlight)
                    nk_chart_add_slot_colored(nk_ctx, chart.chart_type, color, highlight, length(chart.items), chart.min, chart.max)
                else
                    nk_chart_add_slot(nk_ctx, chart.chart_type, length(chart.items), chart.min, chart.max)
                end
            end

            for idx in 1:length(chart.items)
                for (chart_idx, chart) in enumerate(item.items)
                    nk_chart_push_slot(nk_ctx, chart.items[idx], chart_idx-1)
                end
            end
            nk_chart_end(nk_ctx)
        end
    end
end

using Jive
function nuklear_item(block, nk_ctx::Ptr{LibNuklear.nk_context}, item::Any; layout=nuklear_layout)
    @onlyonce begin
        @info "not implemented" item
    end
end

function remove_nuklear_item(item::Any)
end

# module Poptart.Desktop.Windows
