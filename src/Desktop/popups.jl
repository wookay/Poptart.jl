# module Poptart.Desktop

"""
    OpenPopup(popup::Popup)
"""
function OpenPopup(popup::Popup)
    CImGui.OpenPopup(popup.label)
end

# module Poptart.Desktop
