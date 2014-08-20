ItemEntity = Class("ItemEntity", BodySprite)

function ItemEntity.setWorld(world)
    ItemEntity.world = world
end

function ItemEntity:init(item, shape, x, y, drawingPriority)
    assert(ItemEntity.world, "the world for all the ItemEntities haven't \nHaven't been set yet. Do this by calling \nItemEntity.setWorld(<world>)")
    self.super:init(ItemEntity.world, x or 0, y or 0)
    
    self.item = item
    
    shape = shape or love.physics.newCircleShape(x or 0, y or 0, Item.size)
    
    item.sprite.x, item.sprite.y = 0, 0

    self:addShape(shape)
    self:addSprite(item.sprite, drawingPriority)
    
    self.body:setFixedRotation(true)
    self.body:setUserData("ItemEntity")
end

function ItemEntity:update()
    self.body:setPosition(self.x, self.y)
end

function ItemEntity:moveTo(x, y)
    self.x, self.y = x, y
end

function ItemEntity:mousepressed(x, y, button)
    if button == "l" then
        if self.fixtures[1]:testPoint(x, y) then
            return true
        end
    end
    return false
end

function ItemEntity:getItem()
    return self.item
end

function ItemEntity.__eq(lhs, rhs)
    return lhs.item == rhs.item
end
