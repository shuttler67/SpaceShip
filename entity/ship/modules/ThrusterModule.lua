ThrusterModule = Class("ThrusterModule", ShipModule)

ThrusterModule.eastVec = Vector(1, 0)
ThrusterModule.westVec = Vector(-1, 0)
ThrusterModule.northVec = Vector(0, -1)
ThrusterModule.southVec = Vector(0, 1)
ThrusterModule.torqueThreshold = 14

function ThrusterModule:init(rotation)

    self.thrustDir = {}
    self.thrusterOn = {}
    self.thrustImpulse = 16
    self.detachedThrustTimer = 0
    
    rotation = (rotation or ShipModule.EAST)
    local w, h
    local pos = Vector(-ShipModule.unitWidthHalf * 10/16, 0)
    pos:rotate( -math.rad(rotation))
    
    if rotation == ShipModule.NORTH or rotation == ShipModule.SOUTH then
        w, h = ShipModule.unitWidthHalf, ShipModule.unitHeightHalf  * 3/4

    elseif rotation == ShipModule.EAST or rotation == ShipModule.WEST then
        w, h = ShipModule.unitWidthHalf  * 3/4, ShipModule.unitHeightHalf
    end
    
    local shape = love.physics.newRectangleShape(pos.x, pos.y, w, h)

    local sprite = Sprite(Images.thruster)
    sprite:createQuadListFromGrid(ShipModule.unitWidth, ShipModule.unitHeight, 3)
    sprite:addAnimation("quadIndex", "firing", "repeat", 2,1,3, 3, false)

    local material = Materials.METAL

    self.super:init(shape, sprite, material, rotation)
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
    assert(self.parent,"Cannot calculateTorque: No parent")
    local COM = Vector(self.parent.body:getLocalCenter())
    local pos = Vector(self:getLocalPos())
    
    local delta = COM - pos
    
    return delta:crossProduct(self.thrustDir)
end

function ThrusterModule:update(dt)
    self.super:update(dt)
    if self.attachedToShip then
        
        local torque = self:calculateTorque()
        local core = self.parent.modules:getCore()
        
        if self.parent.isMovingUp and self.rotation == math.truncate(core.rotation + 180, 360) or 
            self.parent.isMovingDown and self.rotation == core.rotation then
            
            self:fire(self.thrustImpulse)
            
        elseif self.parent.isMovingLeft and self.rotation == math.truncate(core.rotation + 90, 360) or 
            self.parent.isMovingRight and self.rotation == math.truncate(core.rotation - 90, 360) then
            
            self:fire(self.thrustImpulse)
            
        elseif self.parent.isTurningLeft and torque <= -self.torqueThreshold or
            self.parent.isTurningRight and torque >= self.torqueThreshold then
                
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
    local thrustVec = self.thrustDir * -amount
   
    local impulseVec = Vector(self.parent.body:getWorldVector(thrustVec.x, thrustVec.y))
    
    self.parent.body:applyLinearImpulse(impulseVec.x, impulseVec.y, self:getWorldPos())
    self.thrusterOn = true
end

function ThrusterModule:connectsTo(rx, ry)
    if rx == 0 and ry == 0 then return true end
    return math.ceil(self.thrustDir:dotProduct(Vector(rx, ry))) == -1
end

function ThrusterModule:canStack()
    return true
end

function ThrusterModule:getValidNeighbours()
    return {}
end
