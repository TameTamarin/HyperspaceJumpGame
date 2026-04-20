local love = require"love"

function user(initSize, initSpeed, initWorld, initX, initY)
    return {
        size = initSize,
        speed = speed,
        world = initWorld,
        xPos = initX,
        yPos = initY,
        body = nil,
        shape = nil,
        fixture = nil,
        
        createBody = function(self)
            self.body = love.physics.newBody(self.world, self.xPos, self.yPos, "static")
            self.shape = love.physics.newCircleShape(self.size)
            self.fixture = love.physics.newFixture(self.body, self.shape, 1)
        end,

        draw = function(self)
            love.graphics.circle("fill", self.xPos, self.yPos, self.size)
        end,

        move = function(self, newX, newY)
            self.xPos = newX
            self.yPos = newY
        end
    }
end

return user