HullCornerModule = Class(ShipModule)

function HullCornerModule:init(rotation)
    
    local points = {-ShipModule.unitWidthHalf, -ShipModule.unitHeightHalf,
        -ShipModule.unitWidthHalf, ShipModule.unitHeightHalf, 
        ShipModule.unitWidthHalf, ShipModule.unitHeightHalf,
        ShipModule.unitWidthHalf, -ShipModule.unitHeightHalf}
    
    if rotation == ShipModule.NORTH then
        points[1] = nil
        points[2] = nil
        
    elseif rotation == ShipModule.SOUTH then
        points[5] = nil
        points[6] = nil
    
    elseif rotation == ShipModule.EAST then
        points[3] = nil
        points[4] = nil
    
    elseif rotation == ShipModule.WEST then
        points[7] = nil
        points[8] = nil
        
    end
    
    local shape = love.physics.newPolygonShape(unpack(points))
    
    local sprite = Sprite(Images.hull_corner)
    
    local material = Material.METAL
    
    self.super(shape, sprite, material)
end

function HullCornerModule:connectsTo(rx, ry)
    if self.rotation == ShipModule.NORTH then
        return (rx == 1 and ry == 0) or (rx == 0 and ry == 1)
        
    elseif self.rotation == ShipModule.SOUTH then
        return (rx == -1 and ry == 0) or (rx == 0 and ry == 1)
    
    elseif self.rotation == ShipModule.EAST then
        return (rx == -1 and ry == 0) or (rx == 0 and ry == -1)
    
    elseif self.rotation == ShipModule.WEST then
        return (rx == 1 and ry == 0) or (rx == 0 and ry == -1)
    end
end
