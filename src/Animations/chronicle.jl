# module Poptart.Animations

const ChronicleTasks = Dict{UInt64,Tuple{Float64,Function}}

"""
    struct Animator
        key::UInt64
        task::Function
    end
"""
struct Animator
    key::UInt64
    task::Function
end

mutable struct Chronicle
    isrunning::Bool
    loader::Function
    tasks::ChronicleTasks
    repeatable::Dict{UInt64,Real}
end

function chronicle_loader(chronicle_time::Float64)
    isempty(chronicle.tasks) && return
    for (key, (f_time, task)) in chronicle.tasks
        f_state = Base.invokelatest(task, f_time, chronicle_time)
        if f_state === nothing
            if haskey(chronicle.repeatable, key)
                n = chronicle.repeatable[key]
                if isinf(n)
                    chronicle.tasks[key] = (time(), task)
                else
                    n -= 1
                    if n < 0
                        delete!(chronicle.repeatable, key)
                        delete!(chronicle.tasks, key)
                    else
                        chronicle.repeatable[key] = n
                        chronicle.tasks[key] = (time(), task)
                    end
                end
            else
                delete!(chronicle.tasks, key)
            end
        end
    end
end

const chronicle = Chronicle(false, chronicle_loader, ChronicleTasks(), Dict{UInt64,Real}())

# module Poptart.Animations
