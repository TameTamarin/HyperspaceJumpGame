local love = require"love"

function user(initSize, initSpeed, initWorld, initX, initY)
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
            self.shape = love.physics.newRectangleShape(self.size, self.size)
            self.fixture = love.physics.newFixture(self.body, self.shape, 1)
        end,

        draw = function(self)
            self.xPos, self.yPos = self.body:getPosition()
            love.graphics.rectangle("fill", self.xPos, self.yPos, self.size, self.size)
        end,

        move = function(self, newX, newY)
            
            self.body:setLinearVelocity((newX - self.xPos) * self.speed, (newY - self.yPos) * self.speed)
        end
    }
end

return user