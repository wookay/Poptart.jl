module Shortcuts # module Poptart.Desktop

export Ctrl, Alt, Shift, Space, Key, didPress

struct ModifierKey
    modifier::Symbol
end

struct Key
    letter::Char
end

struct Conjunction
    keys::Set
end

const Ctrl = ModifierKey(:Ctrl)
const Alt  = ModifierKey(:Alt)
const Shift = ModifierKey(:Shift)
const Space = Key(' ')

function Base.:(+)(a::ModifierKey, b::Key)
    Conjunction(Set([a, b]))
end

function didPress(f, key::Key)
end

function didPress(f, conjuction::Conjunction)
end

end # module Poptart.Desktop.Shortcuts
