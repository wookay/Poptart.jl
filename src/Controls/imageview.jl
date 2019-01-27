# module Poptart.Controls

@UI ImageView begin
    function ImageView(; props...)
        !isdefined(Controls, :Images) && Base.eval(Controls, :(using Images))
        new(Dict{Symbol, Any}(props...), Dict{Symbol, Vector}())
    end
end

function properties(control::ImageView)
    (properties(super(control))..., :path, )
end

# module Poptart.Controls
