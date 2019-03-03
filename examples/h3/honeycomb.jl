using H3.API # GeoCoord geoToH3 kRing h3ToGeoBoundary

base = geoToH3(GeoCoord(0, 0), 1)
rings = kRing(base, 3)

x = Vector{Float64}()
y = Vector{Float64}()
for boundary in h3ToGeoBoundary.(rings), geo in boundary
    push!(x, geo.lon) # 經度
    push!(y, geo.lat) # 緯度
end

using Poptart.Desktop # Application Windows
using Poptart.Controls # Canvas put! remove!
using Poptart.Drawings # Line Rect RectMultiColor Circle Triangle stroke fill
using Nuklear.LibNuklear: NK_WINDOW_TITLE
using Colors: RGBA

canvas = Canvas()
window1 = Windows.Window([canvas], title="A", frame=(x=0, y=0, width=500, height=400), flags=NK_WINDOW_TITLE)
Application(windows=[window1], title="App", frame=(width=500, height=400))

strokeColor = RGBA(0,0.7,0,1)
for boundary in h3ToGeoBoundary.(rings)
    points = [(geo.lon, geo.lat) .* 300 .+ 150 for geo in boundary]
    polygon = Polygon(points=points, thickness=7.5, color=strokeColor)
    put!(canvas, stroke(polygon))
end
