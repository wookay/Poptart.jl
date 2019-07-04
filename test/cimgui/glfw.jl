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

function setup_glfw(; title::String, frame::NamedTuple{(:width,:height)})
    VERSION_MAJOR = 3
    VERSION_MINOR = 3
    GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, VERSION_MAJOR)
    GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, VERSION_MINOR)
    GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE)
    GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, GL_TRUE)

    glwin = GLFW.CreateWindow(frame.width, frame.height, title)
    GLFW.MakeContextCurrent(glwin)
    GLFW.SwapInterval(1)  # enable vsync
    glViewport(0, 0, frame.width, frame.height)

    imctx = CImGui.CreateContext()
    (glwin, imctx)
end


function error_handling(err)::Bool
    stackframes = stacktrace(catch_backtrace())
    io = stderr
    printstyled(io, "ERROR: ", sprint(showerror, err), "\n", color=Base.error_color())
    for stackframe in stackframes
        println(io, "    ", stackframe)
    end
    false
end

function ShowDemoWindow(heartbeat, p_open::Ref{Bool})
    window_flags = CImGui.ImGuiWindowFlags(0)
    CImGui.Begin("ImGui Demo", p_open, window_flags) || (CImGui.End(); return)
    CImGui.Text("dear imgui says hello. $(CImGui.IMGUI_VERSION)")
    CImGui.End() # demo
    heartbeat() do
        print()
    end
end

# code from https://github.com/FluxML/Flux.jl/blob/master/src/utils.jl#L103
function throttle(f, timeout; leading=true, trailing=false)
  cooldown = true
  later = nothing
  result = nothing

  function throttled(args...; kwargs...)
    yield()

    if cooldown
      if leading
        result = f(args...; kwargs...)
      else
        later = () -> f(args...; kwargs...)
      end

      cooldown = false
      @async try
        while (sleep(timeout); later != nothing)
          later()
          later = nothing
        end
      finally
        cooldown = true
      end
    elseif trailing
      later = () -> (result = f(args...; kwargs...))
    end

    return result
  end
end

function show_app(heartbeat)
    show_app_metrics = true
    @c CImGui.ShowMetricsWindow(&show_app_metrics)

    demo_open = true
    @c ShowDemoWindow(heartbeat, &demo_open)
end

function runloop(glwin::GLFW.Window, imctx::Ptr, closenotify::Condition; bgcolor=RGBA(0.10, 0.18, 0.24, 1))
    glsl_version = 150
    ImGui_ImplGlfw_InitForOpenGL(glwin, true)
    ImGui_ImplOpenGL3_Init(glsl_version)

    heartbeat = throttle(60) do block # 1 minute
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

closenotify = Condition()
(glwin, imctx) = setup_glfw(; title="Demo", frame=(width=1280, height=720))
task = @async runloop(glwin, imctx, closenotify)

end # module test_cimgui_glfw
