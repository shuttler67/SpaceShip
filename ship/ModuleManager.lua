ModuleManager = Class()

function ModuleManager:init()
    self.list = {}
    self.hashmap = {}
    self.coreX, self.coreY = 0,0
end

function ModuleManager:addModule(ship_module, x, y)
    ship_module:moveTo(x,y)
    
    self:set(x, y, ship_module)
    self.list[ship_module] = true
    
    if ship_module:is_a(CockpitModule) then
        self.coreX, self.coreY = x,y
    end
    return ship_module
end

--module coords
function ModuleManager:get(x, y)
    return self.hashmap[x .. "," .. y]
end

function ModuleManager:set(x, y, v)
    self.hashmap[x .. "," .. y] = v
end

function ModuleManager:occupied(x, y)
    return not self.hashmap[x .. "," .. y] == nil
end

function ModuleManager:getCore()
    return self:get(self.coreX, self.coreY)
end

function ModuleManager:remove(ship_module)
    self:set(ship_module.moduleX, ship_module.moduleY, nil)
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


