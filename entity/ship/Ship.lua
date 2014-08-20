Ship = Class("Ship", BodySprite)

function Ship:init(world, x, y, modules)
    self.super:init(world, x, y)
    self.modules = modules
    self.modules:each(self.addModule, self)
    self.body:resetMassData()
    self:resetMovementData()
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
    self:resetMovementData()
end

function Ship:draw()
    self.super:draw()
    
    if showModulePositions then
        love.graphics.setColor(Colors.black)
        self.modules:each(function(m) 
            local x,y = m:getWorldPos()
            love.graphics.circle("fill", x, y, 5) end)
    end
end

function Ship:removeModule(ship_module, debris_list)
    self.modules:remove(ship_module)
    self:removeShape(ship_module)
    self:removeSprite(ship_module.sprite)
    
    if debris_list then
        local disconnected = self:findDisconnectedModules()
        
        for k,v in pairs(disconnected) do
            table.insert(debris_list, self:detachModule(v))
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
    for _module in pairs(self.modules.list) do
        if _module.timestamp ~= timestamp then
            table.insert(disconnected, _module)
        end
    end
    
    return disconnected
end

function Ship:detachModule(ship_module)
    self:removeModule(ship_module)
    ship_module:detached()
    
    local x,y = ship_module:getWorldPos()
    local debris = ShipDebris(self.world, x, y, ship_module)
    
    debris.body:setAngle(self.body:getAngle())
    debris.body:setLinearVelocity(self.body:getLinearVelocity())
    debris.body:setAngularVelocity(self.body:getAngularVelocity())
    
    return debris
end

function Ship:findDamagedModules()
    local damagedModules = {}
    for _module in pairs(self.modules.list) do
        if _module.health <= 0 then
            table.insert(damagedModules, _module)
        end
    end
    return damagedModules
end

        
function Ship:resetMovementData()
    self.isMovingDown = false
    self.isMovingUp = false
    self.isMovingLeft = false
    self.isMovingRight = false
    self.isTurningLeft = false
    self.isTurningRight = false
end

function Ship:moveDown()
    self.isMovingDown = true
end

function Ship:moveUp()
    self.isMovingUp = true
end

function Ship:moveLeft()
    self.isMovingLeft = true
end

function Ship:moveRight()
    self.isMovingRight = true
end

function Ship:turnLeft()
    self.isTurningLeft = true
end

function Ship:turnRight()
    self.isTurningRight = true
end
