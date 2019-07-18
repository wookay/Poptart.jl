module test_cimgui_dragme

using Test
using CImGui
using .CImGui.GLFWBackend # ImGui_ImplGlfw_InitForOpenGL
using .CImGui.OpenGLBackend # ImGui_ImplOpenGL3_NewFrame ImGui_ImplOpenGL3_Shutdown
using .CImGui.GLFWBackend.GLFW # ImGui_ImplGlfw_NewFrame ImGui_ImplGlfw_Shutdown
using .CImGui.OpenGLBackend.ModernGL # GL_TRUE
using .CImGui.CSyntax: @c
using .CImGui.CSyntax.CStatic: @cstatic
using .CImGui.CSyntax.CFor: @cfor
using .CImGui: ImVec2, ImVec4, IM_COL32, ImU32
using Colors: RGBA
using Poptart.Desktop: setup_glfw, error_handling, throttle

# code from https://github.com/Gnimuc/CImGui.jl/blob/master/examples/demo_misc.jl#L183
function ShowExampleDragMe(heartbeat)
    io = CImGui.GetIO()
    CImGui.Button("Drag Me")
    if CImGui.IsItemActive()
        # draw a line between the button and the mouse cursor
        draw_list = CImGui.GetWindowDrawList()
        CImGui.PushClipRectFullScreen(draw_list)
        click_pos = CImGui.Get_MouseClickedPos(io, 0)
        CImGui.AddLine(draw_list, click_pos, io.MousePos, CImGui.GetColorU32(CImGui.ImGuiCol_Button), 4.0)
        CImGui.PopClipRect(draw_list)

        # drag operations gets "unlocked" when the mouse has moved past a certain threshold (the default threshold is stored in io.MouseDragThreshold)
        # you can request a lower or higher threshold using the second parameter of IsMouseDragging() and GetMouseDragDelta()
        value_raw = CImGui.GetMouseDragDelta(0, 0.0)
        value_with_lock_threshold = CImGui.GetMouseDragDelta(0)
        mouse_delta = io.MouseDelta
        CImGui.SameLine()
        txt = "Raw ($(value_raw.x), $(value_raw.y)), WithLockThresold ($(value_with_lock_threshold.x), $(value_with_lock_threshold.y)), MouseDelta ($(mouse_delta.x), $(mouse_delta.y))"
        CImGui.Text(txt)
    end
    heartbeat() do
        if get(ENV, "POPTART_AUTO_CLOSE", nothing) !== nothing
            println("    closing $(basename(@__FILE__))")
            glwin = GLFW.GetCurrentContext()
            glwin.handle !== C_NULL && GLFW.SetWindowShouldClose(glwin, true)
        end
    end
end

function show_app(heartbeat, frame)
    p_open = Ref(true)
    CImGui.SetNextWindowPos((0, 0), CImGui.ImGuiCond_FirstUseEver)
    CImGui.SetNextWindowSize((frame.width, frame.height), CImGui.ImGuiCond_FirstUseEver)
    CImGui.Begin("App", p_open, CImGui.ImGuiWindowFlags(CImGui.ImGuiWindowFlags_NoMove))
    @c ShowExampleDragMe(heartbeat)
    CImGui.End()
end

function runloop(glsl_version, glwin::GLFW.Window, imctx::Ptr, closenotify::Condition, frame; bgcolor=RGBA(0.10, 0.18, 0.24, 1))
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
            show_app(heartbeat, frame)
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
    frame=(width=800, height=600)
    (glsl_version, glwin, imctx) = setup_glfw(; title="Demo", frame=frame)
    runloop(glsl_version, glwin, imctx, closenotify, frame)
end

end # module test_cimgui_dragme
