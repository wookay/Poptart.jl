# module Poptart.Desktop

"""
    OpenPopup(popup::Popup)
"""
function OpenPopup(popup::Popup)
    open(popup)
end


"""
    open(popup::Popup)

Open the popup
"""
function Base.open(popup::Popup)
    CImGui.OpenPopup(popup.label)
end

# module Poptart.Desktop
