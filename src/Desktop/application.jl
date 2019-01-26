# module Poptart.Desktop

using GLFW
using Nuklear
using Nuklear.LibNuklear
using Nuklear.GLFWBackend
using ModernGL # glViewport glClear glClearColor


mutable struct ApplicationMain <: UIApplication
    props
    windows::Vector{W} where {W <: Windows.UIWindow}
    runloop::Bool
end

const MAX_VERTEX_BUFFER = 512 * 1024
const MAX_ELEMENT_BUFFER = 128 * 1024

env = Dict()

function setup_app(app, title, frame)
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
    env[win.handle] = (app, current_task())
    glViewport(0, 0, frame.width, frame.height)

    # init context
    ctx = nk_glfw3_init(win, NK_GLFW3_INSTALL_CALLBACKS, MAX_VERTEX_BUFFER, MAX_ELEMENT_BUFFER)
    nk_glfw3_font_stash_begin()
    nk_glfw3_font_stash_end()

    while !GLFW.WindowShouldClose(win) && app.runloop
        yield()

        GLFW.PollEvents()
        nk_glfw3_new_frame()

        defaultprops = (frame=(x=0, y=0, frame...),
                        flags=NK_WINDOW_BORDER | NK_WINDOW_MOVABLE | NK_WINDOW_SCALABLE | NK_WINDOW_MINIMIZABLE | NK_WINDOW_TITLE)

        for window in app.windows
            Windows.setup_window(ctx, window; merge(defaultprops, window.props)...)
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

function Base.getproperty(app::A, prop::Symbol) where {A <: UIApplication}
    getfield(app, prop)
end

function Application(; windows=[Windows.Window()], title="App", frame=(width=400, height=300))
    current_context = GLFW.GetCurrentContext()
    if current_context.handle !== C_NULL && haskey(env, current_context.handle)
        (app, task) = env[current_context.handle]
        app.props.title != title && GLFW.SetWindowTitle(current_context, title)
        app.props.frame != frame && GLFW.SetWindowSize(current_context, frame.width, frame.height)
        app.props = (title=title, frame=frame)
        app.windows = windows
        return (app, task)
    end
    app = ApplicationMain((title=title, frame=frame), windows, true)
    task = @async setup_app(app, title, frame)
    (app, task)
end

# module Poptart.Desktop
