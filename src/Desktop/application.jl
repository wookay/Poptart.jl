# module Poptart.Desktop

abstract type UIApplication end
abstract type UIWindow end

struct Window <: UIWindow

    function Window(; props...)
        new()
    end
end

struct Application <: UIApplication
    windows

    function Application(; props...)
        window = Window()
        windows = [window]
        new(windows)
    end
end


function Base.getproperty(app::A, prop::Symbol) where {A <: UIApplication}
    if prop in (:window,)
        first(app.windows)
    else
        getfield(app, prop)
    end
end

# module Poptart.Desktop
