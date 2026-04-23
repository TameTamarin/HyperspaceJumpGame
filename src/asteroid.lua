local love = require"love"

function asteroid(initSize, initSpeed, initWorld, initX, initY)
    return {
        size = initSize,
        speed = initSpeed,
        world = initWorld,
        xPos = initX,
        yPos = initY,
        body = nil,
        shape = nil,
        fixture = nil,
        
        createBody = function(self)
            self.body = love.physics.newBody(self.world, self.xPos, self.yPos, "dynamic")
            self.body:setActive(true)
            self.shape = love.physics.newCircleShape(self.size)
            self.fixture = love.physics.newFixture(self.body, self.shape, 10 * self.size)
            self.fixture:setUserData("asteroid")
            self.body:applyForce(math.random(-100, 100), math.random(100, 200))
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