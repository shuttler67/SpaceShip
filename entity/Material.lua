Material = Class("Material")

Material.isSoundEnabled = false

function Material.getCallbackForSoundOnImpact()
    Material.isSoundEnabled = true
    
    return function(a, b, coll)
        for _, f in pairs({a, b}) do
            if f:getUserData() then
                if Material:made(f:getUserData()) then
                    f:getUserData():playSound()
    end end end end
end

function Material:init(density, friction, restitution, sounds)
    self.density, self.friction, self.restitution = density, friction, restitution
    self.sounds = (sounds or {})
end

function Material:apply(fixture)
    fixture:setFriction(self.friction)
    fixture:setDensity(self.density)
    fixture:setRestitution(self.restitution)
    
    if Material.isSoundEnabled then
        fixture:setUserData(self)
    end
end

function Material:playSound()
    if #self.sounds ~= 0 then
        local index = love.math.random(1, #self.sounds)
        love.audio.play(self.sounds[index])
    end
end
