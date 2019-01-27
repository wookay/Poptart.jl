# module Poptart.Desktop

using GLFW
using Nuklear
using Nuklear.LibNuklear
using Nuklear.GLFWBackend
using ModernGL # glViewport glClear glClearColor


const MAX_VERTEX_BUFFER = 512 * 1024
const MAX_ELEMENT_BUFFER = 128 * 1024

env = Dict()

function setup_glfw(; title, frame)
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

function runloop(win, app)
    while !GLFW.WindowShouldClose(win)
        yield()

        GLFW.PollEvents()
        nk_glfw3_new_frame()

        defaultprops = (frame=(x=0, y=0, app.frame...),
                        flags=NK_WINDOW_BORDER | NK_WINDOW_MOVABLE | NK_WINDOW_SCALABLE | NK_WINDOW_MINIMIZABLE | NK_WINDOW_TITLE)

        for window in app.windows
            Windows.setup_window(app.nk_ctx, window; merge(defaultprops, window.props)...)
        end

        # draw
        bg = nk_colorf(0.10, 0.18, 0.24, 1.0)
        glClear(GL_COLOR_BUFFER_BIT)
        glClearColor(bg.r, bg.g, bg.b, bg.a)
        nk_glfw3_render(NK_ANTI_ALIASING_ON, MAX_VERTEX_BUFFER, MAX_ELEMENT_BUFFER)
        GLFW.SwapBuffers(win)
    end
    nk_glfw3_shutdown()
    GLFW.DestroyWindow(win)
    empty!(env)
end

function Base.setproperty!(app::A, prop::Symbol, val) where {A <: UIApplication}
    if prop in (:props, :windows, :nk_ctx, :task)
        setfield!(app, prop, val)
    elseif prop in properties(app)
        app.props[prop] = val
    end
end

function Base.getproperty(app::A, prop::Symbol) where {A <: UIApplication}
    if prop in (:props, :windows, :nk_ctx, :task)
        getfield(app, prop)
    elseif prop in properties(app)
        app.props[prop]
    end
end

function properties(::A) where {A <: UIApplication}
    (:title, :frame)
end


mutable struct Application <: UIApplication
    props
    windows::Vector{W} where {W <: UIWindow}
    nk_ctx
    task

    function Application(; windows=[Windows.Window()], title="App", frame=(width=400, height=300))
        win = GLFW.GetCurrentContext()
        if win.handle !== C_NULL && haskey(env, win.handle)
            app = env[win.handle]
            if app.title != title
                GLFW.SetWindowTitle(win, title)
                app.title = title
            end
            if app.frame != frame
                GLFW.SetWindowSize(win, frame.width, frame.height)
                app.frame = frame
            end
            app.windows = windows
            env[win.handle] = app
            return app
        end
        app = new(Dict(:title=>title, :frame=>frame), windows, nothing, nothing)
        (win, nk_ctx) = setup_glfw(; title=app.title, frame=app.frame)
        app.nk_ctx = nk_ctx
        task = @async runloop(win, app)
        app.task = task
        env[win.handle] = app
        app
    end
end

# module Poptart.Desktop
