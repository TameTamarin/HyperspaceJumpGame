-- load in submodules
    require("math")
    local love = require("love")
    local world = require("world")
    local timing = require('timing')
    local keyCommands = require('keyCommands')
    local cursor = require('cursor')
    local utilities = require('utilities')
    -- local engine = require("engine")
    local button = require("button")
    local logFile = require("logFile")
    local user = require("user")
    local object = require("asteroid")

-----------------------------------------------------
--
-- Global Variables
--
-----------------------------------------------------
FPSCAP = 60
WINDOWX = 500
ASPECTRATIO = 19.5/9
WINDOWY = WINDOWX * ASPECTRATIO
XGRAVITY = 0
YGRAVITY = 0


local buttons = {
    menu_state = {},
    settings = {},
    running = {},
    paused = {},
    gameOver = {}
}

gameState = {
    menu = true,
    settings = false,
    running = false,
    paused = false,
    gameOver = false,
    exit = false,

}



-----------------------------------------------------
--
-- Load Function callback
-- 
--  This fuction is called at the beginning of the
--  game start and runs only once
--
-----------------------------------------------------
function love.load()

    local screens = require("screens")
    local utf8 = require("utf8")

    -- Init the in game timer
    timeStart = love.timer.getTime()

    -- Set the random seed
    math.randomseed(os.time())

    -- Set the window size scaled based on screen resolution
    limitsX, limitsY = love.window.getDesktopDimensions()
    sx = limitsX/WINDOWX
    sy = limitsY/WINDOWY
    -- set the window size to 90% of the screen size multiplied by the game window size and VERTICAL scaling
    scaledWinX, scaledWinY = WINDOWX*sy*0.9, WINDOWY*sy*0.9
    -- success = love.window.setMode(scaledWinX, scaledWinY, {vsync = 1})
    success = love.window.setMode(scaledWinX, scaledWinY, {vsync = 1})

    -- Load auido files
    audio = {
        -- bumper = love.audio.newSource("audio/Bumper2.wav", "static")
    }

    -- Run initialization functions
    
    -- dt is the amount of time to advance the physics simulation
    local dt = 1/90
    initWorld(XGRAVITY, YGRAVITY, dt)
    -- gameEngineVars.world = getWorld()


    -------------------------------------------------------------
    -- setup background objects 
    -------------------------------------------------------------

    -------------------------------------------------------------
    -- Setup Buttons
    -------------------------------------------------------------
    buttons.menu_state.play_game = button("Play Game", changeGameState, gameState, "running", 100, 30)
    buttons.menu_state.exit_game = button("Exit Game", love.event.quit, nil, nil, 100, 30)

    buttons.gameOver.play_again = button("Play Again", changeGameState, gameState, "running", 100, 30)
   

    -------------------------------------------------------------
    -- setup user
    -------------------------------------------------------------
    user = user(15, 5, getWorld(), 300, 300)
    user:createBody()
    asteroid = asteroid(50, 5, getWorld(), math.random(0, scaledWinX), 0)
    -- asteroid:createBody()

    ----------------------------------------------------------------
    -- Setup Log file
    ----------------------------------------------------------------
    log = logFile()
    log.enabled = true
    log:init("gameLog.txt", "hyperSpaceJump")
    log:write("this is test text")

    ----------------------------------------------------------------
    -- Setup Canvases for drawing background and the board
    ----------------------------------------------------------------
    

    -- backgroundObjects = love.graphics.newCanvas(gameEngineVars.windowX, gameEngineVars.windowY)
    -- pegLocCanvas = love.graphics.newCanvas(gameEngineVars.windowX, gameEngineVars.windowY)

    -- love.graphics.setCanvas(backgroundObjects)
    --     love.graphics.clear(0, 0, 0, 0)
    --     love.graphics.setBlendMode("alpha")

    --     drawTable()
    --     love.graphics.setCanvas()


    -- -- Canvas for drawing the pegboard locations
    -- love.graphics.setCanvas(pegLocCanvas)
    --     love.graphics.clear(0, 0, 0, 0)
    --     love.graphics.setBlendMode("alpha")
    --     -- drawPegLocations(BOARDSTARTPOS, BOARDSIZEPIXELS, PEGSIZEPIXELS)
    --     love.graphics.setCanvas()

    -- function drawBackgroundObjects()
    --     love.graphics.draw(backgroundObjects, 0, 0)
    -- end

