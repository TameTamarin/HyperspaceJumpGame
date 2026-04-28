local love = require"love"

function user(initSize, initSpeed, initWorld, initX, initY)
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
        
        createBody = function(self)
            self.body = love.physics.newBody(self.world, self.xPos, self.yPos, "dynamic")
            self.body:setActive(true)
            self.shape = love.physics.newRectangleShape(self.size, self.size)
            self.fixture = love.physics.newFixture(self.body, self.shape, 1)
            self.fixture:setUserData("user")
        end,

        draw = function(self)
            self.xPos, self.yPos = self.body:getPosition()
            love.graphics.rectangle("fill", self.xPos, self.yPos, self.size, self.size)
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