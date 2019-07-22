# module Poptart.Animations

const ChronicleTasks = Dict{UInt64,Tuple{Float64,Function,Real}}

"""
    struct Animator
        id::UInt64
        task::Function
        repeatable::Real
    end
"""
struct Animator
    id::UInt64
    task::Function
    repeatable::Real
end

mutable struct Chronicle
    isrunning::Bool
    regulate::Function
    tasks::ChronicleTasks
end

function chronicle_regulator(chronicle_time::Float64)
    isempty(chronicle.tasks) && return
    for (id, (f_time, task, repeatable)) in chronicle.tasks
        f_state = Base.invokelatest(task, f_time, chronicle_time)
        if f_state === nothing
            if isinf(repeatable)
                chronicle.tasks[id] = (time(), task, repeatable)
            else
                repeatable -= 1
                if repeatable > 0
                    chronicle.tasks[id] = (time(), task, repeatable)
                else
                    delete!(chronicle.tasks, id)
                end
            end
        end
    end
end

const chronicle = Chronicle(false, chronicle_regulator, ChronicleTasks())

# module Poptart.Animations
