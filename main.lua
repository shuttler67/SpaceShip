-- [Run](macro:inline(ProjectRun())) [Debug](ProjectDebug())

function love.load(arg)
    if arg[#arg] == "-debug" then require("mobdebug").start() end

    for _,mode in pairs(love.window.getFullscreenModes(1)) do for k,v in pairs(mode) do print(k, v) end end
    print(love.system.getClipboardText())
    love.window.setMode(1280 , 960,{})
    
    --local Location = ""
    
    local resourceLocation = "resources/"
    local utilityLocation = "utility/"
    local entityLocation = "entity/"
    local itemLocation = "item/"
    local inventoryLocation = "inventory/"
    
    --local blockLocation = entityLocation .. "block/"
    local shipLocation = entityLocation .. "ship/"
    
    local moduleLocation = shipLocation .. "modules/"
    
    -- REQUIRE ALL THEM FILES
    
    require "Class"
    require "game"
    require "edit"
    
    require( utilityLocation .. "Vector")
    require( utilityLocation .. "Camera")
    require( utilityLocation .. "Sprite")
    require( utilityLocation .. "cheats")
    Gamestate = require( utilityLocation .. "gamestate")
    
    require( entityLocation .."Player")
    require( entityLocation .."Material")
    require( entityLocation .. "BodySprite")
    
    require( itemLocation .. "Item" )
    require( itemLocation .. "ItemStack" )
    require( itemLocation .. "ItemEntity" )
    require( itemLocation .. "ModuleItem" )
    require( itemLocation .. "ModuleItemEntity" )
    
    require( inventoryLocation .. "Slot" ) 
    
    require( shipLocation .."ShipModule")
    require( shipLocation .."ModuleManager")
    require( shipLocation .."Ship")
    require( shipLocation .."ShipDebris")
    
    require( moduleLocation .."CockpitModule")
    require( moduleLocation .."ThrusterModule")
    require( moduleLocation .."HullModule")
    require( moduleLocation .."HullCornerModule")

    require( resourceLocation .."Images")
    require( resourceLocation .."Colors")
    require( resourceLocation .."Materials")
    
    Gamestate.registerEvents()
    Gamestate.push(edit)
end

function love.keyreleased(key)
    if key == "e" then
        if Gamestate.current() == game then 
            Gamestate.switch(edit, game:getShipModules())
            
        elseif Gamestate.current() == edit then
            Gamestate.switch(game, edit:getShipModules())
        end
    end
end

function math.clamp(x, min, max)
    return x < min and min or (x > max and max or x)
end

function math.round(num, idp) -- Not by me [http://lua-users.org/wiki/SimpleRound](http://lua-users.org/wiki/SimpleRound)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

function math.truncate(n, max)
    while n >= max do
        n = n - max
    end
    while n < 0 do
        n = n + max
    end
    
    return n
end

