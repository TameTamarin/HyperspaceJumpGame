local love = require"love"
local anim8 = require("../libraries/anim8/anim8")

function wall(initHeight, initWidth, initWorld, initX, initY)
    return {
        scale = 0.5,
        angle = 0,
        distanceTraveled = 0,
        world = initWorld,
        startX = initX,
        startY = initY,
        height = initHeight,
        width = initWidth,
        xPos = nil,
        yPos = nil,
        body = nil,
        bodyXOffset = nil,
        bodyYOffset = nil,
        shape = nil,
        fixture = nil,
        imageHeight = nil,
        imageWidth = nil,
        spriteWidth = 70,
        spriteHeight = 240,
        spriteXOffset = 0,
        spriteYOffset = 0,
        grid = nil,
        animation = nil,
        frames = nil,
        
        setDefaults = function(self)
            self.xPos = self.startX
            self.yPos = self.startY
            self.scale = 0.5
        end,
        
        createBody = function(self)
            self.body = love.physics.newBody(self.world, self.startX, self.startY, "static")
            self.body:setActive(true)
            self.shape = love.physics.newRectangleShape(self.width, self.height) -- We use a rectangle shape because of the body and tail of the sperm
            self.fixture = love.physics.newFixture(self.body, self.shape, 1)
            self.fixture:setUserData("wall")
            -- self.imageWidth = self.spriteImage:getWidth()
            -- self.imageHeight = self.spriteImage:getHeight()
            -- self.grid = anim8.newGrid(self.spriteWidth, self.spriteHeight, self.imageWidth, self.imageHeight, 3, 300, 1)
            -- self.grid = anim8.newGrid(self.spriteWidth, self.spriteHeight, self.imageWidth, self.imageHeight, 0, 0, 1)
            -- self.frames = self.grid('1-6' ,1)
            -- self.animation = anim8.newAnimation(self.frames, 0.1)
            -- self.spriteXOffset = self.spriteWidth/2 * self.scale
            -- self.spriteYOffset = self.spriteHeight/2 * self.scale
        end,

        draw = function(self)
            if self.body then
                self.xPos, self.yPos = self.body:getPosition()
                love.graphics.rectangle("fill", self.xPos, self.yPos, self.width, self.height)
                -- self.animation:draw(self.spriteImage, self.xPos - self.spriteXOffset, self.yPos - self.spriteYOffset,  self.angle, self.scale, self.scale)
            end
        end,

        updateAnimation = function(self, dt)
            if self.body then
                self.animation:update(dt)
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
                self.distanceTraveled = 0
            end
        end

    }

end

return wall