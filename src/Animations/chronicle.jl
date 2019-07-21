# module Poptart.Animations

const ChronicleTasks = Dict{Float64,Function}

mutable struct Chronicle
    isrunning::Bool
    loader::Function
    tasks::ChronicleTasks
end

function chronicle_loader(chronicle_time::Float64)
    isempty(chronicle.tasks) && return
    for (f_time, f) in chronicle.tasks
        f_state = Base.invokelatest(f, f_time, chronicle_time)
        f_state === nothing && delete!(chronicle.tasks, f_time)
    end
end

const chronicle = Chronicle(false, chronicle_loader, ChronicleTasks())

# module Poptart.Animations
