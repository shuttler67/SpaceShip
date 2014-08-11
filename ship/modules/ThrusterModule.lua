ThrusterModule = Class(ShipModule)

ThrusterModule.eastVec = {x = 1, y = 0}
ThrusterModule.westVec = {x = -1, y = 0}
ThrusterModule.northVec = {x = 0, y = -1}
ThrusterModule.southVec = {x = 0, y = 1}
ThrusterModule.torqueThreshold = 14

function ThrusterModule:init(rotation)

    self.thrustDir = {}
    self.thrusterOn = {}
    self.thrustImpulse = 16
    self.detachedThrustTimer = 0
    
    rotation = (rotation or ShipModule.EAST)
    local x, y, w, h
    
    x, y = -self.unitWidthHalf * 10/16, 0
    x, y = vector_rotate(x, y , -math.rad(rotation))
    
    if rotation == ShipModule.NORTH or rotation == ShipModule.SOUTH then
        w, h = self.unitWidthHalf, self.unitHeightHalf  * 3/4

    elseif rotation == ShipModule.EAST or rotation == ShipModule.WEST then
        w, h = self.unitWidthHalf  * 3/4, self.unitHeightHalf
    end
    
    local shape = love.physics.newRectangleShape(x, y, w, h)

    local sprite = Sprite(Images.thruster)
    sprite:createQuadListFromGrid(self.unitWidth, self.unitHeight, 3)
    sprite:addAnimation("quadIndex", "firing", "repeat", 2,1,3, 3, false)

    local material = Material.METAL

    self.super(shape, sprite, material, rotation)
end

function ThrusterModule:attached()
    self.super:attached()

    if self.rotation == ShipModule.NORTH then
        self.thrustDir = self.northVec
    end
    if self.rotation == ShipModule.SOUTH then
        self.thrustDir = self.southVec
    end
    if self.rotation == ShipModule.EAST then
        self.thrustDir = self.eastVec
    end
    if self.rotation == ShipModule.WEST then
        self.thrustDir = self.westVec
    end
    
    if self.isStacked then
        self.sprite.x = self.sprite.x + self.thrustDir.x * ShipModule.unitWidth/6
        self.sprite.y = self.sprite.y + self.thrustDir.y * ShipModule.unitWidth/6
    end
end

function ThrusterModule:detached()
    self.super:detached()
    
    if self.thrusterOn then
        self.detachedThrustTimer = 1500
    end
end

function ThrusterModule:calculateTorque()
    local COMx, COMy = self.parent.body:getLocalCenter()
    local x,y = self:getLocalPos()
    
    local dx, dy = COMx - x, COMy - y
    
    return dx * self.thrustDir.y - dy * self.thrustDir.x
end

function ThrusterModule:update(dt)
    self.super:update(dt)
    if self.attachedToShip then
        
        local torque = self:calculateTorque()
        local core = self.parent.modules:getCore()
        local function truncate(n, max)
            while n >= max do
                n = n - max
            end
            while n < 0 do
                n = n + max
            end
            
            return n
        end
        
        if love.keyboard.isDown("up") and self.rotation == truncate(core.rotation + 180, 360) or 
            love.keyboard.isDown("down") and self.rotation == core.rotation then
            
            self:fire(self.thrustImpulse)
            
        elseif love.keyboard.isDown("a") and self.rotation == truncate(core.rotation + 90, 360) or 
            love.keyboard.isDown("d") and self.rotation == truncate(core.rotation - 90, 360) then
            
            self:fire(self.thrustImpulse)
            
        elseif love.keyboard.isDown("left") and torque <= -self.torqueThreshold or
            love.keyboard.isDown("right") and torque >= self.torqueThreshold then
                
            self:fire(self.thrustImpulse)
        else
            self.thrusterOn = false
        end
    else
        if self.detachedThrustTimer < 0 then
            
            self.detachedThrustTimer = self.detachedThrustTimer - dt
            self:fire(self.thrustImpulse)
        else
            self.thrusterOn = false
        end
    end
    
    if self.thrusterOn then
        self.sprite:toggleAnimation("firing", true)
    else
        self.sprite:toggleAnimation("firing", false)
        self.sprite:setQuadIndex(1)
    end
end

function ThrusterModule:fire(amount)
    local thrustVecX, thrustVecY = self.thrustDir.x * -amount, self.thrustDir.y * -amount
   
    local impulseVecX, impulseVecY = self.parent.body:getWorldVector(thrustVecX, thrustVecY)
    
    self.parent.body:applyLinearImpulse(impulseVecX, impulseVecY, self:getWorldPos())
    self.thrusterOn = true
end

function ThrusterModule:connectsTo(rx, ry)
    if rx == 0 and ry == 0 then return true end
    return math.ceil(self.thrustDir.x * rx + self.thrustDir.y * ry) == -1
end

function ThrusterModule:canStack()
    return true
end

function ThrusterModule:getValidNeighbours()
    local neighbours = self.super:getValidNeighbours()
    
    local directions = {0, 90, 180, 270}
    
    for i, v in ipairs(directions) do
        if v ~= self.rotation then
            neighbours[i*2-1] = nil
            neighbours[i*2] = nil
        end
    end
    return neighbours
end
