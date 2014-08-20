ModuleItemEntity = Class("ModuleItemEntity", ItemEntity)

function ModuleItemEntity:init(module_item, x, y, drawingPriority)
    
    self._module = module_item._module
    self._module:detached()
    self._module.parent = self
    self._module:moveTo((x or 0) / ShipModule.unitWidth, (y or 0) / ShipModule.unitHeight)
    
    self.super:init(module_item, self._module.shape, x, y, drawingPriority)
end

function ModuleItemEntity:moveTo(x, y)
    self._module:moveTo(x / ShipModule.unitWidth, y / ShipModule.unitHeight)
    self.super:moveTo(x, y)
end
