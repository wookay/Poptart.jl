# module Poptart.Desktop

struct Application <: UIApplication
    windows

    function Application(; window=Windows.Window(), props...)
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
