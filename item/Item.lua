Item = Class("Item")

Item.size = 20

function Item:init(sprite)
    self.sprite = sprite
end

function Item:draw(x, y)
    self.sprite:draw(x, y)
    love.graphics.setColor(Colors.green)
    love.graphics.print("IM AN ITEM", x, y)
end

function Item:getItemEntity()
    return ItemEntity(self)
end

function Item.__eq(lhs,rhs)
    return lhs.sprite:getImage() == rhs.sprite:getImage()
end
