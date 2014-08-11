--Class used to move camera around and able to follow a body
Player = Class()

function Player:init()
    self.x = 0
    self.y = 0
    self.prevX = 0
    self.prevY = 0
    self.cameraslackX = 0
    self.cameraslackY = 0
end

function Player:update(dt, camera)
    if self.body then
        self.x, self.y = self.body:getPosition()
    end

    if camera then
        local cx, cy =  camera:getTranslatedPosition(self.x, self.y)

        if math.abs(cx - love.window.getWidth()/2) > self.cameraslackX then
            camera:move(self.x - self.prevX, 0)
        end
        if math.abs(cy - love.window.getHeight()/2) > self.cameraslackY then
            camera:move(0, self.y - self.prevY)
        end
    end

    self.prevX, self.prevY = self.x, self.y
end

function Player:followBody(body)
    self.body = body
    self.x, self.y = body:getPosition()
    self.prevX, self.prevY = self.x, self.y
end

function Player:setPosition(x, y)
    self.x, self.y = x, y
    self.prevX, self.prevY = x, y
end

function Player:setCameraslack(x, y)
    self.cameraslackX = x
    self.cameraslackY = y
end
