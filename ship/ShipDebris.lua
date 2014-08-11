ShipDebris = Class(BodySprite)

function ShipDebris:init(world, x, y, _module)
    self.super(world, x, y)
    self._module = _module
    self._module.parent = self
    self._module.moduleX, self._module.moduleX = 0, 0
    self._module.sprite.x, self._module.sprite.y = 0, 0
    
    self:addShape(self._module.shape)
    self:addSprite(self._module.sprite)
end

function ShipDebris:update(dt)
    self.super:update(dt)
    
    if self.module ~= nil then
        self.module:update(dt)
    end
end

    