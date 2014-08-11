HullModule = Class(ShipModule)

function HullModule:init()
    
    local shape = love.physics.newRectangleShape(ShipModule.unitWidth, ShipModule.unitHeight)
    
    local sprite = Sprite(Images.hull)
    
    local material = Material.METAL
    
    self.super(shape, sprite, material)
end
