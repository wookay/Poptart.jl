module Poptart

module Interfaces # Poptart
function properties
end
import Base: put!
function remove!
end
end # module Poptart.Interfaces

include("Drawings.jl")
include("Controls.jl")
include("Desktop.jl")

end # module Poptart
