local love = require"love"
local anim8 = require("../libraries/anim8/anim8")


-- What this code needs to do
--     - selct the upgrade
--     - apply the upgrade to the user or the game
--     - draw the upgrade
--     - keep track of the applied upgrades
--     - remove an upgrade
--     - there are only 26 chromosomes in a human, 13 from each parent.  We need to generate 26 that can be possibly obtained and have the user end with 13
--     - what are the potential upgrades
--         - increase/decrase size
--         - increase/decrease move speed
--         - increase/decrease game screen speed
--         - change color
--         - give shield to hitting objects
--         - decrease/increase frequency of object spawns
--         - move when cursor is moved
--         - lose jump ability
--         - gain jump ability
--         - fire projectile when jumping/upgrade projectile
--         - object spawned decrease/increase in size

function upgrade()
    return {

        increaseSpeed = function(self, userAttributes, gameAttributes)
            userAttributes.speed = userAttributes.speed + 10 
            return userAttributes, gameAttributes
        end,


        increaseSize = function(self, userAttributes, gameAttributes)
            userAttributes.size = userAttributes.size + 10 
            return userAttributes, gameAttributes
        end,
        
        createBody = function(self)
            self.body = love.physics.newBody(self.world, self.startX, self.startY, "dynamic")
            self.body:setActive(true)
            self.shape = love.physics.newRectangleShape(self.spriteWidth, self.spriteHeight)
            self.fixture = love.physics.newFixture(self.body, self.shape, 1)
            self.fixture:setUserData("user")
            self.imageWidth = self.spriteImage:getWidth()
            self.imageHeight = self.spriteImage:getHeight()
            -- self.grid = anim8.newGrid(self.spriteWidth, self.spriteHeight, self.imageWidth, self.imageHeight, 3, 300, 1)
            self.grid = anim8.newGrid(self.spriteWidth, self.spriteHeight, self.imageWidth, self.imageHeight, 0, 0, 1)
            self.animation = anim8.newAnimation(self.grid('1-1',1), 0.1)
            self.spriteXOffset = self.spriteWidth/2
            self.spriteYOffset = self.spriteHeight/2
        end,

        draw = function(self)
            if self.body then
                self.xPos, self.yPos = self.body:getPosition()
                love.graphics.rectangle("fill", self.xPos, self.yPos, self.size, self.size)
                -- self.animation:draw(self.spriteImage, self.xPos - self.spriteXOffset, self.yPos - self.spriteYOffset)
            end
        end,

        updateAnimation = function(self, dt)
            if self.body then
                self.animation:update(dt)
            end
        end,

        move = function(self, newX, newY)
            if self.moving and self.body then
                self.body:setLinearVelocity((newX - self.xPos) * self.speed, (newY - self.yPos) * self.speed)
                self.xPos, self.yPos = self:currentPos()
                -- stop movement once we have gotten within tolerance of new pos
                if (self.xPos + 5 > newX and self.xPos - 5 < newX) and (self.yPos + 5 > newY and self.yPos - 5 < newY) then
                    self:stop(0,0)
                    self.moving = false
                end
            end
        end,

        stop = function(self)
            if self.body then
                self.body:setLinearVelocity(0, 0)
            end
        end,

        setPos = function(self, newX, newY)
            if self.body then
                self.xPos = newX
                self.yPos = newY
                self.body:setPosition(newX, newY)
            end
        end,

        currentPos = function(self)
            if self.body then
                return self.body:getPosition()
            end
        end,

        destroy = function(self)
            if self.body then
                self.fixture:destroy()
                self.body = nil
                self.fixture = nil
                self.shape = nil
            end
        end

    }

end

return upgrade