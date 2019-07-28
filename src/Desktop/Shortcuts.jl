module Shortcuts # module Poptart.Desktop

export Shift, Ctrl, Alt, Super, Key, didPress, Esc, Enter, Space, Backspace

struct Modifier
    name::Symbol
end

struct Key
    value::Int
    function Key(value::Int)
        new(value)
    end
    function Key(letter::Char)
        new(Int(uppercase(letter)))
    end
end

struct Conjunction
    shift::Bool
    ctrl::Bool
    alt::Bool
    super::Bool
    key::Union{Nothing,Key}
end

pressed_modifier_callbacks = Dict{Conjunction, Function}()
pressed_conjunction_callbacks = Dict{Conjunction, Function}()
pressed_key_callbacks = Dict{Key, Function}()

const Shift = Modifier(:Shift)
const Ctrl = Modifier(:Ctrl)
const Alt  = Modifier(:Alt)
const Super = Modifier(:Super)
const Esc       = Key(256)
const Enter     = Key(257)
const Space     = Key(' ') # 32
const Backspace = Key(259)

function _conjunction_from_modifiers(modifiers::Vector{Modifier})::NamedTuple{(:shift, :ctrl, :alt, :super)}
    shift, ctrl, alt, super = false, false, false, false
    for modifier in modifiers
        if modifier.name === :Shift
            shift = true
        elseif modifier.name === :Ctrl
            ctrl = true
        elseif modifier.name === :Alt
            alt = true
        elseif modifier.name === :Super
            super = true
        end
    end
    (shift=shift, ctrl=ctrl, alt=alt, super=super)
end

function Base.:(+)(a::Modifier, key::Key)
    Conjunction(_conjunction_from_modifiers([a])..., key)
end

function Base.:(+)(a::Modifier, b::Modifier)
    Conjunction(_conjunction_from_modifiers([a, b])..., nothing)
end

function Base.:(+)(a::Modifier, b::Modifier, key::Key)
    Conjunction(_conjunction_from_modifiers([a, b])..., key)
end

function Base.:(+)(a::Modifier, b::Modifier, c::Modifier)
    Conjunction(_conjunction_from_modifiers([a, b, c])..., nothing)
end

function Base.:(+)(a::Modifier, b::Modifier, c::Modifier, key::Key)
    Conjunction(_conjunction_from_modifiers([a, b, c])..., key)
end

function didPress(f, key::Key)
    pressed_key_callbacks[key] = f
end

function didPress(f, modifier::Modifier)
    conjuction = Conjunction(_conjunction_from_modifiers([modifier])..., nothing)
    didPress(f, conjuction)
end

function didPress(f, conjuction::Conjunction)
    if conjuction.key === nothing
        pressed_modifier_callbacks[conjuction] = f
    else
        pressed_conjunction_callbacks[conjuction] = f
    end
end

function Base.empty!(::typeof(didPress))
    empty!(pressed_key_callbacks)
    empty!(pressed_modifier_callbacks)
    empty!(pressed_conjunction_callbacks)
    nothing
end

end # module Poptart.Desktop.Shortcuts
