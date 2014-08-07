SpriteAnimation = Class()
-- A Class which can change a given value over time repetitively in different ways
function SpriteAnimation:init(value_to_be_animated, anim_type, start, step, limit, refresh_rate)
    local is_valid
    for k,v in pairs({"quadIndex", "r", "sx", "sy", "ox", "oy", "kx" , "ky"}) do
        if value_to_be_animated == v then
            is_valid = true
        end
    end
    if not is_valid then
        error("Cannot animate that value")
    end
    
    if step < 0 and limit > 0 or step > 0 and limit < 0 then
        error("step arg and limit arg have to be the same polarity")
    end
    self.value_key = value_to_be_animated
    self.mode = (anim_type or "repeat")

    self.start = start
    self.step = step
    self.limit = limit
    self.refresh_rate = refresh_rate

    self.just_started = true
    self.refresh_timer = 0
end

function SpriteAnimation:animate(dt,value)
    if self.just_started then self.just_started = false return self.start end

    self.refresh_timer = self.refreshTimer + dt

    if self.refresh_timer >= self.refresh_rate then
        self.refresh_timer = 0

        value = value + self.step

        if math.abs(self.limit) <= math.abs(value) then

            if self.mode == "single" then
                return "terminate"
            end

            if self.mode == "repeat" then
                return self.start
            end

            if self.mode == "oscillate" then
                self.step = self.step * -1
            end
        end

        if math.abs(value) <= math.abs(start) then
            self.step = self.step * -1
        end

        return self.value
    end
end



Sprite = Class()

-- every arg but "image" is not required
function Sprite:init(image, quadList, r, sx, sy, ox, oy, kx, ky)
    self.image = image
    self.quadList = quadList
    self.quadIndex = 0
    self.r = (r or 0)
    self.sx = (sx or 0)
    self.sy = (sy or 0)
    self.ox = (ox or image:getWidth()/2 )
    self.oy = (oy or image:getHeight()/2 )
    self.kx = (kx or 0)
    self.ky = (ky or 0)

    self.active_animations = {}
    self.unactive_animations = {}
end


[[ Argument descriptions: 
value_to_be_animated: can be either "quadIndex", "r", "sx", "sy", "ox", "oy", "kx" or "ky"
tag: animation "name" use this when specifying the animation to activate in the update function
anim_type: can be either "single","repeat" or "oscillate"
start: starting number for value_to_be_animated (aslo leftmost bound in oscillate mode)
step: step size, set to negative to go backwards 
limit: end number, if hit in "repeat" mode value will be set to start arg, if hit in oscillate mode step will be reversed.
refresh_rate: time in seconds until step is added to value
start_active: boolean if animation should start active]]


function Sprite:addAnimation(value_to_be_animated, tag, anim_type, start, step, limit, refresh_rate, start_active)

    if start_active ~= false then
        self.active_animations[tag] = SpriteAnimation(value_to_be_animated, anim_type, start, step, limit, refresh_rate)
    else
        self.unactive_animations[tag] = SpriteAnimation(value_to_be_animated, anim_type, start, step, limit, refresh_rate)
    end
end

function Sprite:addQuad(quad, index)
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
            if #quadList < size then break end
            
            x = x + stepX
        end
        y = y + stepY
    end
    
    for k,v in pairs(quadList) do
        self.quadList[k] = v
    end
end

end

function Sprite:update(dt, toggle_activestate_list)
    if dt then

        if toggle_activestate_list then
            for k,v in pairs(toggle_activestate_list) do
                if v then
                    self.active_animations[k] = self.unactive_animations[k]
                    self.unactive_animations[k] = nil
                else
                    self.unactive_animations[k] = self.active_animations[k]
                    self.active_animations[k] = nil
                end
            end
        end

        for k,v in pairs(self.active_animations) do
            local temp_val = v:animate(dt, self[v.value_key])

            if temp_val ~= "terminate"
            self[v.value_key] = temp_val
        else
            self.unactive_animations[k] = v
            self.active_animations[k] = nil
        end
    end
end
end



function Sprite:draw(x,y)
    if self.quadList then
        love.graphics.draw(self.image, x, y, self.r, self.sx, self.sy, self.ox, self.oy, self.kx, self.ky)
    else
        love.graphics.draw(self.image, self.quadList[math.ceil(self.quadIndex)], self.x, self.y, self.r, self.sx, self.sy, self.ox, self.oy, self.kx, self.ky)
    end
end