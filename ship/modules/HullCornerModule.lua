HullCornerModule = Class(ShipModule)

function HullCornerModule:init(rotation)
    
    local points = {-self.unitWidthHalf, -self.unitHeightHalf,
        -self.unitWidthHalf, self.unitHeightHalf, 
        self.unitWidthHalf, self.unitHeightHalf,
        self.unitWidthHalf, -self.unitHeightHalf}
    
    if rotation == ShipModule.NORTH then
        table.remove(points, 2)
        table.remove(points, 1)
        
    elseif rotation == ShipModule.WEST then
        table.remove(points, 4)
        table.remove(points, 3)
    
    elseif rotation == ShipModule.SOUTH then
        table.remove(points, 6)
        table.remove(points, 5)
    
    elseif rotation == ShipModule.EAST then
        table.remove(points, 8)
        table.remove(points, 7)
    end
    
    local shape = love.physics.newPolygonShape(unpack(points))
    
    local sprite = Sprite(Images.hull_corner)
    
    local material = Material.METAL
    
    self.super(shape, sprite, material, rotation)
end

function HullCornerModule:connectsTo(rx, ry)
    if self.rotation == ShipModule.EAST then
        return (rx == 1 and ry == 0) or (rx == 0 and ry == 1)
        
    elseif self.rotation == ShipModule.WEST then
        return (rx == -1 and ry == 0) or (rx == 0 and ry == 1)
    
    elseif self.rotation == ShipModule.NORTH then
        return (rx == -1 and ry == 0) or (rx == 0 and ry == -1)
    
    elseif self.rotation == ShipModule.SOUTH then
        return (rx == 1 and ry == 0) or (rx == 0 and ry == -1)
    end
end
