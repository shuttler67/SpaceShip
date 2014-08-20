HullModule = Class("HullModule", ShipModule)

function HullModule:init()
    
    local shape = love.physics.newRectangleShape(ShipModule.unitWidth, ShipModule.unitHeight)
    
    local sprite = Sprite(Images.hull)
    
    local material = Materials.METAL
    
    self.super:init(shape, sprite, material)
end

function HullModule:getValidNeighbours()
    local neighbours = self.super:getValidNeighbours()
    
    table.insert(neighbours, 0)
    table.insert(neighbours, 0)
    
    return neighbours
end
