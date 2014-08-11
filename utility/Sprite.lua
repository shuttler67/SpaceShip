SpriteAnimation = Class()
-- A Class which can change a given value over time repetitively in different ways
function SpriteAnimation:init(value_to_be_animated, anim_type, start, step, limit, refresh_rate)
    local is_valid = false
    for k,v in pairs({"quadIndex", "r", "sx", "sy", "ox", "oy", "kx" , "ky"}) do
        if value_to_be_animated == v then
            is_valid = true
        end
    end
    assert(is_valid, "Cannot animate that value")
    assert(not (step < 0 and limit > 0 or step > 0 and limit < 0 ), "step arg and limit arg have to be the same polarity")

    self.value_key = value_to_be_animated
    self.mode = (anim_type or "repeat")

    self.start = start
    self.step = step
    self.limit = limit
    self.refresh_rate = (refresh_rate or 1)

    self.just_started = true
end

function SpriteAnimation:evaluate(value)
    if self.start < self.limit then 
        if self.step > 0 then
            return value >= self.limit 
            
        elseif self.mode == "oscillate" then
            return value <= self.start
        end
    else
        if self.step < 0 then
            return value <= self.limit
            
        elseif self.mode == "oscillate" then
            return value >= self.start
        end
    end
    return false
end

function SpriteAnimation:animate(dt, value)
    if self.just_started then 
        self.just_started = false 
        return self.start 
    end

    value = value + self.step * dt * self.refresh_rate

    if self:evaluate(value) then
        if self.mode == "single" then
            self.just_started = true
            return "terminate"
        end

        if self.mode == "repeat" then
            self.just_started = true
            return self.start
        end

        if self.mode == "oscillate" then
            self.step = self.step * -1
        end
    end
    return value
end



Sprite = Class()

-- every arg but "image" is not required
function Sprite:init(image, quadList, r, sx, sy, ox, oy, kx, ky)
    self.image = image
    self.quadList = quadList
    self.quadIndex = 1
    self.r = (r or 0)
    self.sx = (sx or 1)
    self.sy = (sy or 1)
    self.ox = (ox or image:getWidth()/2 )
    self.oy = (oy or image:getHeight()/2 )
    self.kx = (kx or 0)
    self.ky = (ky or 0)

    self.active_animations = {}
    self.all_animations = {}
end


-- Argument descriptions: 
--value_to_be_animated: can be either "quadIndex", "r", "sx", "sy", "ox", "oy", "kx" or "ky"
--tag: animation "name" use this when specifying the animation to activate in the update function
--anim_type: can be either "single","repeat" or "oscillate"
--start: starting number for value_to_be_animated (aslo leftmost bound in oscillate mode)
--step: step size, set to negative to go backwards 
--limit: end number, if hit in "repeat" mode value will be set to start arg, if hit in oscillate mode step will be reversed.
--refresh_rate: How many times per second step is added
--start_active: boolean if animation should start active
function Sprite:addAnimation(value_to_be_animated, tag, anim_type, start, step, limit, refresh_rate, start_active)

    self.all_animations[tag] = SpriteAnimation(value_to_be_animated, anim_type, start, step, limit, refresh_rate)
    
    if not (start_active == false) then
        self.active_animations[tag] = self.all_animations[tag]
    end
end

function Sprite:toggleAnimation(tag, turnOn)
    if turnOn then
        self.active_animations[tag] = self.all_animations[tag]
    else
        self.active_animations[tag] = nil
        self.all_animations[tag].just_started = true
    end
end

function Sprite:addQuad(quad, index)
    if not self.quadList then
        self.quadList = {}
    end

    if index then
        table.insert(self.quadList, index, quad)
    else
        table.insert(self.quadList, quad)
    end
end

--stepx, stepy will be replaced with width and height if not given
function Sprite:createQuadListFromGrid(width, height, size, stepx, stepy)
    local quadList, x, y, stepX, stepY = {} , 0 , 0, (stepx or width), (stepy or height)

    while y <= self.image:getHeight() - stepY and #quadList < size do
        while x <= self.image:getWidth() - stepX do
            table.insert(quadList, love.graphics.newQuad(x, y, width, height, self.image:getWidth(), self.image:getHeight()))
            if #quadList >= size then break end

            x = x + stepX
        end
        y = y + stepY
    end
    for k,v in pairs(quadList) do
        if not self.quadList then
            self.quadList = {}
        end
        
        self.quadList[k] = v
    end
end


function Sprite:update(dt)

    for k,v in pairs(self.active_animations) do
        local temp_val = v:animate(dt, self[v.value_key])

        if not (temp_val == "terminate") then
            self[v.value_key] = temp_val
        else
            self.active_animations[k] = nil 
        end
    end
end




function Sprite:draw(x, y, r)
    love.graphics.setColor(0,0,0)
    love.graphics.print(self.quadIndex,10, 30)
    love.graphics.setColor(255,255,255)

    if not self.quadList then --too lazy to switch order and take out the "not"
        love.graphics.draw(self.image, x, y, self.r + (r or 0), self.sx, self.sy, self.ox, self.oy, self.kx, self.ky)
    else
        love.graphics.draw(self.image, self.quadList[math.round(self.quadIndex)], x, y, self.r + (r or 0), self.sx, self.sy, self.ox, self.oy, self.kx, self.ky)
    end
end

function Sprite:setRotation(r)
    self.r = r
end

function Sprite:setScale(sx, sy)
    self.sx, self.sy = sx, sy
end

function Sprite:setOffset(ox, oy)
    self.ox, self.oy = ox, oy
end

function Sprite:setShearing(kx, ky)
    self.kx, self.ky = kx, ky
end

function Sprite:setQuadIndex(i)
    self.quadIndex = i
end

function Sprite:getQuadIndex()
    return self.quadIndex
end

function Sprite:getRotation()
    return self.r
end

function Sprite:getScale()
    return self.sx, self.sy
end

function Sprite:getOffset()
    return self.ox, self.oy
end

function Sprite:getShearing()
    return self.kx, self.ky
end

function Sprite:getImage()
    return self.image
end