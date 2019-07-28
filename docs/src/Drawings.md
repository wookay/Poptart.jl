# Poptart.Drawings

Drawings

# shapes
```@docs
Line
Rect
RectMultiColor
Circle
Quad
Triangle
Arc
Pie
Curve
Polyline
Polygon
TextBox
```

# paints
```@docs
Drawings.stroke(element::E) where {E <: DrawingElement}
Drawings.fill(element::E) where {E <: DrawingElement}
```

`stroke ∘ fill`
