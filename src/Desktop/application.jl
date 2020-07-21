# module Poptart.Desktop

"""
    Application(; windows = UIWindow[Window(title="Title", frame=(x=0,y=0,frame...))],
                  closenotify = Condition(),
                  title::String="App",
                  frame::NamedTuple{(:width,:height)} = (width=400, height=300),
                  bgcolor = RGBA(0.10, 0.18, 0.24, 1))
"""
mutable struct Application <: UIApplication
    windows::Vector{UIWindow}
    closenotify::Condition
    props::Dict{Symbol,Any}
    imctx::Union{Nothing,Ptr}
    task::Union{Nothing,Task}
    dirty::Bool

    function Application(; title::String="App",
                           frame::NamedTuple{(:width,:height)} = (width=400, height=300),
                           windows = UIWindow[Window(title="Title", frame=(x=0,y=0,frame...))],
                           bgcolor = RGBA(0.10, 0.18, 0.24, 1),
                           closenotify::Condition = Condition())
        glwin = GLFW.GetCurrentContext()
        glwin.handle !== C_NULL && haskey(env, glwin.handle) && return env[glwin.handle]
        props = Dict(:title => title, :frame => frame, :bgcolor => bgcolor)
        app = new(windows, closenotify, props, nothing, nothing, true)
        create_app(app)
    end
end

function properties(::A) where {A <: UIApplication}
    (:title, :frame, :bgcolor, )
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

function Base.setproperty!(app::A, prop::Symbol, val) where {A <: UIApplication}
    if prop in fieldnames(Application)
        setfield!(app, prop, val)
    elseif prop in properties(app)
        app.props[prop] = val
        glwin = GLFW.GetCurrentContext()
        if glwin.handle !== C_NULL
            if prop === :title
                GLFW.SetWindowTitle(glwin, val)
            elseif prop === :frame
                GLFW.SetWindowSize(glwin, val.width, val.height)
            elseif prop === :bgcolor
                app.dirty = true
            end
        end
    else
        throw(KeyError(prop))
    end
end

function setup_app(app::UIApplication)
    for window in app.windows
        setup_window(app.imctx, window)
    end
end

"""
    resume(app::UIApplication)
"""
function resume(app::UIApplication)
    glwin = GLFW.GetCurrentContext()
    glwin.handle !== C_NULL && haskey(env, glwin.handle) && return nothing
    create_app(app)
    nothing
end

"""
    pause(::UIApplication)
"""
function pause(::UIApplication)
    glwin = GLFW.GetCurrentContext()
    glwin.handle !== C_NULL && GLFW.SetWindowShouldClose(glwin, true)
end

function create_app(app::UIApplication)
    glwin, imctx, glsl_version = create_window(app)
    app.imctx = imctx
    custom_fonts(app)
    task = @async runloop(glwin, imctx, glsl_version, setup_app, app)
    app.task = task
    env[glwin.handle] = app
    app
end

# module Poptart.Desktop
