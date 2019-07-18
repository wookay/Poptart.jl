module test_cimgui_animate

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

# code from https://github.com/Gnimuc/CImGui.jl/blob/master/examples/demo_widgets.jl#L544
function ShowExampleAnimate(heartbeat)
    animate, _ = @cstatic animate=true arr=Cfloat[0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2] begin
        @c CImGui.Checkbox("Animate", &animate)
        CImGui.PlotLines("Frame Times", arr, length(arr))
        # create a dummy array of contiguous float values to plot
        # Tip: If your float aren't contiguous but part of a structure, you can pass a pointer to your first float and the sizeof() of your structure in the Stride parameter.
        @cstatic values=fill(Cfloat(0),90) values_offset=Cint(0) refresh_time=Cdouble(0) begin
            (!animate || refresh_time == 0.0) && (refresh_time = CImGui.GetTime();)

            while refresh_time < CImGui.GetTime() # create dummy data at fixed 60 hz rate for the demo
                @cstatic phase=Cfloat(0) begin
                    values[values_offset+1] = cos(phase)
                    values_offset = (values_offset+1) % length(values)
                    phase += 0.10*values_offset
                    refresh_time += 1.0/60.0
                end
            end
            CImGui.PlotLines("Lines", values, length(values), values_offset, "avg 0.0", -1.0, 1.0, (0,80))
            CImGui.PlotHistogram("Histogram", arr, length(arr), 0, C_NULL, 0.0, 1.0, (0,80))
        end
    end # @cstatic
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
    @c ShowExampleAnimate(heartbeat)
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
    (glsl_version, glwin, imctx) = setup_glfw(; title="Demo", frame=(width=1280, height=720))
    runloop(glsl_version, glwin, imctx, closenotify)
end

end # module test_cimgui_animate
