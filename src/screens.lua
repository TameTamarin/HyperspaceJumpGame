
-----------------------------------------------------
--
-- Function for drawing the selectable options on
-- screen
--
-----------------------------------------------------

function drawOptions(selectionOptions)
    local font = love.graphics.getFont()
    function strlngth(inputText)
        local text = love.graphics.newText(font, inputText)
        return tostring(text:getDimensions())
    end

    for _, option in ipairs(selectionOptions) do
        love.graphics.print(option.text, option.x, option.y)
    end
    
end


-----------------------------------------------------
--
-- Home Screen
-- 
-- Draws the home screen for startup
--
-----------------------------------------------------


function homeScreen()
    local selectionIndex = 1
    local rightKeyToggle = 0
    local options = {
            {text = "New Game", x = 100, y = 30},
            {text = "settings", x = 100, y = 50}
        }

    function love.draw()
        drawOptions(options)
        love.graphics.circle("fill", options[selectionIndex].x - strlngth(options[selectionIndex].x), options[selectionIndex].y, 5)

        -- check that the right key ahs been toggled and increment the selection index appropriately
        if rightKeyToggle == 0 and rightKeyCheck() == 1 then
            rightKeyToggle = 1
            selectionIndex = selectionIndex + 1
            if selectionIndex > 2 then 
                selectionIndex = 1
            end
        elseif rightKeyToggle == 1 and rightKeyCheck() == 0 then
            rightKeyToggle = 0
        end
            
        
        if gameEngineVars.clickX then
            if numericLimitTest(gameEngineVars.clickX, options[1].x, options[1].x + strlngth("New Game")) and numericLimitTest(gameEngineVars.clickY, options[1].y, options[1].y + 10) then
                -- queueEvent(newGame)
                gameScreen()
            end
        end

        -- mouse click handling
        function love.mousereleased(x, y, button, istouch, presses)
            if button == 1 then
                gameEngineVars.clickX = x
                gameEngineVars.clickY = y
            end

        end
    end
end


-----------------------------------------------------
--
-- Game Over Screen
-- 
-- Draws when game over
--
-----------------------------------------------------

function gameOverScreen()
    gameEngineVars.clickX = nil
    gameEngineVars.clickY = nil
    local options = {
            {text = "gameOver", x = 100, y = 10},
            {text = "score", x = 100, y = 30},
            {text = "newGame", x = 100,y = 50},
            {text = "quit", x = 100, y = 70}
        }
    function love.draw()
        
        drawOptions(options)

        if gameEngineVars.clickX then
            if numericLimitTest(gameEngineVars.clickX, options[3].x, options[3].x + strlngth("New Game")) and numericLimitTest(gameEngineVars.clickY, options[3].y, options[3].y + 10) then
                -- queueEvent(newGame)
                gameScreen()
            end
        end

        -- mouse click handling
        function love.mousereleased(x, y, button, istouch, presses)
            if button == 1 then
                gameEngineVars.clickX = x
                gameEngineVars.clickY = y
            end
        end
    end
end



-----------------------------------------------------
--
-- Primary Game Screen
-- 
-- This is where most of the game takes place
--
-----------------------------------------------------

local test = {
    x = 5,
    y = function(self) return self.x + 10 end
}

function gameScreen()
    local font = love.graphics.getFont()
    local text = love.graphics.newText(font, "hello world")

    function love.draw()
        
    -- Helper Function to draw all objects
    function drawActions()
        for i, action in pairs(gameEngineVars.drawActions) do
            if action ~= nil then
                action()
            end
        end
    end


    -- set scale to draw at based on on the screen resoltion and window size
    
    
    -- draw objects
    
    love.graphics.push()
    love.graphics.scale( gameEngineVars.sy, gameEngineVars.sy )
    -- drawActions()


    love.graphics.print("Cursor Position ..." .. tostring(cursorX)..", "..tostring(cursorY), 0, 20)

    -- love.graphics.print("Current elapsed game time ..." .. tostring(elapsedTime()), 40, 100)
    love.graphics.print("Mouse clicked ..." .. tostring(gameEngineVars.clickX) .. " " .. tostring(gameEngineVars.clickY), 0, 40)

    love.graphics.print("Collision:" .. tostring(printdata), 0, 60)

    love.graphics.print("Balls active " .. tostring(gameEngineVars.ballsActive), 0, 70)
    
    love.graphics.print("Balls Remaining: " .. tostring(gameEngineVars.ballsRemaining), 0, 80)

    love.graphics.print("string width " .. tostring(text:getDimensions()), 0, 90)

    love.graphics.print("test " .. tostring(test:y()), 0, 100)

    -- getNumEvents()

    -- mouse click handling
    function love.mousereleased(x, y, button, istouch, presses)
        if button == 1 and gameEngineVars.ballsRemaining > 0 then
            gameEngineVars.clickX = x
            gameEngineVars.clickY = y
        end
    end
    
    writeToLogFile("num active balls", gameEngineVars.ballsActive)
    writeToLogFile("num remaining balls", gameEngineVars.ballsRemaining)
    

    -- return to normal scale to prevent crashing
    love.graphics.pop()
    end
end

