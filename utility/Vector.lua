Vector = Class("Vector")

function Vector:__tostring()
    return string.format("Vector: %d, %d", self.x, self.y)
end

function Vector:init(x, y)
    self.x = x
    self.y = y
end

function Vector:Length()
    return math.sqrt(self.x^2 + self.y^2)
end

function Vector:LengthSqr()
    return self.x^2 + self.y^2
end

function Vector:set(x, y)
    self.x = x
    self.y = y
end

function Vector.__unm(vector)
    return Vector(-vector.x, -vector.y)
end

function Vector.__add(lhs, rhs)
        
    if Vector:made(lhs) and Vector:made(rhs) then
        return Vector(lhs.x + rhs.x, lhs.y + rhs.y)
    elseif Vector:made(lhs) and type(rhs) == "number" then
        return Vector(lhs.x + rhs, lhs.y + rhs)
    elseif type(lhs) == "number" and Vector:made(rhs) then
        return Vector(lhs + rhs.x, lhs + rhs.y)
    end
end

function Vector.__sub(lhs, rhs)

    if Vector:made(lhs) and Vector:made(rhs) then
        return Vector(lhs.x - rhs.x, lhs.y - rhs.y)
    elseif Vector:made(lhs) and type(rhs) == "number" then
        return Vector(lhs.x - rhs, lhs.y - rhs)
    elseif type(lhs) == "number" and Vector:made(rhs) then
        return Vector(lhs - rhs.x, lhs - rhs.y)
    end
end

function Vector.__mul(lhs, rhs)

    if Vector:made(lhs) and Vector:made(rhs) then
        return Vector(lhs.x * rhs.x, lhs.y * rhs.y)
    elseif Vector:made(lhs) and type(rhs) == "number" then
        return Vector(lhs.x * rhs, lhs.y * rhs)
    elseif type(lhs) == "number" and Vector:made(rhs) then
        return Vector(lhs * rhs.x, lhs * rhs.y)
    end
end

function Vector.__div(lhs, rhs)

    if Vector:made(lhs) and Vector:made(rhs) then
        return Vector(lhs.x / rhs.x, lhs.y / rhs.y)
    elseif Vector:made(lhs) and type(rhs) == "number" then
        return Vector(lhs.x / rhs, lhs.y / rhs)
    elseif type(lhs) == "number" and Vector:made(rhs) then
        return Vector(lhs / rhs.x, lhs / rhs.y)
    end
end

function Vector.__eq(lhs, rhs)
    return lhs.x == rhs.x and lhs.y == rhs.y
end

function Vector:normalised()
    local len = self:Length()
    return Vector(self.x / len, self.y / len)
end

function Vector:rotate(r)
    self.x, self.y = self.x * math.cos(r) + self.y * math.sin(r), self.x * -math.sin(r) + self.y * math.cos(r)
end

function Vector:dotProduct(othervect)
    if not Vector:made(othervect) then return end
    
    return self.x * othervect.x + self.y * othervect.y
end

function Vector.crossProduct(lhs, rhs)

    if Vector:made(lhs) and Vector:made(rhs) then
        return lhs.x * rhs.y - lhs.y * rhs.x
    elseif Vector:made(lhs) and type(rhs) == "number" then
        return Vector(rhs * lhs.y, -rhs * lhs.x)
    elseif type(lhs) == "number" and Vector:made(rhs) then
        return Vector(-lhs * rhs.y, lhs * rhs.x)
    end
end

    