ItemStack = Class("ItemStack")

function ItemStack:init(item, x, y, size)
    self.x, self.y = x or 0, y or 0
    self.size = size or 1
    self.item = item
end

function ItemStack:update()
    if self.size <= 0 then
        return false
    end
    return true
end

function ItemStack:draw()
    self.item:draw(self.x, self.y)
    love.graphics.setColor(Colors.black)
    if true then --self.size > 1 then
        love.graphics.print(self.size, self.x, self.y + 4)
    end
end

function ItemStack:getItemEntity()
    local itemEntity = self.item:getItemEntity()
    itemEntity:moveTo(self.x, self.y)
    
    return itemEntity
end

function ItemStack:getItem()
    return self.item
end

function ItemStack:addToSize(n)
    self.size = self.size + n
end

function ItemStack:setSize(size)
    self.size = size
end

function ItemStack:getSize()
    return self.size
end

function ItemStack:setPos(x, y)
    self.x, self.y = x,y 
end
