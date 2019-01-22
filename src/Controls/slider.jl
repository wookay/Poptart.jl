# module Poptart.Controls

struct Slider <: UIControl

    function Slider(; props...)
        new()
    end
end

function Base.setproperty!(control::Slider, prop::Symbol, val)
    if prop in (:value,)
    else
        setproperty!(control, prop, val)
    end
end

# module Poptart.Controls
