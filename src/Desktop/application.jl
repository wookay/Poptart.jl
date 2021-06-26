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
    imgui_ctx::Union{Nothing,Ptr}
    task::Union{Nothing,Task}
    dirty::Bool

    function Application(; title::String="App",
                           frame::NamedTuple{(:width,:height)} = (width=400, height=300),
                           windows = UIWindow[Window(title="Title", frame=(x=0,y=0,frame...))],
                           bgcolor = RGBA(0.10, 0.18, 0.24, 1),
                           closenotify::Condition = Condition())
        glwin = glfwGetCurrentContext()
        glwin != C_NULL && haskey(env, glwin) && return env[glwin]
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
        glwin = glfwGetCurrentContext()
        if glwin != C_NULL
            if prop === :title
                glfwSetWindowTitle(glwin, val)
            elseif prop === :frame
                glfwSetWindowSize(glwin, val.width, val.height)
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
        setup_window(app.imgui_ctx, window)
    end
end

"""
    resume(app::UIApplication)
"""
function resume(app::UIApplication)
    glwin = glfwGetCurrentContext()
    glwin != C_NULL && haskey(env, glwin) && return nothing
    create_app(app)
    nothing
end

"""
    pause(::UIApplication)
"""
function pause(::UIApplication)
    glwin = glfwGetCurrentContext()
    glwin != C_NULL && glfwSetWindowShouldClose(glwin, true)
    nothing
end

function create_app(app::UIApplication)
    (imgui_ctx, window_ctx, gl_ctx) = create_window(app)
    app.imgui_ctx = imgui_ctx
    custom_fonts(app)
    # task = runloop(imgui_ctx, window_ctx, gl_ctx, setup_app, app)
    task = @async runloop(imgui_ctx, window_ctx, gl_ctx, setup_app, app)
    app.task = task
    env[gl_ctx] = app
    app
end

# module Poptart.Desktop
