BodySprite = Class()

function BodySprite:init(world, x, y)
    --adds itself to a global table called "bodysprites" (if any)
    --useful if you update and draw the BodySprites in that table
    if bodysprites then
        if type(bodysprites) == "table" then
            table.insert(bodysprites, self)
        end
    end
    
    self.world = world
    self.body = love.physics.newBody(world, x, y, "dynamic")
    self.body:setLinearDamping(0.02)
    self.body:setAngularDamping(0.09)
    self.fixtures = {}
    self.sprites = {}

    self.x, self.y = self.body:getPosition()
end

function BodySprite:update(dt)
    self.x, self.y = self.body:getPosition()
end

function BodySprite:draw()
    local x,y = self.body:getLocalCenter()
    love.graphics.print(x..","..y.." Angle:".. math.deg(self.body:getAngle()),10, 10)
    
    for _,v in pairs(self.sprites) do
        if v.x then
            local vx,vy = self.body:getWorldVector(v.x, v.y)
            v:draw(self.x + vx, self.y + vy, self.body:getAngle())
        else
            v:draw(self.x, self.y, self.body:getAngle())
        end
    end
    
    for _, v in pairs(self.fixtures) do
        local shape = v:getShape()
        love.graphics.setColor(0,128,64)
        if shape:typeOf("PolygonShape") then
            love.graphics.polygon("line", self.body:getWorldPoints(shape:getPoints()))
            
        elseif shape:typeOf("CircleShape") then
            love.graphics.circle("line", self.body.getWorldPoint(shape:getPoint()), shape:getRadius())
        end
    end
end

function BodySprite:addShape(shape, key)
        self.fixtures[(key or (#self.fixtures + 1))] = love.physics.newFixture(self.body, shape)
end

function BodySprite:addShapeXY(shape, x, y, key)
    if shape:typeOf("CircleShape") then
        local prevX, prevY = shape:getPoint()
        shape = love.physics.newCircleShape(x + prevX, y + prevY, shape:getRadius())
        
    elseif shape:typeOf("PolygonShape") then
        local points = {shape:getPoints()}
        for i,v in pairs(points) do
            if i % 2 == 0 then
                points[i] = v + y
            else
                points[i] = v + x
            end
        end
        shape = love.physics.newPolygonShape(unpack(points))
    end
    
    self:addShape(shape, key)
end

function BodySprite:addSprite(sprite, key)
    self.sprites[key or (#self.sprites + 1)] = sprite
end

function BodySprite:addSpriteXY(sprite, x, y, key)
    sprite.x = x
    sprite.y = y
    self:addSprite(sprite, key)
end
