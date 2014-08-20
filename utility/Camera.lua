Camera = Class("Camera")
Camera.x = 0
Camera.y = 0
Camera.scale = 1
Camera.rotation = 0

Camera.layers = {}

function Camera:set(layerKey) 

    local cx,cy = love.graphics.getWidth()/(2*self.scale), love.graphics.getHeight()/(2*self.scale)
    love.graphics.push()
    love.graphics.scale(self.scale)
    love.graphics.translate(cx, cy)
    love.graphics.rotate(self.rotation)

    if layerKey then
        love.graphics.translate(-self.layers[layerKey].x, -self.layers[layerKey].y)
    else
        love.graphics.translate(-self.x, -self.y)
    end
end

function Camera:unset()
    love.graphics.pop()
end

function Camera:move(dx, dy)
    self.x = self.x + (dx or 0)
    self.y = self.y + (dy or 0)

    self:moveTo(self.x, self.y)

    for _, v in pairs(self.layers) do
        v.x = v.x + (dx or 0) * v.speedRatio
        v.y = v.y + (dy or 0) * v.speedRatio
    end
end

function Camera:moveTo(x, y)
    if x then self:setX(x) end
    if y then self:setY(y) end
end

function Camera:rotate(dr)
    self.rotation = self.rotation + dr
end

function Camera:rotateTo(r)
    self.rotation = r
end

function Camera:zoom(factor)
    self.scale = self.scale * factor
end

function Camera:zoomTo(scale)
    self.scale = scale
end

function Camera:setX(value)
    if self.bounds then
        self.x = math.clamp(value, self.bounds.x1, self.bounds.x2)
    else
        self.x = value
    end
end

function Camera:setY(value)
    if self.bounds then
        self.y = math.clamp(value, self.bounds.y1, self.bounds.y2)
    else
        self.y = value
    end
end

function Camera:getPos()
    return self.x, self.y
end

function Camera:getBounds()
    return unpack(self.bounds)
end

function Camera:setBounds(x1, y1, x2, y2)
    self.bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end

function Camera:newLayer(speedRatio, layerKey)
    self.layers[layerKey or speedRatio] = {speedRatio = speedRatio, x = self.x, y = self.y}
end

function Camera:getMousePos()
    return self:getWorldPos(love.mouse.getPosition())
end

function Camera:getCameraPos(x, y, layerKey)
    local cx,cy = love.graphics.getWidth()/(2*self.scale), love.graphics.getHeight()/(2*self.scale)
    local c,s = math.cos(self.rotation), math.sin(self.rotation)
    
    if layerKey then
        x,y = x - self.layers[layerKey].x, y - self.layers[layerKey].y
    else
        x,y = x - self.x, y - self.y
    end
    
    x,y = x * c + y * s, x * -s  + y * c
    x, y = x * self.scale + cx, y * self.scale + cy
    return x, y
end

function Camera:getWorldPos(x, y, layerKey)
    local cx,cy = love.graphics.getWidth()/(2*self.scale), love.graphics.getHeight()/(2*self.scale)
    local c,s = math.cos(-self.rotation), math.sin(-self.rotation)

    x,y = (x - cx) / self.scale, (y - cy) / self.scale
    x,y = x * c + y * s, x * -s + y * c

    if layerKey then
        x, y = x + self.layers[layerKey].x, y + self.layers[layerKey].y
    else
        x, y = x+self.x, y+self.y
    end
    return x, y
end
