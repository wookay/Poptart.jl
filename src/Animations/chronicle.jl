# module Poptart.Animations

const ChronicleTasks = Dict{UInt64,Tuple{Float64,Function}}

"""
    struct Animator
        id::UInt64
        task::Function
    end
"""
struct Animator
    id::UInt64
    task::Function
end

mutable struct Chronicle
    isrunning::Bool
    regulate::Function
    tasks::ChronicleTasks
    repeatable::Dict{UInt64,Real}
end

function chronicle_regulator(chronicle_time::Float64)
    isempty(chronicle.tasks) && return
    for (id, (f_time, task)) in chronicle.tasks
        f_state = Base.invokelatest(task, f_time, chronicle_time)
        if f_state === nothing
            if haskey(chronicle.repeatable, id)
                n = chronicle.repeatable[id]
                if isinf(n)
                    chronicle.tasks[id] = (time(), task)
                else
                    n -= 1
                    if n < 0
                        delete!(chronicle.repeatable, id)
                        delete!(chronicle.tasks, id)
                    else
                        chronicle.repeatable[id] = n
                        chronicle.tasks[id] = (time(), task)
                    end
                end
            else
                delete!(chronicle.tasks, id)
            end
        end
    end
end

const chronicle = Chronicle(false, chronicle_regulator, ChronicleTasks(), Dict{UInt64,Real}())

# module Poptart.Animations
