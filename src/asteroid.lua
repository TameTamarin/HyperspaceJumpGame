local love = require"love"
local anim8 = require("../libraries/anim8/anim8")

function asteroid(initSize, initSpeed, initWorld, initSpriteImage)
    return {
        size = initSize,
        speed = initSpeed,
        active = false,
        world = initWorld,
        xPos = 0,
        yPos = 0,
        body = nil,
        shape = nil,
        fixture = nil,
        restitution = 2,
        spriteImage = initSpriteImage,
        imageHeight = nil,
        imageWidth = nil,
        spriteWidth = 64,
        spriteHeight = 64,
        spriteXOffset = 0,
        spriteYOffset = 0,
        grid = nil,
        animation = nil,
        
        createBody = function(self, initX, initY)
            self.xPos = initX
            self.yPos = initY
            self.body = love.physics.newBody(self.world, self.xPos, self.yPos, "dynamic")
            self.body:setActive(true)
            self.shape = love.physics.newCircleShape(self.spriteHeight/2)
            self.fixture = love.physics.newFixture(self.body, self.shape, 1)
            self.fixture:setUserData("asteroid")
            self.fixture:setRestitution(self.restitution)
            self.body:applyForce(math.random(-1000, 1000) * self.speed, math.random(1000, 2000) * self.speed)
            self.imageWidth = self.spriteImage:getWidth()
            self.imageHeight = self.spriteImage:getHeight()
            -- self.grid = anim8.newGrid(self.spriteWidth, self.spriteHeight, self.imageWidth, self.imageHeight, 3, 300, 1)
            self.grid = anim8.newGrid(self.spriteWidth, self.spriteHeight, self.imageWidth, self.imageHeight, 3, 300, 1)
            self.animation = anim8.newAnimation(self.grid('1-3',1), 0.1)
            self.spriteXOffset = self.spriteWidth/2
            self.spriteYOffset = self.spriteHeight/2
        end,

        draw = function(self)
            if self.body then
                self.xPos, self.yPos = self.body:getPosition()
                -- love.graphics.circle("fill", self.xPos, self.yPos, self.size)
                self.animation:draw(self.spriteImage, self.xPos - self.spriteXOffset, self.yPos - self.spriteYOffset)
            end
        end,

        updateAnimation = function(self, dt)
            if self.body then
                self.animation:update(dt)
            end
        end,

        move = function(self)
            self.body:setLinearVelocity(math.random(), 10)
        end,

        getPos = function(self)
            if self.body then
                return self.body:getPosition()
            end
            return 0,0
        end,

        setPos = function(self, newX, newY)
            if self.body then
                self.xPos = newX
                self.yPos = newY
                self.body:setPosition(newX, newY)
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

return user