game = {} -- A game state

function game:init()
    self.player = Player()
    self.player:setCameraslack(love.window.getWidth()/5, love.window.getHeight()/5)
    
    self.camera = Camera()
    self.camera:zoom(1)
    
    self.camera:newLayer(0.2)
    
    love.physics.setMeter(32)

    self.world = love.physics.newWorld()
    
    self.entities = {}
    
    self.enemies = {}
    
    self.wall = {}
    self.wall.body = love.physics.newBody(self.world, 0, 0, "static")
    self.wall.shape = love.physics.newChainShape(true, 0, 0, 0, 600, 3500, 600, 3500, 0)
    self.wall.fixture = love.physics.newFixture(self.wall.body, self.wall.shape)
    self.wall.draw = function(self) love.graphics.setColor(Colors.white) 
            love.graphics.line(self.shape:getPoints()) 
        end
    Materials.WOOD:apply(self.wall.fixture)
    
    local playMaterialSound = Material:getCallbackForSoundOnImpact()
    
    local function beginContact(a, b, coll)
       playMaterialSound(a, b, coll)
    end

    local function endContact(a, b, coll)
       
    end

    local function preSolve(a, b, coll)
        
    end

    local function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
        local fixtures = {a, b}
        local normalimpulses = {normalimpulse2, normalimpulse1}
        
        for i = 1, 2 do
            local bodyUserData = fixtures[i]:getBody():getUserData()
            if bodyUserData == "Player" then
                for ship_module, fixture in pairs(self.player.ship.fixtures) do
                    if fixtures[i] == fixture and normalimpulses[i] ~= nil then
                        ship_module:inflictDamage(math.abs(math.floor(normalimpulses[i] / 1800 * 1/fixture:getDensity())), "collision")
                    end
                end
                
            elseif string.match(tostring(bodyUserData), "Enemy") == "Enemy" then
                if self.enemies[bodyUserData] ~= nil then 
                    for ship_module, fixture in pairs(self.enemies[bodyUserData].ship.fixtures) do
                        if fixtures[i] == fixture and normalimpulses[i] ~= nil then
                            ship_module:inflictDamage(math.abs(math.floor(normalimpulses[i] / 1800 * 1/fixture:getDensity())), "collision")
                        end
                    end
                end
            end
        end
    end
    
    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
end

function game:enter(prev, player_modules)
    love.graphics.setBackgroundColor(Colors.black)

    local player_ship = Ship(self.world, 200, 300, player_modules)
    player_ship.body:applyLinearImpulse(2000, 0)
            
    self.player:setShip(player_ship)
end

function game:leave()
    
end

function game:getShipModules()
    return self.player.ship.modules
end
   
function game:update(dt)
    self.world:update(dt)
    
    self.player:update(dt, self.camera)
    
    for _,v in ipairs(self.entities) do
        v:update(dt)
    end
    
end

function game:draw()
    love.graphics.setColor(Colors.white)
    
    self.camera:set(0.2)

    love.graphics.draw(Images.starscape, -50, -45)
    
    self.camera:unset()
    self.camera:set()
    
    love.graphics.setColor(Colors.black)
    
    self.wall:draw()
    
    self.player:draw()
    
    for _, v in ipairs(self.entities) do
        v:draw()
    end
    if showContacts then
        for _, v in ipairs(self.world:getContactList()) do
            local x1, y1, x2, y2 =  v:getPositions()
            love.graphics.setColor(Colors.red)
            if x1 and y1 then
                love.graphics.circle("fill", x1, y1, 5)
            end
            love.graphics.setColor(Colors.green)
            if x2 and y2 then
                love.graphics.circle("fill", x2, y2, 3)
            end
        end
    end
    
    self.camera:unset()    
end

function game.mousepressed(x, y, button)

end

function game.mousereleased(x, y, button)

end

function game.keypressed(key)

end

function game.keyreleased(key)
    
end

function game.focus(f)

end