Ship = Class()

function Ship:init(modules, x, y)
    self.body = love.physics.newBody(astroid_field, x, y, "dynamic")
    self.fixtures = {}
    
    self.modules = modules
    self.modules:each(self:addModule)
    
    self.x self.y = self.body:getWorldCenter()
end

function Ship:addModule(ship_module)
    ship_module.parent = self
    table.insert(self.fixtures, love.physics.newFixture(self.body, ship_module.shape))
end

function Ship:added()
    self.modules:each(function (m) m.attached() end)
end

function Ship:update()
    self.modules:each(function (m) m.update() end)
end

function Ship:removed()
    self.modules:each(function (m) m.detached() end)
end

function Ship:draw()
    self.modules:each(function (m) m.draw() end)
end

function Ship:removeModule(ship_module, detach_disconnected)
    self.modules.remove(ship_module)
    
end

function Ship:findDisconnectedModules()
    
end

function Ship:detachModule(ship_module)
    
end

