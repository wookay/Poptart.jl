# module Poptart.Desktop

import ..Interfaces: put!, remove!
using ..Animations: Animations
using .Shortcuts: Shortcuts, Ctrl, Alt, Shift, Key, Conjunction
using CImGui
using .CImGui.GLFWBackend # ImGui_ImplGlfw_InitForOpenGL
using .CImGui.OpenGLBackend # ImGui_ImplOpenGL3_NewFrame ImGui_ImplOpenGL3_Shutdown
using .CImGui.GLFWBackend.GLFW # ImGui_ImplGlfw_NewFrame ImGui_ImplGlfw_Shutdown
using .CImGui.OpenGLBackend.ModernGL # GL_TRUE
using Colors: RGBA

env = Dict{Ptr{Cvoid}, A where {A <: UIApplication}}()

function setup_glfw(; title::String, frame::NamedTuple{(:width,:height)})
    @static if Sys.isapple()
        # OpenGL 3.2 + GLSL 150
        glsl_version = 150
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 2)
        GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE) # 3.2+ only
        GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, GL_TRUE) # required on Mac
    else
        # OpenGL 3.0 + GLSL 130
        glsl_version = 130
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 0)
        # GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE) # 3.2+ only
        # GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, GL_TRUE) # 3.0+ only
    end

    # setup GLFW error callback
    error_callback(err::GLFW.GLFWError) = @error "GLFW ERROR: code $(err.code) msg: $(err.description)"
    GLFW.SetErrorCallback(error_callback)

    glwin = GLFW.CreateWindow(frame.width, frame.height, title)
    GLFW.MakeContextCurrent(glwin)
    GLFW.SwapInterval(1)  # enable vsync
    glViewport(0, 0, frame.width, frame.height)

    imctx = CImGui.CreateContext()
    (glsl_version, glwin, imctx)
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

function set_keyboard_callbacks(glwin::GLFW.Window)
    keyboard_state = Dict{GLFW.Key, Bool}(
        GLFW.KEY_LEFT_SHIFT    => false,
        GLFW.KEY_RIGHT_SHIFT   => false,
        GLFW.KEY_LEFT_CONTROL  => false,
        GLFW.KEY_RIGHT_CONTROL => false,
        GLFW.KEY_LEFT_ALT      => false,
        GLFW.KEY_RIGHT_ALT     => false,
        GLFW.KEY_LEFT_SUPER    => false,
        GLFW.KEY_RIGHT_SUPER   => false,
    )
    keyboard_modifier_ranges = 340:347 # GLFW.KEY_LEFT_SHIFT:GLFW.KEY_RIGHT_SUPER

    function conjunction_from_keyboard_state(key::Union{Nothing, Key})::Conjunction # keyboard_state
        shift = keyboard_state[GLFW.KEY_LEFT_SHIFT] || keyboard_state[GLFW.KEY_RIGHT_SHIFT]
        ctrl = keyboard_state[GLFW.KEY_LEFT_CONTROL] || keyboard_state[GLFW.KEY_RIGHT_CONTROL]
        alt = keyboard_state[GLFW.KEY_LEFT_ALT] || keyboard_state[GLFW.KEY_RIGHT_ALT]
        super = keyboard_state[GLFW.KEY_LEFT_SUPER] || keyboard_state[GLFW.KEY_RIGHT_SUPER]
        Conjunction(shift, ctrl, alt, super, key)
    end

    block = function (_, key, scancode, action, mods)
        keyval = Int(key)
        if action == GLFW.PRESS
            if keyval in keyboard_modifier_ranges
                keyboard_state[key] = true
                if !isempty(Shortcuts.pressed_modifier_callbacks)
                    conjunction = conjunction_from_keyboard_state(nothing)
                    if haskey(Shortcuts.pressed_modifier_callbacks, conjunction)
                        Shortcuts.pressed_modifier_callbacks[conjunction]((pressed=conjunction,))
                    end
                end
            else
                k = Key(keyval)
                conjunction = conjunction_from_keyboard_state(k)
                if conjunction.shift || conjunction.ctrl || conjunction.alt || conjunction.super
                    if !isempty(Shortcuts.pressed_conjunction_callbacks)
                        if haskey(Shortcuts.pressed_conjunction_callbacks, conjunction)
                            Shortcuts.pressed_conjunction_callbacks[conjunction]((pressed=conjunction,))
                        end
                    end
                elseif !isempty(Shortcuts.pressed_key_callbacks)
                    if haskey(Shortcuts.pressed_key_callbacks, k)
                        Shortcuts.pressed_key_callbacks[k]((pressed=k,))
                    end
                end
            end
        elseif action == GLFW.RELEASE && keyval in keyboard_modifier_ranges
            keyboard_state[key] = false
        end
    end
    GLFW.SetKeyCallback(glwin, block)
