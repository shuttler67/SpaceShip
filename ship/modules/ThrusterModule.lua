ThrusterModule = Class(ShipModule)

ThrusterModule.eastVec = {x = 1, y = 0}
ThrusterModule.westVec = {x = -1, y = 0}
ThrusterModule.northVec = {x = 0, y = -1}
ThrusterModule.southVec = {x = 0, y = 1}
ThrusterModule.torqueThreshold = 14

function ThrusterModule:init(_rotation)

    self.thrustDir = {}
    self.thrusterOn = {}
    self.thrustImpulse = 16
    self.detachedThrustTimer = 0
    
    local rotation = (_rotation or ShipModule.EAST)
    local x, y, w, h
    
    if rotation == ShipModule.NORTH then
        x, y, w, h = 0, ShipModule.unitHeightHalf * 10/16, ShipModule.unitWidthHalf, ShipModule.unitHeightHalf  * 3/4
        
    elseif rotation == ShipModule.SOUTH then
        x, y, w, h = 0, -ShipModule.unitHeightHalf * 10/16, ShipModule.unitWidthHalf, ShipModule.unitHeightHalf  * 3/4
    
    elseif rotation == ShipModule.EAST then
        x, y, w, h = -ShipModule.unitWidthHalf * 10/16, 0, ShipModule.unitWidthHalf  * 3/4, ShipModule.unitHeightHalf
    
    elseif rotation == ShipModule.WEST then
        x, y, w, h = ShipModule.unitWidthHalf * 10/16, 0, ShipModule.unitWidthHalf  * 3/4, ShipModule.unitHeightHalf
    end
    
    local shape = love.physics.newRectangleShape(x, y, w, h)

    local sprite = Sprite(Images.thruster)
    sprite:createQuadListFromGrid(ShipModule.unitWidth, ShipModule.unitHeight, 3)
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
    return math.ceil(self.thrustDir.x * rx + self.thrustDir.y * ry) == -1
end

