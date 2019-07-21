
# not working correctly

module test_cimgui_node_graph

using Test
using CImGui
using .CImGui.GLFWBackend # ImGui_ImplGlfw_InitForOpenGL
using .CImGui.OpenGLBackend # ImGui_ImplOpenGL3_NewFrame ImGui_ImplOpenGL3_Shutdown
using .CImGui.GLFWBackend.GLFW # ImGui_ImplGlfw_NewFrame ImGui_ImplGlfw_Shutdown
using .CImGui.OpenGLBackend.ModernGL # GL_TRUE
using .CImGui.CSyntax: @c
using .CImGui.CSyntax.CStatic: @cstatic
using .CImGui.CSyntax.CFor: @cfor
using .CImGui: ImVec2, ImVec4, IM_COL32, ImU32, ImColor
using Colors: RGBA
using Poptart.Desktop: setup_glfw, error_handling, throttle
using Printf: @sprintf

function Base.:(-)(a::ImVec2, b::ImVec2)::ImVec2
    ImVec2(a.x - b.x, a.y - b.y)
end

function ImColor(r::Int, g::Int, b::Int)::ImVec4
    ImVec4(r/255, g/255, b/255, 255/255)
end

mutable struct Node
    ID::Int
    Name::String
    Pos::ImVec2
    Size::ImVec2
    Value::Float64
    Color::ImVec4
    InputsCount::Int
    OutputsCount::Int

    function Node(id::Int, name::String, pos::ImVec2, value::Float64, color::ImVec4, inputs_count::Int, outputs_count::Int)
        size = ImVec2(0, 0)
        new(id, name, pos, size, value, color, inputs_count, outputs_count)
    end
end

function GetInputSlotPos(node::Node, slot_no::Int)::ImVec2 
    ImVec2(node.Pos.x, node.Pos.y + node.Size.y * (slot_no + 1) / (node.InputsCount + 1))
end

function GetOutputSlotPos(node::Node, slot_no::Int)::ImVec2
    ImVec2(node.Pos.x + node.Size.x, node.Pos.y + node.Size.y * (slot_no + 1) / (node.OutputsCount + 1))
end

struct NodeLink
    InputIdx::Int
    InputSlot::Int
    OutputIdx::Int
    OutputSlot::Int
end

fmodf = mod

