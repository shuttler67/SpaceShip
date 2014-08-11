function vector_rotate(x, y, r)
    return x * math.cos(r) + y * math.sin(r), x * -math.sin(r) + y * math.cos(r)
end

Camera = Class()
Camera._x = 0
Camera._y = 0
Camera.scaleX = 1
Camera.scaleY = 1
Camera.rotation = 0

Camera.offsetX = 0
Camera.offsetY = 0
Camera.layers = {}

function Camera:set(layerKey) 
    
    love.graphics.push()
    
    love.graphics.translate(self.offsetX, self.offsetY)
    love.graphics.rotate(-self.rotation)
    love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
    love.graphics.translate(-self.offsetX, -self.offsetY)
    
    if layerKey then
        love.graphics.translate(-self.layers[layerKey].x, -self.layers[layerKey].y)
    else
        love.graphics.translate(-self._x, -self._y)
    end
end

function Camera:unset()
    love.graphics.pop()
end

function Camera:move(dx, dy)
    self._x = self._x + (dx or 0)
    self._y = self._y + (dy or 0)
    
    self:setPosition(self._x, self._y)
    
    for _, v in pairs(self.layers) do
        v.x = v.x + (dx or 0) * v.speedRatio
        v.y = v.y + (dy or 0) * v.speedRatio
    end
end

function Camera:rotate(dr)
    self.rotation = self.rotation + dr
end

function Camera:scale(sx, sy)
    sx = sx or 1
    self.scaleX = self.scaleX * sx
    self.scaleY = self.scaleY * (sy or sx)
end

function Camera:setX(value)
    if self._bounds then
        self._x = math.clamp(value, self._bounds.x1, self._bounds.x2)
    else
        self._x = value
    end
end

function Camera:setY(value)
    if self._bounds then
        self._y = math.clamp(value, self._bounds.y1, self._bounds.y2)
    else
        self._y = value
    end
end

function Camera:setPosition(x, y)
    if x then self:setX(x) end
    if y then self:setY(y) end
end

function Camera:setScale(sx, sy)
    self.scaleX = sx or self.scaleX
    self.scaleY = sy or self.scaleY
end

function Camera:setOffset(x, y)
    self.offsetX = x or self.offsetX
    self.offsetY = y or self.offsetY 
end

function Camera:getBounds()
    return unpack(self._bounds)
end

function Camera:setBounds(x1, y1, x2, y2)
    self._bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end

function Camera:newLayer(speedRatio, layerKey)
    self.layers[layerKey or speedRatio] = {speedRatio = speedRatio, x = self._x, y = self._y}
end


function Camera:getMousePosition(x, y, layerKey)
    x, y = x or love.mouse.getX(), y or love.mouse.getY()
    
    if layerKey then
        x, y = x + self.layers[layerKey].x, y + self.layers[layerKey].y 
    else
        x, y = x + self._x, y + self._y 
    end
    
    x, y = x + self.offsetX, y + self.offsetY 
    x, y = x * self.scaleX, y * self.scaleY
    x, y = vector_rotate(x, y, self.rotation)
    x, y = x - self.offsetX, y - self.offsetY 
    return x, y
end

function Camera:getTranslatedPosition(x, y, layerKey)
    x, y = x - self.offsetX, y - self.offsetY 
    x, y = vector_rotate(x, y, -self.rotation)
    x, y = x * 1/self.scaleX, y * 1/self.scaleY
    x, y = x + self.offsetX, y + self.offsetY
    
    if layerKey then
        x, y = x - self.layers[layerKey].x, y - self.layers[layerKey].y 
    else
        x, y = x - self._x, y - self._y 
    end
    
    return x, y
end