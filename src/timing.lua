--vFunctions for handling timing
TIMESTART = 0

function timeStart()
    TIMESTART = love.timer.getTime()
end

function elapsedTime()
    -- Returns the elapsed time since the start of the execution
    return love.timer.getTime() - TIMESTART
end


function sleep(dt, fpscap)
    -- Sleeps for the amount of time equal to one period of the FCAP
    local s = 1/fpscap - dt
    if s > 0 then love.timer.sleep(s) end
end

