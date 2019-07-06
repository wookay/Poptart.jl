# module Poptart.Desktop

import ..Interfaces: put!, remove!
using CImGui
using .CImGui.GLFWBackend # ImGui_ImplGlfw_InitForOpenGL
using .CImGui.OpenGLBackend # ImGui_ImplOpenGL3_NewFrame ImGui_ImplOpenGL3_Shutdown
using .CImGui.GLFWBackend.GLFW # ImGui_ImplGlfw_NewFrame ImGui_ImplGlfw_Shutdown
using .CImGui.OpenGLBackend.ModernGL # GL_TRUE
using Colors: RGBA

env = Dict{Ptr{Cvoid}, A where {A <: UIApplication}}()

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

function runloop(glwin::GLFW.Window, app::A, closenotify::Condition) where {A <: UIApplication}
    glsl_version = 150
    ImGui_ImplGlfw_InitForOpenGL(glwin, true)
    ImGui_ImplOpenGL3_Init(glsl_version)

    heartbeat = throttle(60) do block # 1 minute
        block()
    end

    bgcolor = app.bgcolor
    while !GLFW.WindowShouldClose(glwin)
        yield()

        GLFW.PollEvents()
        ImGui_ImplOpenGL3_NewFrame()
        ImGui_ImplGlfw_NewFrame()
        CImGui.NewFrame()

        try
            Windows.setup_window.(app.imctx, app.windows, heartbeat)
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
    CImGui.DestroyContext(app.imctx)
    GLFW.DestroyWindow(glwin)

    notify(closenotify)
end

"""
    Application(; title::String="App",
                  frame::NamedTuple{(:width,:height)}=(width=400, height=300),
                  windows=[Windows.Window(title="Title", frame=(x=0,y=0,frame...))],
                  bgcolor=RGBA(0.10, 0.18, 0.24, 1),
                  closenotify=Condition())
"""
mutable struct Application <: UIApplication
    props::Dict{Symbol,Any}
    windows::Vector{W} where {W <: UIWindow}
    imctx::Union{Nothing,Ptr}
    task::Union{Nothing,Task}

    function Application(; title::String="App",
                           frame::NamedTuple{(:width,:height)}=(width=400, height=300),
                           windows=[Windows.Window(title="Title", frame=(x=0,y=0,frame...))],
                           bgcolor=RGBA(0.10, 0.18, 0.24, 1),
                           closenotify=Condition())
        app_windows = isempty(windows) ? UIWindow[] : windows
        glwin = GLFW.GetCurrentContext()
        if glwin.handle !== C_NULL && haskey(env, glwin.handle)
            app = env[glwin.handle]
            if app.title != title
                app.title = title
            end
            if app.frame != frame
                app.frame = frame
            end
            app.windows = app_windows
            env[glwin.handle] = app
            return app
        end
        app = new(Dict(:title=>title, :frame=>frame, :bgcolor=>bgcolor), app_windows, nothing, nothing)
        (glwin, imctx) = setup_glfw(; title=app.title, frame=app.frame)
        app.imctx = imctx
        if false
            runloop(glwin, app, closenotify)
        else
            task = @async runloop(glwin, app, closenotify)
            app.task = task
        end
        env[glwin.handle] = app
        app
    end
end

function properties(::A) where {A <: UIApplication}
    (:title, :frame, :bgcolor)
end

function Base.getproperty(app::A, prop::Symbol) where {A <: UIApplication}
    if prop in fieldnames(A)
        getfield(app, prop)
    elseif prop in properties(app)
        app.props[prop]
    else
        throw(KeyError(prop))
    end
end

function Base.setproperty!(app::Application, prop::Symbol, val)
    if prop in fieldnames(Application)
        setfield!(app, prop, val)
    elseif prop in properties(app)
        app.props[prop] = val
        glwin = GLFW.GetCurrentContext()
        if prop === :title
            GLFW.SetWindowTitle(glwin, val)
        elseif prop === :frame
            GLFW.SetWindowSize(glwin, val.width, val.height)
        end
    else
        throw(KeyError(prop))
    end
end

"""
    Desktop.put!(app::A, windows::UIWindow...) where {A <: UIApplication}
"""
function put!(app::A, windows::UIWindow...) where {A <: UIApplication}
    push!(app.windows, windows...)
    nothing
end

"""
    Desktop.remove!(app::A, windows::UIWindow...) where {A <: UIApplication}
"""
function remove!(app::A, windows::UIWindow...) where {A <: UIApplication}
    indices = filter(x -> x !== nothing, indexin(windows, app.windows))
    deleteat!(app.windows, indices)
    nothing
end

"""
    empty!(app::A) where {A <: UIApplication}
"""
function Base.empty!(app::A) where {A <: UIApplication}
    empty!(app.windows)
end

# module Poptart.Desktop
