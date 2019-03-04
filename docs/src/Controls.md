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
MixedChart
ImageView
```

### menus
```@docs
ToolTip
Popup
MenuBar
Menu
MenuItem
Contextual
ContextualItem
TreeItem
```

### layouts
```@docs
StaticRow
DynamicRow
Spacing
Group
```

### canvas
```@docs
Canvas
Controls.put!(canvas::Canvas, elements::Drawings.Drawing...)
Controls.remove!(canvas::Canvas, elements::Drawings.Drawing...)
Base.empty!(canvas::Canvas)
```
