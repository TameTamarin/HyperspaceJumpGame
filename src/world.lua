local world
local dt

function initWorld(xGrav, yGrav, deltaTime)
    world = love.physics.newWorld(xGrav, yGrav, true)
    dt = deltaTime
    world:setSleepingAllowed(true)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
end

function getWorld()
    return world
end

function updateWorld()
    world:update((dt), 10, 10)
end



