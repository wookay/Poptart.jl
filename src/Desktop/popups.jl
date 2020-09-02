# module Poptart.Desktop

function OpenPopup(popup::Popup)
    CImGui.OpenPopup(popup.label)
end

# module Poptart.Desktop