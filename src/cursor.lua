CLICKED = false

function getCursorPosition()
    x, y = love.mouse.getPosition( )
    return x,y
end

function checkMouseClick()
    -- Checks if the primary mouse button is depressed
    button = 1
    down = love.mouse.isDown(button)
    return down
end

function getMousePosOnClick()
    if not CLICKED and checkMouseClick() then
        clickedXPos, clickedYPos = getCursorPosition()
        return love.mouse.getPosition( )
    else
        return clickedXPos, clickedYPos
    end
end