# code from https://gist.github.com/ocornut/7e9b3ec566a333d725d4
function ShowExampleAppCustomNodeGraph(heartbeat)
    nodes = Vector{Node}()
    links = Vector{NodeLink}()
    inited = false
    scrolling = ImVec2(0.0, 0.0)
    show_grid = true;
    node_selected = -1
    if !inited
        push!(nodes, Node(0, "MainTex", ImVec2(40, 50), 0.5, ImColor(255, 100, 100), 1, 1))
        push!(nodes, Node(1, "BumpMap", ImVec2(40, 150), 0.42, ImColor(200, 100, 200), 1, 1))
        push!(nodes, Node(2, "Combine", ImVec2(270, 80), 1.0, ImColor(0, 200, 100), 2, 2))
        push!(links, NodeLink(0, 0, 2, 0))
        push!(links, NodeLink(1, 0, 2, 1))
        inited = true
    end

    # Draw a list of nodes on the left side
    open_context_menu = false
    node_hovered_in_list = -1
    node_hovered_in_scene = -1
    CImGui.BeginChild("node_list", ImVec2(100, 0))
    CImGui.Text("Nodes")
    CImGui.Separator()
    for node in nodes
        CImGui.PushID(node.ID)
        if CImGui.Selectable(node.Name, node.ID == node_selected)
            node_selected = node.ID
        end
        if CImGui.IsItemHovered()
            node_hovered_in_list = node.ID
            open_context_menu |= CImGui.IsMouseClicked(1)
        end
        CImGui.PopID()
    end 
    CImGui.EndChild()

    CImGui.SameLine()
    CImGui.BeginGroup()

    NODE_SLOT_RADIUS = 4.0
    NODE_WINDOW_PADDING = ImVec2(8.0, 8.0)

    # Create our child canvas
    CImGui.Text(@sprintf("Hold middle mouse button to scroll (%.2f,%.2f)", scrolling.x, scrolling.y))
    CImGui.SameLine(CImGui.GetWindowWidth() - 100)
    CImGui.Checkbox("Show grid", Ref(show_grid))
    CImGui.PushStyleVar(CImGui.ImGuiStyleVar_FramePadding, ImVec2(1, 1))
    CImGui.PushStyleVar(CImGui.ImGuiStyleVar_WindowPadding, ImVec2(0, 0))
    CImGui.PushStyleColor(CImGui.ImGuiCol_ChildBg, IM_COL32(60, 60, 70, 200))
    CImGui.BeginChild("scrolling_region", ImVec2(0, 0), true, CImGui.ImGuiWindowFlags_NoScrollbar | CImGui.ImGuiWindowFlags_NoMove)
    CImGui.PushItemWidth(120.0)

    offset = CImGui.GetCursorScreenPos() + scrolling
    draw_list = CImGui.GetWindowDrawList()
    # Display grid
    if show_grid
        GRID_COLOR = IM_COL32(200, 200, 200, 40)
        GRID_SZ = 64.0
        win_pos = CImGui.GetCursorScreenPos()
        canvas_sz = CImGui.GetWindowSize()
        @cfor x=fmodf(scrolling.x, GRID_SZ)  x<canvas_sz.x  x+=GRID_SZ begin
            CImGui.AddLine(draw_list, ImVec2(x, 0.0) + win_pos, ImVec2(x, canvas_sz.y) + win_pos, GRID_COLOR)
        end
        @cfor y=fmodf(scrolling.y, GRID_SZ)  y<canvas_sz.y  y+=GRID_SZ begin
            CImGui.AddLine(draw_list, ImVec2(0.0, y) + win_pos, ImVec2(canvas_sz.x, y) + win_pos, GRID_COLOR)
        end
    end

    # Display links
    CImGui.ChannelsSplit(draw_list, 2)
    CImGui.ChannelsSetCurrent(draw_list, 0) # Background
    for link in links
        node_inp = nodes[link.InputIdx+1]
        node_out = nodes[link.OutputIdx+1]
        p1 = offset + GetOutputSlotPos(node_inp, link.InputSlot)
        p2 = offset + GetInputSlotPos(node_out, link.OutputSlot)
        CImGui.AddBezierCurve(draw_list, p1, p1 + ImVec2(+50, 0), p2 + ImVec2(-50, 0), p2, IM_COL32(200, 200, 100, 255), 3.0)
    end
    
    # Display nodes
    for node in nodes
        CImGui.PushID(node.ID)
        node_rect_min = offset + node.Pos

        # Display node contents first
        CImGui.ChannelsSetCurrent(draw_list, 1) # Foreground
        old_any_active = CImGui.IsAnyItemActive()
        CImGui.SetCursorScreenPos(node_rect_min + NODE_WINDOW_PADDING)
        CImGui.BeginGroup() # Lock horizontal position
        CImGui.Text(node.Name)
        CImGui.SliderFloat("##value", Ref{Cfloat}(node.Value), 0.0, 1.0, "Alpha %.2f")
        CImGui.ColorEdit3("##color", Ref{Cfloat}(node.Color.x))
        CImGui.EndGroup()

        # Save the size of what we have emitted and whether any of the widgets are being used
        node_widgets_active = !old_any_active && CImGui.IsAnyItemActive()
        node.Size = CImGui.GetItemRectSize() + NODE_WINDOW_PADDING + NODE_WINDOW_PADDING
        node_rect_max = node_rect_min + node.Size

        #/ Display node box
        CImGui.ChannelsSetCurrent(draw_list, 0) # Background
        CImGui.SetCursorScreenPos(node_rect_min)
        CImGui.InvisibleButton("node", node.Size)
        if CImGui.IsItemHovered()
            node_hovered_in_scene = node.ID
            open_context_menu |= CImGui.IsMouseClicked(1)
        end
        node_moving_active = CImGui.IsItemActive()
        if node_widgets_active || node_moving_active
            node_selected = node.ID;
        end
        if node_moving_active && CImGui.IsMouseDragging(0)
            node.Pos = node.Pos + CImGui.GetIO().MouseDelta
        end

        node_bg_color = (node_hovered_in_list == node.ID || node_hovered_in_scene == node.ID || (node_hovered_in_list == -1 && node_selected == node.ID)) ? IM_COL32(75, 75, 75, 255) : IM_COL32(60, 60, 60, 255)
        CImGui.AddRectFilled(draw_list, node_rect_min, node_rect_max, node_bg_color, 4.0)
        CImGui.AddRect(draw_list, node_rect_min, node_rect_max, IM_COL32(100, 100, 100, 255), 4.0)
        @cfor slot_idx=0  slot_idx<node.InputsCount  slot_idx+=1 begin
            CImGui.AddCircleFilled(draw_list, offset + GetInputSlotPos(node, slot_idx), NODE_SLOT_RADIUS, IM_COL32(150, 150, 150, 150))
        end
        @cfor slot_idx=0  slot_idx<node.OutputsCount  slot_idx+=1 begin
            CImGui.AddCircleFilled(draw_list, offset + GetOutputSlotPos(node, slot_idx), NODE_SLOT_RADIUS, IM_COL32(150, 150, 150, 150))
        end

        CImGui.PopID()
    end
    CImGui.ChannelsMerge(draw_list)

    # Open context menu
    if !CImGui.IsAnyItemHovered() && CImGui.IsWindowHovered() && CImGui.IsMouseClicked(1)
        node_selected = node_hovered_in_list = node_hovered_in_scene = -1
        open_context_menu = true
    end
    if open_context_menu
        CImGui.OpenPopup("context_menu")
        if node_hovered_in_list != -1
            node_selected = node_hovered_in_list
        end
        if node_hovered_in_scene != -1
            node_selected = node_hovered_in_scene
        end
    end

    # Draw context menu
    CImGui.PushStyleVar(CImGui.ImGuiStyleVar_WindowPadding, ImVec2(8, 8))
    if CImGui.BeginPopup("context_menu")
        node = node_selected != -1 ? nodes[node_selected+1] : nothing
        scene_pos = CImGui.GetMousePosOnOpeningCurrentPopup() - offset
        if node !== nothing
            CImGui.Text(string("Node '", node.Name, "')"))
            CImGui.Separator()
            if CImGui.MenuItem("Rename..", C_NULL, false, false)
            end
            if CImGui.MenuItem("Delete", C_NULL, false, false)
            end
            if CImGui.MenuItem("Copy", C_NULL, false, false)
            end
        else
            if CImGui.MenuItem("Add")
               push!(nodes, Node(length(nodes), "New node", scene_pos, 0.5, ImColor(100, 100, 200), 2, 2))
            end
            if CImGui.MenuItem("Paste", C_NULL, false, false)
            end
        end
        CImGui.EndPopup()
    end
    CImGui.PopStyleVar()

    # Scrolling
    if CImGui.IsWindowHovered() && !CImGui.IsAnyItemActive() && CImGui.IsMouseDragging(2, 0.0)
        scrolling = scrolling + CImGui.GetIO().MouseDelta
    end

    CImGui.PopItemWidth()
    CImGui.EndChild()
    CImGui.PopStyleColor()
    CImGui.PopStyleVar(2)
    CImGui.EndGroup()

    heartbeat() do
        if get(ENV, "POPTART_AUTO_CLOSE", nothing) !== nothing
            println("    closing $(basename(@__FILE__))")
            glwin = GLFW.GetCurrentContext()
            glwin.handle !== C_NULL && GLFW.SetWindowShouldClose(glwin, true)
        end
    end
