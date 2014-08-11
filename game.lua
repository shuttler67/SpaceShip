function game_load()
    player = Player()
    player:setCameraslack(love.window.getWidth()/5, love.window.getHeight()/5)
    
    camera = Camera()
    camera:setOffset(love.window.getWidth()/2, love.window.getHeight()/2)
    
    camera:newLayer(0.2)
    
    love.physics.setMeter(32)
    astroid_field = love.physics.newWorld()
    
    bodysprites = {}
    
    modules = ModuleManager()
    modules:addModule(CockpitModule(), 0, 0)
    modules:addModule(HullModule(), 0, -1)
    modules:addModule(HullModule(), 0, 1)
    modules:addModule(HullModule(), 1.5, 0)
    modules:addModule(HullModule(), 2.5, 0)
    modules:addModule(HullModule(), 1,1)
    modules:addModule(HullModule(), 1,-1)
    modules:addModule(HullCornerModule(ShipModule.EAST), 2.5, -1)
    modules:addModule(HullCornerModule(ShipModule.SOUTH), 2.5, 1)
    modules:addModule(ThrusterModule(ShipModule.WEST), -1, -1)
    modules:addModule(ThrusterModule(ShipModule.WEST), -1, 1)
    modules:addModule(ThrusterModule(ShipModule.WEST), 1.5, 0)
    modules:addModule(ThrusterModule(ShipModule.EAST), 3.5, 0)
    modules:addModule(ThrusterModule(ShipModule.EAST), 1, -1)
    modules:addModule(ThrusterModule(ShipModule.EAST), 1, 1)
    modules:addModule(ThrusterModule(ShipModule.SOUTH), 0, 2)
    modules:addModule(ThrusterModule(ShipModule.NORTH), 0, -2)
    ship = Ship(astroid_field, 200, 300, modules)
    ship.body:applyLinearImpulse(1000,-1000)
    
    ship:validate()
    
    wall = {}
    wall.body = love.physics.newBody(astroid_field, 0, 0, "static")
    wall.shape = love.physics.newChainShape(true, 0, 0, 0, 600, 3500, 600, 3500, 0)
    wall.fixture = love.physics.newFixture(wall.body, wall.shape)
    wall.draw = function(self) love.graphics.setColor(255,255,255) 
            love.graphics.line(self.shape:getPoints()) 
        end
    Material.WOOD:apply(wall.fixture)
    
    local playMaterialSound = Material:getCallbackForSoundOnImpact()
    
    local function beginContact(a, b, coll)
       playMaterialSound(a, b, coll)
    end

    local function endContact(a, b, coll)
       
    end

    local function preSolve(a, b, coll)
       
    end

    local function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
       
    end
    
    astroid_field:setCallbacks(beginContact, endContact, preSolve, postSolve)
    
    player:followBody(ship.body)
end

function game_update(dt)
    astroid_field:update(dt)
    
    player:update(dt, camera)
    
    for _,v in ipairs(bodysprites) do
        v:update(dt)
    end
    
end

function game_draw()
    
    camera:set(0.2)
    
    love.graphics.setColor(255,255,255)
    love.graphics.draw(Images.starscape, -50, -45)
    
    camera:unset()
    camera:set()
    
    wall:draw()
    
    for _, v in ipairs(bodysprites) do
        v:draw()
    end
    
    camera:unset()
end
