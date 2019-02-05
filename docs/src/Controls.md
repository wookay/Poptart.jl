### Poptart.Controls

### events
```@docs
didClick(block, control::C) where {C <: UIControl}
onHover(block, control::C) where {C <: UIControl}
```

### widgets
```@docs
Button
Slider
Property
Label
SelectableLabel
CheckBox
Radio
ComboBox
ProgressBar
Chart
ImageView
```

### popups
```@docs
ToolTip
Popup
MenuBar
Menu
MenuItem
Contextual
ContextualItem
```

### layouts
```@docs
StaticRow
DynamicRow
Spacing
```

### canvas
```@docs
Canvas
Controls.put!(canvas::Canvas, elements::Drawings.Drawing...)
Controls.remove!(canvas::Canvas, elements::Drawings.Drawing...)
```
