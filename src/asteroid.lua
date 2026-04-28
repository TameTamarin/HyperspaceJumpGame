local love = require"love"

function asteroid(initSize, initSpeed, initWorld)
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
        restitution = 5,
        
        createBody = function(self, initX, initY)
            self.xPos = initX
            self.yPos = initY
            self.body = love.physics.newBody(self.world, self.xPos, self.yPos, "dynamic")
            self.body:setActive(true)
            self.shape = love.physics.newCircleShape(self.size)
            self.fixture = love.physics.newFixture(self.body, self.shape, 1)
            self.fixture:setUserData("asteroid")
            self.fixture:setRestitution(self.restitution)
            self.body:applyForce(math.random(-1000, 1000) * self.speed, math.random(1000, 2000) * self.speed)
        end,

        draw = function(self)
            if self.body then
                self.xPos, self.yPos = self.body:getPosition()
                love.graphics.circle("fill", self.xPos, self.yPos, self.size)
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
            self.fixture:destroy()
            self.body = nil
            self.fixture = nil
            self.shape = nil
        end
    }
end

return user