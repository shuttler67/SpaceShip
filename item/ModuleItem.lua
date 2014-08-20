ModuleItem = Class("ModuleItem", Item)

function ModuleItem:init(_module)
    self._module = _module
    
    self.super:init(_module.sprite)
end

function ModuleItem:getItemEntity()
    return ModuleItemEntity(self)
end

    
    