end

function show_app(heartbeat)
    show_app_metrics = true
    @c CImGui.ShowMetricsWindow(&show_app_metrics)
    @c ShowExampleAppCustomNodeGraph(heartbeat)
end

function runloop(glsl_version, glwin::GLFW.Window, imctx::Ptr, closenotify::Condition; bgcolor=RGBA(0.10, 0.18, 0.24, 1))
    ImGui_ImplGlfw_InitForOpenGL(glwin, true)
    ImGui_ImplOpenGL3_Init(glsl_version)

    heartbeat = throttle(0.1) do block
        block()
    end
    while !GLFW.WindowShouldClose(glwin)
        yield()

        GLFW.PollEvents()
        ImGui_ImplOpenGL3_NewFrame()
        ImGui_ImplGlfw_NewFrame()
        CImGui.NewFrame()

        try
            show_app(heartbeat)
        catch err
            error_handling(err) && break
        end

        # rendering
        CImGui.Render()
        glClearColor(bgcolor.r, bgcolor.g, bgcolor.b, bgcolor.alpha)
        glClear(GL_COLOR_BUFFER_BIT)
        ImGui_ImplOpenGL3_RenderDrawData(CImGui.GetDrawData())

        GLFW.SwapBuffers(glwin)
    end

    # cleanup
    ImGui_ImplOpenGL3_Shutdown()
    ImGui_ImplGlfw_Shutdown()
    CImGui.DestroyContext(imctx)
    GLFW.DestroyWindow(glwin)

    notify(closenotify)
end

glwin = GLFW.GetCurrentContext()
if glwin.handle === C_NULL
    closenotify = Condition()
    (glsl_version, glwin, imctx) = setup_glfw(; title="Example: Custom Node Graph", frame=(width=700, height=600))
    runloop(glsl_version, glwin, imctx, closenotify)
end

end # module test_cimgui_node_graph
