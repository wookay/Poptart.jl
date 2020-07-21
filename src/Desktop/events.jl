# module Poptart.Desktop

module Mouse # Poptart.Desktop

function leftClick(item)
    if item.callback !== nothing
        event = (action=leftClick, )
        item.callback(event)
    end
end

end # module Poptart.Desktop.Mouse


function didClick(f::Union{Nothing,Function}, widget::UIControl)
    widget.callback = f
end

# module Poptart.Desktop
