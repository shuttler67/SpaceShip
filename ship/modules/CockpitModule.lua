CockpitModule = Class(ShipModule)

function CockpitModule:init(rotation)    
    local shape = love.physics.newRectangleShape(ShipModule.unitWidth, ShipModule.unitHeight)
    
    local sprite = Sprite(Images.cockpit)
    
    local material = Material.METAL
    
    self.super(shape, sprite, material, rotation)
end
