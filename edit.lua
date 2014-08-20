edit = {} -- A Gamestate

function edit:init()
    love.physics.setMeter(32)
    love.mouse.setVisible(false)

    self.world = love.physics.newWorld()
    self.camera = Camera()

    self.player = Player()
    
    ItemEntity.setWorld(self.world)
    
    self.itemEntities = {}
    self.shipEntities = {}
    self.slots = { Slot(-290, -290, ItemStack(ModuleItem(HullModule()), -290, -290, 65)), Slot(-290, -290 - Item.size*2)}
    self.player_slot = Slot()
    self.player_slot.drawSlot = false
    
    self.buildingBounds = {-100,-100,100,100}
    
    local function beginContact(a, b, coll)
        --print("collision")
    end

    local function endContact(a, b, coll)
       
    end

    local function preSolve(a, b, coll)
        
    end

    local function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
        
    end
    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
end

function edit:enter(prev, player_modules)
    love.graphics.setBackgroundColor(Colors.white)
    player_modules = ModuleManager()
    player_modules:addModule(CockpitModule(), 0, 0)
    player_modules:addModule(HullModule(), -1, 0)
    player_modules:addModule(HullModule(), 1, 0)
    player_modules:addModule(ThrusterModule(ShipModule.SOUTH), -1, 1)
    player_modules:addModule(ThrusterModule(ShipModule.SOUTH), 1, 1)
        
    for _, v in ipairs(self.shipEntities) do
        v.body:destroy()
    end
    
    self.shipEntities = {}
    
    for v in pairs(player_modules.list) do
        local drawingPriority = 1
        if v.isStacked then
            drawingPriority = 2
        end
        local x, y = v:getLocalPos()
        table.insert(self.shipEntities, ModuleItemEntity(ModuleItem(v), x, y, drawingPriority))
    end
    table.sort(self.shipEntities, function(a, b) return a.item.sprite.drawingPriority < b.item.sprite.drawingPriority end)
end

function edit:leave()
    
end

function edit:update(dt)
    self.world:update(dt)

    local notInBoundary = true
    local mx, my = self.camera:getMousePos()
    if self.player_slot:getItemStack() then
        if mx > self.buildingBounds[1] and mx < self.buildingBounds[3] and
            my > self.buildingBounds[2] and my < self.buildingBounds[4] and
            ModuleItem:made( self.player_slot:getItemStack():getItem() ) then
                 
            local x, y = math.round(love.mouse.getX()/ ShipModule.unitWidthHalf) * ShipModule.unitWidthHalf, math.round(love.mouse.getY()/ ShipModule.unitWidthHalf) * ShipModule.unitWidthHalf
            
            self.player:update(dt, self.camera, x, y)
            notInBoundary = false
        end
    end
    if notInBoundary then
        self.player:update(dt, self.camera)
    end
    
    for _, v in ipairs(self.itemEntities) do
        v:update(dt)
    end
    for _, v in ipairs(self.shipEntities) do
        v:update(dt)
    end
    for _, v in ipairs(self.slots) do
        v:update(self.camera:getWorldPos(self.player.mx, self.player.my))
    end
    self.player_slot:update(self.camera:getWorldPos(self.player.mx, self.player.my))
    self.player_slot:setPos(self.camera:getWorldPos(self.player.mx, self.player.my))
end

function edit:draw(dt)
    self.camera:set()
    
    love.graphics.setColor(Colors.black)
    love.graphics.rectangle("line", self.buildingBounds[1], self.buildingBounds[2], self.buildingBounds[3] - self.buildingBounds[1], self.buildingBounds[4] - self.buildingBounds[2])
    
    for _, v in ipairs(self.itemEntities) do
        v:draw()
    end
    for _, v in ipairs(self.shipEntities) do
        v:draw()
    end
    love.graphics.setColor(Colors.black)
    love.graphics.print(#self.itemEntities, -250, -250)
    if self.player_slot:getItemStack() then
        love.graphics.print(self.player_slot:getItemStack():getSize(), -250, -230)
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
    for _, v in ipairs(self.slots) do
        v:draw()
    end
    self.player_slot:draw()
    self.camera:unset()
    self.player:draw()
end

function edit:getShipModules()
    local player_modules = ModuleManager()
    for _,v in ipairs(self.shipEntities) do
        player_modules:addModule(v._module, v._module:getModulePos())
    end
    
    return player_modules
end

function edit:mousepressed(x, y, button)
    local mx, my = self.camera:getWorldPos(self.player.mx, self.player.my)
    
    local clickedOn = false
    for i, v in ipairs(self.slots) do
        if v:mousepressed(mx, my, button) then
            clickedOn = true
            if button == "l" then
                self.player_slot:exchange(v)
            elseif button == "r" then
                if not v:split(self.player_slot) then
                    if not self.player_slot:transfer(v) then
                        self.player_slot:exchange(v)
                    end
                end
            end    
        end
    end
    local playerItemEntity
    if self.player_slot:getItemStack() then
        playerItemEntity = self.player_slot:getItemStack():getItemEntity()
        if ModuleItemEntity:made(playerItemEntity) and self.player_slot:getItemStack():getItem() then
            if button == "wd" then
                self.player_slot:getItemStack():getItem()._module:rotate(90)
            elseif button == "wu" then
                self.player_slot:getItemStack():getItem()._module:rotate(-90)
            end
        end
    else
        playerItemEntity = nil
    end
    if not clickedOn then
        for _,v in pairs({self.itemEntities, self.shipEntities}) do
            for i = #v,1,-1 do
                if v[i]:mousepressed(mx, my, button) then
                    clickedOn = true
                    if playerItemEntity == v[i] then
                        self.player_slot:getItemStack():addToSize(1)
                        v[i].body:destroy()
                        table.remove(v, i)
                    elseif playerItemEntity == nil then
                        self.player_slot:setItemStack(ItemStack(v[i]:getItem()))
                        playerItemEntity = self.player_slot:getItemStack():getItemEntity()
                        v[i].body:destroy()
                        table.remove(v, i)
                    end
                end
            end
        end
    end
    if not clickedOn then
        if playerItemEntity then
            if button == "r" then
                table.insert(self.itemEntities, playerItemEntity)
                self.player_slot:getItemStack():addToSize(-1)
                return
            end
        end
    end
    if playerItemEntity then
        playerItemEntity.body:destroy()
    end
    collectgarbage()
end

function edit:mousereleased(x, y, button)

end

function edit:keypressed(key)

end

function edit:keyreleased(key)
    
end

function edit:focus(f)

end    
