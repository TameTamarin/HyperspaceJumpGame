local love = require"love"
local anim8 = require("../libraries/anim8/anim8")

function user(initSize, initSpeed, initWorld, initX, initY, initSpriteImage)
    return {
        size = initSize,
        speed = initSpeed,
        moving = false,
        world = initWorld,
        xPos = initX,
        yPos = initY,
        body = nil,
        shape = nil,
        fixture = nil,
        spriteImage = initSpriteImage,
        imageHeight = nil,
        imageWidth = nil,
        spriteWidth = 65,
        spriteHeight = 65,
        spriteXOffset = 0,
        spriteYOffset = 0,
        grid = nil,
        animation = nil,
        
        createBody = function(self)
            self.body = love.physics.newBody(self.world, self.xPos, self.yPos, "dynamic")
            self.body:setActive(true)
            self.shape = love.physics.newRectangleShape(self.size, self.size)
            self.fixture = love.physics.newFixture(self.body, self.shape, 1)
            self.fixture:setUserData("user")
            self.imageWidth = self.spriteImage:getWidth()
            self.imageHeight = self.spriteImage:getHeight()
            self.grid = anim8.newGrid(self.spriteWidth, self.spriteHeight, self.imageWidth, self.imageHeight, 3, 300, 1)
            self.animation = anim8.newAnimation(self.grid('1-7',1), 0.1)
            self.spriteXOffset = self.spriteWidth/2
            self.spriteYOffset = self.spriteHeight/2
        end,

        draw = function(self)
            self.xPos, self.yPos = self.body:getPosition()
            -- love.graphics.rectangle("fill", self.xPos, self.yPos, self.size, self.size)
            self.animation:draw(self.spriteImage, self.xPos - self.spriteXOffset, self.yPos - self.spriteYOffset)
        end,

        updateAnimation = function(self, dt)
            self.animation:update(dt)
        end,

        move = function(self, newX, newY)
            if self.moving then
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
            self.body:setLinearVelocity(0, 0)
        end,

        setPos = function(self, newX, newY)
            self.xPos = newX
            self.yPos = newY
            self.body:setPosition(newX, newY)
        end,

        currentPos = function(self)
            return self.body:getPosition()
        end,

        destroy = function(self)
            self.fixture:destroy()
            self.body = nil
            self.fixture = nil
            self.shape = nil
        end

    }

end

return user