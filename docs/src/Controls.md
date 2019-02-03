### Poptart.Controls

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
ImageView
StaticRow
DynamicRow
ToolTip
Chart
```

```@docs
didClick(block, control::C) where {C <: UIControl}
onHover(block, control::C) where {C <: UIControl}
```

```@docs
Canvas
Controls.put!(canvas::Canvas, elements::Drawings.Drawing...)
Controls.remove!(canvas::Canvas, elements::Drawings.Drawing...)
```
