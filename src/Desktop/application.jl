# module Poptart.Desktop

import ..Interfaces: put!, remove!
using GLFW
using Nuklear
using Nuklear.LibNuklear
using Nuklear.GLFWBackend
using ModernGL # glViewport glClear glClearColor

const MAX_VERTEX_BUFFER = 512 * 1024
const MAX_ELEMENT_BUFFER = 128 * 1024

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
    glViewport(0, 0, frame.width, frame.height)

    # init context
    nk_ctx = nk_glfw3_init(glwin, NK_GLFW3_INSTALL_CALLBACKS, MAX_VERTEX_BUFFER, MAX_ELEMENT_BUFFER)
    nk_glfw3_font_stash_begin()
    nk_glfw3_font_stash_end()

    (glwin, nk_ctx)
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

function runloop(glwin::GLFW.Window, app::A) where {A <: UIApplication}
    while !GLFW.WindowShouldClose(glwin)
        yield()

        GLFW.PollEvents()
        nk_glfw3_new_frame()

        try
            Windows.setup_window.(app.nk_ctx, app.windows)
        catch err
            error_handling(err) && break
            nk_end(app.nk_ctx)
        end

        # draw
        bg = nk_colorf(0.10, 0.18, 0.24, 1.0)
        glClear(GL_COLOR_BUFFER_BIT)
        glClearColor(bg.r, bg.g, bg.b, bg.a)
        nk_glfw3_render(NK_ANTI_ALIASING_ON, MAX_VERTEX_BUFFER, MAX_ELEMENT_BUFFER)
        GLFW.SwapBuffers(glwin)
    end
    nk_glfw3_shutdown()
    GLFW.DestroyWindow(glwin)
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
    Application(; title::String="App", frame::NamedTuple{(:width,:height)}=(width=400, height=300), windows=[Windows.Window(title="", frame=(x=0,y=0,frame...))])
"""
mutable struct Application <: UIApplication
    props::Dict{Symbol,Any}
    windows::Vector{W} where {W <: UIWindow}
    nk_ctx::Union{Nothing,Ptr{LibNuklear.nk_context}}
    task::Union{Nothing,Task}

    function Application(; title::String="App", frame::NamedTuple{(:width,:height)}=(width=400, height=300), windows=[Windows.Window(title="Title", frame=(x=0,y=0,frame...))])
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
        app = new(Dict(:title=>title, :frame=>frame), app_windows, nothing, nothing)
        (glwin, nk_ctx) = setup_glfw(; title=app.title, frame=app.frame)
        app.nk_ctx = nk_ctx
        task = @async runloop(glwin, app)
        app.task = task
        env[glwin.handle] = app
        app
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
    Base.empty!(app::A) where {A <: UIApplication}
"""
function Base.empty!(app::A) where {A <: UIApplication}
    empty!(app.windows)
end

# module Poptart.Desktop
