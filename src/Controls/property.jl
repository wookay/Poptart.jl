# module Poptart.Controls

"""
    Property(; name::String, range, value::Ref)
"""
Property

@UI Property

function properties(control::Property)
    (properties(super(control))..., :name, :range, :value)
end

# module Poptart.Controls