end

function runloop(glsl_version, glwin::GLFW.Window, app::A) where {A <: UIApplication}
    ImGui_ImplGlfw_InitForOpenGL(glwin, true)
    ImGui_ImplOpenGL3_Init(glsl_version)

    bgcolor = app.bgcolor
    heartbeat = throttle(60) do block # 1 minute
        block()
    end
    under_revise = isdefined(Main, :Revise)
    set_keyboard_callbacks(glwin)

    Animations.chronicle.isrunning = true
    app.pre_block !== nothing && Base.invokelatest(app.pre_block)
    quantum = 0.016666666f0
    while app.isrunning && !GLFW.WindowShouldClose(glwin)
        yield()

        GLFW.WaitEvents(quantum)
        ImGui_ImplOpenGL3_NewFrame()
        ImGui_ImplGlfw_NewFrame()
        CImGui.NewFrame()

        try
            Animations.chronicle.regulate(time())
            Windows.setup_window.(app.imctx, app.windows, heartbeat, under_revise)
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
    app.post_block !== nothing && Base.invokelatest(app.post_block)
    Animations.chronicle.isrunning = false

    # cleanup
    ImGui_ImplOpenGL3_Shutdown()
    ImGui_ImplGlfw_Shutdown()
    CImGui.DestroyContext(app.imctx)
    GLFW.DestroyWindow(glwin)

    notify(app.closenotify)
end

"""
    Application(; title::String="App",
                  frame::NamedTuple{(:width,:height)} = (width=400, height=300),
                  windows = [Windows.Window(title="Title", frame=(x=0,y=0,frame...))],
                  bgcolor = RGBA(0.10, 0.18, 0.24, 1),
                  pre_block = nothing,
                  post_block = nothing,
                  closenotify = Condition())
"""
mutable struct Application <: UIApplication
    props::Dict{Symbol,Any}
    windows::Vector{W} where {W <: UIWindow}
    imctx::Union{Nothing,Ptr}
    task::Union{Nothing,Task}
    closenotify::Condition
    isrunning::Bool

    function Application(; title::String="App",
                           frame::NamedTuple{(:width,:height)} = (width=400, height=300),
                           windows = [Windows.Window(title="Title", frame=(x=0,y=0,frame...))],
                           bgcolor = RGBA(0.10, 0.18, 0.24, 1),
                           pre_block = nothing,
                           post_block = nothing,
                           closenotify = Condition())
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
        props = Dict(:title => title, :frame => frame, :bgcolor => bgcolor, :pre_block => pre_block, :post_block =>  post_block)
        app = new(props, app_windows, nothing, nothing, closenotify, true)
        do_resume(app)
        app
    end
end

"""
    pause(app::A) where {A <: UIApplication}
"""
function pause(app::A) where {A <: UIApplication}
    if app.isrunning
        glwin = GLFW.GetCurrentContext()
        if glwin.handle !== C_NULL
            app.isrunning = false
            wait(app.closenotify)
        end
    end
end

"""
    resume(app::A) where {A <: UIApplication}
"""
function resume(app::A) where {A <: UIApplication}
    if !app.isrunning
        app.isrunning = true
        do_resume(app)
    end
end

function do_resume(app::A) where {A <: UIApplication}
    (glsl_version, glwin, imctx) = setup_glfw(; title=app.title, frame=app.frame)
    app.imctx = imctx
    if false
        runloop(glsl_version, glwin, app)
    else
        task = @async runloop(glsl_version, glwin, app)
        app.task = task
    end
    env[glwin.handle] = app
    nothing
end

function properties(::A) where {A <: UIApplication}
    (:title, :frame, :bgcolor, :pre_block, :post_block, )
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
