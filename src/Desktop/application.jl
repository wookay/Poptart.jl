# module Poptart.Desktop

using GLFW
using Nuklear
using Nuklear.LibNuklear
using Nuklear.GLFWBackend
using ModernGL # glViewport glClear glClearColor


const MAX_VERTEX_BUFFER = 512 * 1024
const MAX_ELEMENT_BUFFER = 128 * 1024

env = Dict{Ptr{Cvoid}, A where {A <: UIApplication}}()

function setup_glfw(; title::String, frame)
    @static if Sys.isapple()
        VERSION_MAJOR = 3
        VERSION_MINOR = 3
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, VERSION_MAJOR)
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, VERSION_MINOR)
        GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE)
        GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, GL_TRUE)
    else
        GLFW.DefaultWindowHints()
    end

    win = GLFW.CreateWindow(frame.width, frame.height, title)
    GLFW.MakeContextCurrent(win)
    glViewport(0, 0, frame.width, frame.height)

    # init context
    nk_ctx = nk_glfw3_init(win, NK_GLFW3_INSTALL_CALLBACKS, MAX_VERTEX_BUFFER, MAX_ELEMENT_BUFFER)
    nk_glfw3_font_stash_begin()
    nk_glfw3_font_stash_end()

    (win, nk_ctx)
end

function runloop(win::GLFW.Window, app::A) where {A <: UIApplication}
    while !GLFW.WindowShouldClose(win)
        yield()

        GLFW.PollEvents()
        nk_glfw3_new_frame()

        Windows.setup_window.(app.nk_ctx, app.windows)

        # draw
        bg = nk_colorf(0.10, 0.18, 0.24, 1.0)
        glClear(GL_COLOR_BUFFER_BIT)
        glClearColor(bg.r, bg.g, bg.b, bg.a)
        nk_glfw3_render(NK_ANTI_ALIASING_ON, MAX_VERTEX_BUFFER, MAX_ELEMENT_BUFFER)
        GLFW.SwapBuffers(win)
    end
    nk_glfw3_shutdown()
    GLFW.DestroyWindow(win)
    app.nk_ctx = nothing
    empty!(env)
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

function properties(::A) where {A <: UIApplication}
    (:title, :frame)
end


"""
    Application(; title::String="App", frame::NamedTuple{(:width,:height)}=(width=400, height=300), windows=[Windows.Window(title="", frame=(x=0,y=0,frame...))], async=true)
"""
mutable struct Application <: UIApplication
    props::Dict{Symbol,Any}
    windows::Vector{W} where {W <: UIWindow}
    nk_ctx::Union{Nothing,Ptr{LibNuklear.nk_context}}
    task::Union{Nothing,Task}

    function Application(; title::String="App", frame::NamedTuple{(:width,:height)}=(width=400, height=300), windows=[Windows.Window(title="", frame=(x=0,y=0,frame...))], async=true)
        win = GLFW.GetCurrentContext()
        if win.handle !== C_NULL && haskey(env, win.handle)
            app = env[win.handle]
            if app.title != title
                app.title = title
            end
            if app.frame != frame
                app.frame = frame
            end
            app.windows = windows
            env[win.handle] = app
            return app
        end
        app = new(Dict(:title=>title, :frame=>frame), windows, nothing, nothing)
        (win, nk_ctx) = setup_glfw(; title=app.title, frame=app.frame)
        app.nk_ctx = nk_ctx
        if async
            task = @async runloop(win, app)
        else
            task = nothing; runloop(win, app)
        end
        app.task = task
        env[win.handle] = app
        app
    end
end

function Base.setproperty!(app::Application, prop::Symbol, val)
    if prop in fieldnames(Application)
        setfield!(app, prop, val)
    elseif prop in properties(app)
        app.props[prop] = val
        win = GLFW.GetCurrentContext()
        if prop === :title
            GLFW.SetWindowTitle(win, val)
        elseif prop === :frame
            GLFW.SetWindowSize(win, val.width, val.height)
        end
    else
        throw(KeyError(prop))
    end
end

# module Poptart.Desktop
