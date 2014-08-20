--Class used to move camera around and able to follow a body
Player = Class("Player")

function Player:init(x, y)
    self.x = x or 0
    self.y = y or 0
    self.mx = love.mouse.getX()
    self.my = love.mouse.getY()
    self.prevX = 0
    self.prevY = 0
    self.cameraslackX = 0
    self.cameraslackY = 0
    self.ship = nil
    self.isInShip = false
    self.debris = {}
end

function Player:update(dt, camera, mx, my)
    if not self.isInShip then
        self.mx, self.my = mx or love.mouse.getX(), my or love.mouse.getY()
    end
    
    if self.ship then
        
        if self.isInShip then
            if love.keyboard.isDown("up") then self.ship:moveUp() end
            if love.keyboard.isDown("down") then self.ship:moveDown() end
            if love.keyboard.isDown("a") then self.ship:moveLeft() end
            if love.keyboard.isDown("d") then self.ship:moveRight() end
            if love.keyboard.isDown("left") then self.ship:turnLeft() end
            if love.keyboard.isDown("right") then self.ship:turnRight() end
        end
        
        self.ship:update(dt)
        self.x, self.y = self.ship.body:getPosition()
        
        for _, v in pairs(self.ship:findDamagedModules()) do
            self.ship:removeModule(v, self.debris)
        end
        
        for _, v in pairs(self.debris) do
            v:update(dt)
        end
    end

    if camera then
        local cx, cy =  camera:getPos(self.x, self.y)
        if math.abs(cx - self.x) > self.cameraslackX then
            camera:move(self.x - self.prevX, 0)
        end
        if math.abs(cy - self.y) > self.cameraslackY then
            camera:move(0, self.y - self.prevY)
        end
    end

    self.prevX, self.prevY = self.x, self.y
end

function Player:draw()
    if self.ship then
        self.ship:draw()
        for _, v in pairs(self.debris) do
            v:draw()
        end
    end
    if not self.isInShip then
        love.graphics.setColor(Colors.green)
        love.graphics.circle("line", self.mx, self.my, 20)
    end
end
    
function Player:setShip(ship)
    if self.ship and self.ship ~= ship then self.ship.body:destroy() end
    self.ship = ship
    self.ship:setCategory(2)
    self.ship.body:setUserData("Player")
    self.isInShip = true
end

function Player:setPosition(x, y)
    self.ship.body:setPosition(x, y)
    self.x, self.y = x, y
    self.prevX, self.prevY = x, y
end

function Player:setCameraslack(x, y)
    self.cameraslackX = x
    self.cameraslackY = y
end
