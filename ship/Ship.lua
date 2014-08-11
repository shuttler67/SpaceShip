Ship = Class(BodySprite)

function Ship:init(world, x, y, modules)
    self.super(world, x, y)
    self.modules = modules
    self.modules:each(self.addModule, self)
    self.body:resetMassData()
end

function Ship:addModule(ship_module)
    ship_module.parent = self
    local x,y = ship_module:getLocalPos() 
    
    local drawingPriority = 1
    
    if ship_module.isStacked then
        drawingPriority = 2
    end
    
    self:addShapeXY(ship_module.shape, x, y, ship_module)
    self:addSpriteXY(ship_module.sprite, x, y, drawingPriority)
    
    ship_module.material:apply(self.fixtures[ship_module])
    
    ship_module:attached()
end

function Ship:update(dt)
    self.super:update(dt)
    self.modules:each(function (m) m:update(dt) end)
end

function Ship:draw()
    self.super:draw()
    
    if showModulePositions then
        love.graphics.setColor(0,0,0)
        self.modules:each(function(m) 
            local x,y = m:getWorldPos()
            love.graphics.circle("fill", x, y, 5) end)
    end
end

function Ship:removeModule(ship_module, detach_disconnected)
    self.modules:remove(ship_module)
    self:removeShape(ship_module)
    self:removeSprite(ship_module.sprite)
    
    if not (detach_disconnected == false) then
        local disconnected = self:findDisconnectedModules()
        
        for k,v in pairs(disconnected) do
            self:detachModule(v)
        end
    end
end

function Ship:validate()
    local disconnected = self:findDisconnectedModules()
        
    for k,v in pairs(disconnected) do
        self:detachModule(v)
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
        local _module = self.modules:get(currentModule.moduleX + x, currentModule.moduleY + y, (x == 0 and y == 0))
        
        if _module ~= nil and _module.timestamp ~= timestamp and _module:connectsTo(-x, -y) and currentModule:connectsTo(x, y) then
            table.insert(visitList, _module)
        end
    end
    
    while #visitList ~= 0 do
        currentModule = visitList[#visitList]
        table.remove(visitList)
        currentModule.timestamp = timestamp
        
        local validNeighbours = currentModule:getValidNeighbours()
        
        local x, y
        for i, v in ipairs(validNeighbours) do
            if i % 2 == 0 then
                y = validNeighbours[i]
                addNeighbour(x, y)
            else
                x = validNeighbours[i]
            end
        end
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

