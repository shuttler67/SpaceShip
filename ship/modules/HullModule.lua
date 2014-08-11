HullModule = Class(ShipModule)

function HullModule:init()
    
    local shape = love.physics.newRectangleShape(self.unitWidth, self.unitHeight)
    
    local sprite = Sprite(Images.hull)
    
    local material = Material.METAL
    
    self.super(shape, sprite, material)
end

function HullModule:getValidNeighbours()
    local neighbours = self.super:getValidNeighbours()
    
    table.insert(neighbours, 0)
    table.insert(neighbours, 0)
    
    return neighbours
end
