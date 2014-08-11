Ship = Class(BodySprite)

function Ship:init(world, x, y, modules)
    self.super(world, x, y)
    self.modules = modules
    self.modules:each(self.addModule, self)
    self.body:resetMassData()
    self.modules:each(function (m) m:attached() end)
end

function Ship:addModule(ship_module)
    ship_module.parent = self
    
    local x,y = ship_module:getLocalPos() 
    self:addShapeXY(ship_module.shape, x, y, ship_module)
    self:addSpriteXY(ship_module.sprite, x, y, ship_module)
    
    ship_module.material:apply(self.fixtures[ship_module])
end

function Ship:update(dt)
    self.super:update(dt)
    self.modules:each(function (m) m:update(dt) end)
end

function Ship:draw()
    self.super:draw()
    
--    love.graphics.setColor(0,0,0)
--    self.modules:each(function(m) 
--        local x,y = m:getWorldPos()
--        love.graphics.circle("fill", x, y, 5) end)
end

function Ship:removeModule(ship_module, detach_disconnected)
    self.modules:remove(ship_module)
    self.fixtures[ship_module]:destroy()
    self.fixtures[ship_module] = nil
    self.sprites[ship_module] = nil
    
    if not (detach_disconnected == false) then
        local disconnected = self:findDisconnectedModules()
        print(unpack(disconnected))
        for k,v in pairs(disconnected) do
            self:detachModule(v)
        end
    end
end

function Ship:findDisconnectedModules()
    local core = self.modules:getCore()
    
    if (core == nil) or not core.attachedToShip then
        return self.modules.hashmap
    end
    
    local visitList = {core}
    local timestamp = love.timer.getTime()
    local currentModule
    
    local function addNeighbour(x, y)
        local _module = self.modules:get(currentModule.moduleX + x, currentModule.moduleY + y)
        if _module ~= nil and _module.timestamp ~= timestamp and _module:connectsTo(-x, -y) and currentModule:connectsTo(x, y) then
            table.insert(visitList, _module)
        end
    end
    
    while #visitList ~= 0 do
        currentModule = visitList[#visitList]
        table.remove(visitList)
        currentModule.timestamp = timestamp
        addNeighbour(-1, 0)
        addNeighbour(1, 0)
        addNeighbour(0, -1)
        addNeighbour(0, 1)
    end
    
    local disconnected = {}
    for _module in pairs(modules.list) do
        if _module.timestamp ~= timestamp then
            table.insert(disconnected, _module)
        end
    end
    
    return disconnected
end

function Ship:detachModule(ship_module)
    self:removeModule(ship_module, false)
    ship_module:detached()
    
    local x,y = ship_module:getWorldPos()
    local debris = ShipDebris(self.world, x, y, ship_module)
    
    debris.body:setAngle(self.body:getAngle())
    debris.body:setLinearVelocity(self.body:getLinearVelocity())
    debris.body:setAngularVelocity(self.body:getAngularVelocity())
end

