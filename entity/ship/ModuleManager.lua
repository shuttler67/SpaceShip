ModuleManager = Class("ModuleManager")

function ModuleManager:init()
    self.list = {}
    self.hashmap = {}
    self.coreX, self.coreY = 0,0
end

function ModuleManager:addModule(ship_module, x, y)
    
    if self:occupied(x, y) then
        if ship_module:canStack() and not self:occupied(x, y, true) then
            self:set(x, y, ship_module, true)
            ship_module.isStacked = true
        else
            return false
        end
    else
        self:set(x, y, ship_module)
    end
    
    ship_module:moveTo(x,y)
    
    self.list[ship_module] = true
    
    if CockpitModule:made(ship_module) then
        self.coreX, self.coreY = x,y
    end
    return ship_module
end

--module coords
function ModuleManager:get(x, y, isStacked)
    if isStacked then
        return self.hashmap[x .. "." .. y]
    end
    return self.hashmap[x .. "," .. y]
end

function ModuleManager:set(x, y, v, shouldStack)
    if shouldStack then
        self.hashmap[x .. "." .. y] = v
    else
        self.hashmap[x .. "," .. y] = v
    end
end

function ModuleManager:occupied(x, y, isStacked)
    if isStacked then
        return not (self.hashmap[x .. "." .. y] == nil)
    end
    return not (self.hashmap[x .. "," .. y] == nil)
end

function ModuleManager:getCore()
    return self:get(self.coreX, self.coreY)
end

function ModuleManager:remove(ship_module)
    self:set(ship_module.moduleX, ship_module.moduleY, nil)
    self:set(ship_module.moduleX, ship_module.moduleY, nil, true)
    self.list[ship_module] = nil
end

function ModuleManager:each(f, instance)
    for k,v in pairs(self.list) do 
        if instance then
            f(instance, k)
        else
            f(k)
        end
    end
end