end


-----------------------------------------------------
--
-- Run Function Callback
--
-- This is the main loop of the program.
--
-----------------------------------------------------

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
                    -- close log file on quit
                    log:close()
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end

-----------------------------------------------------
--
-- World and Collisions Function callbacks
--
-- Functions that run when specific tagged events 
-- occur in the world.
--
-- These funcitons need to match the listed functions
-- in the world creation.
--
-----------------------------------------------------
function beginContact(fixture_a, fixture_b, contact)
    local object_a = fixture_a:getUserData()
    local object_b = fixture_b:getUserData()
    log:write("Info: Object_a " .. object_a .. " collided with object_b " .. object_b)

    -- Check if both objects have userData
    if object_a and object_b then
        
        if (object_a == 'asteroid' or object_b == 'asteroid') and (object_a == 'user' or object_b == 'user') then
            changeGameState(gameState, "gameOver")
            asteroid:destroy()
        end
        
    end

end


function endContact(fixture_a, fixture_b, coll)
    local object_a = fixture_a:getUserData()
    local object_b = fixture_b:getUserData()
    
    -- Check for bumper collisions
    if object_a == 'bumper' or object_b == 'bumper' then
        -- do something
    end
end

function preSolve(a, b, coll)
   
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)

end


-----------------------------------------------------
--
-- Update Function callback
-- 
-- This function runs on every interation of the
-- main loop.  This is currently located in the
-- "engine.lua" file
--
-----------------------------------------------------


local cursorX = nil
local cursorY = nil
-- Function call back for when the mouse is released
function love.mousereleased(x, y, button, istouch, presses)
 --  check which buttons have been pressed
    for index in pairs(buttons.menu_state) do
        buttons.menu_state[index]:checkpressed(love.mouse.getX(), love.mouse.getY(), 5)
    end
    cursorX = x
    cursorY = y
end

local worldAwake = true
function love.update(dt)
    updateWorld()
    
end


-----------------------------------------------------
--
-- Helper functions
-- 
-- Funcitons for heloing update the game state
--
-----------------------------------------------------

function changeGameState(gameState, stateEnable)
    for state in pairs(gameState) do
        gameState[state] = false
    end
    gameState[stateEnable] = true
end


-----------------------------------------------------
--
-- States to draw
-- 
-- Funcitons for drawing each state of the game
--
-----------------------------------------------------


function drawMenu()
    buttons.menu_state.play_game:draw(10, 20, 100, 10)
    buttons.menu_state.exit_game:draw(10, 70, 100, 10)
end

function drawSettings()
    love.graphics.print("Settings")
end

function drawRunning()
    -- wull populate when we know what the game will do
    -- love.graphics.circle("fill", love.mouse.getX(), love.mouse.getY(), 5)
    user:draw()
    user:move(cursorX, cursorY)
    asteroid:draw()
    asteroidx, asteroidy = asteroid:getPos()

    -- check if asteroid out of bounds, if no asteroid then create one
    if asteroid.body then
        if asteroidx > scaledWinX or asteroidy > scaledWinY then
            log:write("info: asteroid out of bounds")
            asteroid:destroy()
        end
    else
        asteroid:createBody()
        log:write("info: asteroid created")
        asteroid:move()
    end
end

function drawPaused()
    love.graphics.print("Game is Paused")
end

function drawGameOver()
    love.graphics.print("Game Over")
    -- buttons.gameOver.play_again:draw(scaledWinX * 0.5 - 100, scaledWinY * 0.5, 100, 20)
    buttons.gameOver.play_again:draw(10, 30, 100, 20)
end

function drawNothing()
    -- wull populate when we know what the game will do
    love.graphics.print("placeholder")
end


-----------------------------------------------------
--
-- Draw Function callback
-- 
-- Draws shapes onto the screen.  Runs once every
-- interation of the main loop.
--
-----------------------------------------------------
function love.draw()
    -- homeScreen()
    if gameState.menu then
        drawMenu()
    elseif gameState.settings then
        drawSettings()
    elseif gameState.running then
        drawRunning()
    elseif gameState.paused then
        drawPaused()
    elseif gameState.gameOver then
        drawGameOver()    
    elseif gameState.exit then
        -- draw the exit
    else
        drawNothing()
    end

end
