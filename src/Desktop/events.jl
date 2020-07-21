# module Poptart.Desktop

module Mouse # Poptart.Desktop

"""
    leftClick(item)
"""
function leftClick(item)
    if item.callback !== nothing
        event = (action=leftClick, )
        item.callback(event)
    end
end

end # module Poptart.Desktop.Mouse


"""
    didClick(f::Union{Nothing,Function}, widget::UIControl)
"""
function didClick(f::Union{Nothing,Function}, widget::UIControl)
    widget.callback = f
end

# module Poptart.Desktop
