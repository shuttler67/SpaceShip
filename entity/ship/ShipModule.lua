ShipModule = Class("ShipModule")

ShipModule.unitWidth = 32
ShipModule.unitHeight = 32
ShipModule.unitWidthHalf = 16
ShipModule.unitHeightHalf = 16

ShipModule.NORTH = 270
ShipModule.EAST = 0
ShipModule.SOUTH = 90
ShipModule.WEST = 180

function ShipModule:init(shape, sprite, material, rotation)
    self.rotation = (rotation or ShipModule.NORTH)
    self.attachedToShip = false
    self.isStacked = false
    
    self.moduleX = 0
    self.moduleY = 0
    
    self.max_health = 100
    self.health = 100
    self.lastDamageDealt = ""
    
    self.parent = nil --just to tell you its there ;)
    self.shape = shape
    self.sprite = sprite
    self.sprite:setRotation(math.rad(self.rotation))
    self.sprite:setOffset(ShipModule.unitWidth/2, ShipModule.unitHeight/2)
    self.material = material
    self.timestamp = 0 
end

function ShipModule:moveTo(x,y)
    self.moduleX = x
    self.moduleY = y
end

function ShipModule:getWorldPos()
    assert(self.parent.body, "Cannot find world position, has no parent with body")
    return self.parent.body:getWorldPoint(self:getLocalPos())
end

function ShipModule:getLocalPos()
    return self.moduleX * ShipModule.unitWidth, self.moduleY * ShipModule.unitHeight
end

function ShipModule:getModulePos()
    return self.moduleX, self.moduleY
end

--Returns true if the module can connect in the (rx, ry) direction.
--	*arg rx (-1, 0, 1)
--  *arg ry (-1, 0, 1)
function ShipModule:connectsTo(rx, ry) 
    return true
end

function ShipModule:canStack()
    return false
end

function ShipModule:attached()
    self.attachedToShip = true
end

function ShipModule:detached()
    self.attachedToShip = false
end

--updates ShipModule
--  *arg dt delta time *required
--  *arg toggle_activestate_list 
function ShipModule:update(dt)
    self.sprite:update(dt)
end

function ShipModule:getValidNeighbours()
    return {1, 0, 0, -1, -1, 0, 0, 1}
end

function ShipModule:getHealth()
    return self.health
end

function ShipModule:restoreToFullHealth()
    self.health = self.max_health
end

function ShipModule:inflictDamage(amount, damageType)
    self.health = self.health - amount
    self.lastDamageDealt = damageType
end

