-- [Run](macro:inline(ProjectRun())) [Debug](ProjectDebug())

function love.load(arg)
    if arg[#arg] == "-debug" then require("mobdebug").start() end

    love.window.setMode(600,600,{resizable = true})
    love.graphics.setBackgroundColor(0,0,0)
    
    --local Location = ""
    
    local resourceLocation = "resources/"
    local shipLocation = "ship/"
    local moduleLocation = "ship/modules/"
    
    -- REQUIRE ALL THEM FILES
    
    require "Class"
    
    require( resourceLocation .."Images")
    
    require "Camera"
    require "Sprite"
    require "Material"
    require "Player"
    
    require "game"
    
    require( shipLocation .. "BodySprite")
    require( shipLocation .."ShipModule")
    require( shipLocation .."ModuleManager")
    require( shipLocation .."Ship")
    require( shipLocation .."ShipDebris")
    require( moduleLocation .."CockpitModule")
    require( moduleLocation .."ThrusterModule")
    require( moduleLocation .."HullModule")

    Material.STONE = Material(2.6, 0.75, 0.3)
    Material.METAL = Material(3.1, 0.3, 0.4)
    Material.GLASS = Material(1.8, 0.2, 0.7)
    Material.WOOD = Material(0.9, 0.6, 0.5)
    Material.FLESH = Material(2, 0.9, 0.3)
    Material.PLASTIC = Material(0.9, 0.4, 0.7)
    Material.RUBBER = Material(1.7, 0.9, 0.9)
    
    game_load()
end

function love.update(dt)
    game_update(dt)
end

function love.draw()
    game_draw() 
end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end

function love.focus(f)

end

function math.round(num, idp) -- Not by me [http://lua-users.org/wiki/SimpleRound](http://lua-users.org/wiki/SimpleRound)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end