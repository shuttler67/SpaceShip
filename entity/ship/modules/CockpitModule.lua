CockpitModule = Class("CockpitModule", ShipModule)

function CockpitModule:init(rotation)
    rotation = rotation or ShipModule.NORTH
    
    local w, h
    local pos = Vector(ShipModule.unitWidth/4, 0)
    pos:rotate( -math.rad(rotation))
    
    if rotation == ShipModule.NORTH or rotation == ShipModule.SOUTH then
        w, h = self.unitWidth, self.unitHeight  * 1.5

    elseif rotation == ShipModule.EAST or rotation == ShipModule.WEST then
        w, h = self.unitWidth  * 1.5, self.unitHeight
    end
    
    local shape = love.physics.newRectangleShape(pos.x, pos.y, w, h)
    
    local sprite = Sprite(Images.cockpit)
    
    local material = Materials.METAL
    
    self.super:init(shape, sprite, material, rotation)
end

function CockpitModule:getValidNeighbours()
    local neighbours = self.super:getValidNeighbours()
    
    local directions = {0, 270, 180, 90}
    
    local j = 0
    for i, v in ipairs(neighbours) do
        if v ~= 0 then
            j = j + 1
            if directions[j] == self.rotation then
                neighbours[i] = v * 1.5
                break
            end
        end
    end
    return neighbours
end

