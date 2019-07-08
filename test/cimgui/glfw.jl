using Jive
@useinside module test_cimgui_glfw

using Test
using CImGui
using .CImGui.GLFWBackend # ImGui_ImplGlfw_InitForOpenGL
using .CImGui.OpenGLBackend # ImGui_ImplOpenGL3_NewFrame ImGui_ImplOpenGL3_Shutdown
using .CImGui.GLFWBackend.GLFW # ImGui_ImplGlfw_NewFrame ImGui_ImplGlfw_Shutdown
using .CImGui.OpenGLBackend.ModernGL # GL_TRUE
using .CImGui.CSyntax: @c
using Colors: RGBA
using Poptart.Desktop: setup_glfw, error_handling, throttle

function ShowDemoWindow(heartbeat, p_open::Ref{Bool})
    window_flags = CImGui.ImGuiWindowFlags(0)
    CImGui.Begin("ImGui Demo", p_open, window_flags) || (CImGui.End(); return)
    CImGui.Text("dear imgui says hello. $(CImGui.IMGUI_VERSION)")
    CImGui.End() # demo
    heartbeat() do
        if get(ENV, "POPTART_AUTO_CLOSE", nothing) !== nothing
            println("closing $(basename(@__FILE__))")
            glwin = GLFW.GetCurrentContext()
            glwin.handle !== C_NULL && GLFW.SetWindowShouldClose(glwin, true)
        end
    end
end

function show_app(heartbeat)
    show_app_metrics = true
    @c CImGui.ShowMetricsWindow(&show_app_metrics)

    demo_open = true
    @c ShowDemoWindow(heartbeat, &demo_open)
end

function runloop(glsl_version, glwin::GLFW.Window, imctx::Ptr, closenotify::Condition; bgcolor=RGBA(0.10, 0.18, 0.24, 1))
    ImGui_ImplGlfw_InitForOpenGL(glwin, true)
    ImGui_ImplOpenGL3_Init(glsl_version)

    heartbeat = throttle(0.1) do block # 1 minute
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
    (glsl_version, glwin, imctx) = setup_glfw(; title="Demo", frame=(width=1280, height=720))
    runloop(glsl_version, glwin, imctx, closenotify)
end

end # module test_cimgui_glfw
