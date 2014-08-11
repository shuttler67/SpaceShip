CockpitModule = Class(ShipModule)

function CockpitModule:init(rotation)
    rotation = rotation or ShipModule.EAST
    
    local x, y = vector_rotate(ShipModule.unitWidth/4, 0 , -rotation)
    
    if rotation == ShipModule.NORTH or rotation == ShipModule.SOUTH then
        w, h = self.unitWidth, self.unitHeight  * 1.5

    elseif rotation == ShipModule.EAST or rotation == ShipModule.WEST then
        w, h = self.unitWidth  * 1.5, self.unitHeight
    end
    
    local shape = love.physics.newRectangleShape(x, y, w, h)
    
    local sprite = Sprite(Images.cockpit)
    
    local material = Material.METAL
    
    self.super(shape, sprite, material, rotation)
end

function CockpitModule:getValidNeighbours()
    local neighbours = self.super:getValidNeighbours()
    
    local directions = {0, 90, 180, 270}
    
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

