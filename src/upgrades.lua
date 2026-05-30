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

function upgrade(initSize, initSpeed, initWorld, initX, initY, initSpriteImage)
    return {

        size = initSize,
        speed = initSpeed,
        moving = false,
        world = initWorld,
        startX = initX,
        startY = initY,
        xPos = nil,
        yPos = nil,
        body = nil,
        shape = nil,
        fixture = nil,
        spriteImage = initSpriteImage,
        imageHeight = nil,
        imageWidth = nil,
        spriteWidth = 16,
        spriteHeight = 48,
        spriteXOffset = 0,
        spriteYOffset = 0,
        grid = nil,
        animation = nil,
        wasDestroyed = false,

        upgradeOptions = {
            "increaseSpeed",
            -- "decreaseSize",
            -- "increaseSize",
            -- "decreaseSize",
            -- "shield",
            -- "jump",
            -- "followCursor",
            -- "fireProjectile",
            -- "loseJump",
            -- "spawnRateDecrease"
        },

        upgradeList = {
            -- "increaseSize",
            -- "increaseSpeed",
            -- "increaseSpeed",
            -- "increaseSize"
        },

        spriteImage = initSpriteImage,

        addUpgrade = function(self, option)
            table.insert(self.upgradeList, self.upgradeOptions[option])
        end,

        removeUpgrade = function(self, option)
            table.remove(self.upgradeList, self.upgradeOptions[option])
        end,

        nextToApply = function(self)
           return self.upgradeList[1]
        end,

        applyUpgrade = function(self, inputUserAttributes, inputGameAttributes)
            -- self.upgradeList[1]:applyUpgrade(inputUserAttributes, inputGameAttributes)
            self.upgradeList[1]:temp(inputUserAttributes, inputGameAttributes)
            -- return UserAttributes, inputGameAttributes
        end,

        removeAppliedUpgrade = function(self)
            table.remove(self.upgradeList, 1)
        end,

        createUpgradeList = function(self)
            numOptions = table.getn(self.upgradeOptions)
            for index = 0, 1, 1 do
                self:addUpgrade(math.random(1, numOptions))
            end
        end,

        -- For the following upgrade functions we do not need to
        -- have self as an argument because we do not ever refer
        -- to an attribute that is within the table

        increaseSpeed = function(userAttributes, gameAttributes)
            -- userAttributes.speed = userAttributes.speed + 10
            gameAttributes.screen_shift = gameAttributes.screen_shift + 2
            return userAttributes, gameAttributes
        end,

        increaseSize = function(userAttributes, gameAttributes)
            userAttributes.size = userAttributes.size + 10
            userAttributes.scale = userAttributes.scale + 1
            return userAttributes, gameAttributes
        end,

        invulnerableUpgrades = function(userAttributes, gameAttributes)
            gameAttributes.invulnerableUpgrades = true
        end,

        createBody = function(self, initX, initY)
            if not self.body then
                self.body = love.physics.newBody(self.world, initX, initY, "dynamic")
                self.body:setActive(true)
                self.shape = love.physics.newRectangleShape(self.spriteWidth, self.spriteHeight)
                self.fixture = love.physics.newFixture(self.body, self.shape, 1)
                self.fixture:setUserData("upgrade")
                self.imageWidth = self.spriteImage:getWidth()
                self.imageHeight = self.spriteImage:getHeight()
                -- self.grid = anim8.newGrid(self.spriteWidth, self.spriteHeight, self.imageWidth, self.imageHeight, 3, 300, 1)
                self.grid = anim8.newGrid(self.spriteWidth, self.spriteHeight, self.imageWidth, self.imageHeight, 0, 0, 1)
                self.animation = anim8.newAnimation(self.grid('1-1',1), 0.1)
                self.spriteXOffset = self.spriteWidth/2
                self.spriteYOffset = self.spriteHeight/2
                self.wasDestroyed = false
            end
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

        getPos = function(self)
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
                self.wasDestroyed = true
            end
        end

    }

end

return upgrade