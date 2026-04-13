
-- Table to store the game engine variables in
gameEngineVars = {
    worldSleep = false,
    updateSleep = false,
    ignoreNewEvents = false,
    score = 0,
    ballsRemaining = 3,
    ballsActive = 0,
    bumpersHit = 0,
    targetsHit = 0,
    world = nil,
    windowX = 0,
    windowY = 0,
    sx = 0,
    sy = 0,
    gameOver = false,
    gameReset = false,
    drawActions = {},
    clickX = nil,
    clickY = nil,
    upgradeTargetActive = false,
    upgradeList = {},
    upgradeOption1 = "",
    upgradeOption2 = ""
    
}

function love.update(dt)
    -- Control frame rate
    
    -- sleep(DT, FPSCAP)

    cursorX, cursorY = getCursorPosition()
    gameEngineVars.clickX, gameEngineVars.clickY = getMousePosOnClick()

    
    if not gameEngineVars.worldSleep then
        -- getWorld():update(dt, 10, 10)
        updateWorld()
    end

    -- eventCheck()
    -- eventResolve()

    
end
