Slot = Class("Slot")

function Slot:init(x, y, itemStack)
    self.itemStack = itemStack
    self.x = x or 0
    self.y = y or 0
    self.is_active = true
    self.drawSlot = true
end

function Slot:exchange(to) --to = slot
    if to.itemStack and self.itemStack then
        if to.itemStack:getItem() == self.itemStack:getItem() then
            to.itemStack:addToSize(self.itemStack:getSize())
            self.itemStack = nil
            return
        end
    end
    self.itemStack , to.itemStack = to.itemStack , self.itemStack
end

function Slot:split(with)
    if not with.itemStack and self.itemStack then
        with.itemStack = ItemStack(self.itemStack:getItem(), with.x, with.y, 0)
        with.itemStack:addToSize(math.ceil(self.itemStack:getSize()/2))
        self.itemStack:addToSize(math.floor(-self.itemStack:getSize()/2))
        return true
    end
end

function Slot:transfer(to, amount)
    amount = amount or 1
    if self.itemStack then
        if to.itemStack then
            if to.itemStack:getItem() == self.itemStack:getItem() then
                to.itemStack:addToSize(amount)
                self.itemStack:addToSize(-amount)
                return true
            end
        else
            to.itemStack = ItemStack(self.itemStack:getItem(), to.x, to.y, amount)
            self.itemStack:addToSize(-amount)
            return true
        end
    end
end

function Slot:update(mx, my)
    if self.itemStack then
        if not self.itemStack:update() then
            self.itemStack = nil
        end
    end
end

function Slot:draw()
    if self.is_active then
        if self.drawSlot then
            love.graphics.setColor(Colors.grey)
            love.graphics.rectangle("fill", self.x-Item.size, self.y-Item.size, Item.size*2, Item.size*2)
            love.graphics.setColor(Colors.lightgrey)
            love.graphics.rectangle("fill", self.x-Item.size +1, self.y-Item.size +1, Item.size*2-2, Item.size*2-2)
        end
    
        if self.itemStack then
            self.itemStack:setPos(self.x, self.y)
            self.itemStack:draw()
        end
    end
end

function Slot:mousepressed(x, y, button) 
    if self.is_active and (button == "l" or button == "r") then
        return math.abs(x - self.x) < Item.size and math.abs(y - self.y) < Item.size   
    end
    return false
end
    
function Slot:setPos(x, y)
    self.x = x
    self.y = y
end

function Slot:setItemStack(itemstack)
    self.itemStack = itemstack
end

function Slot:setActiveState(is_active)
    self.is_active = is_active
end

function Slot:isActive()
    return self.is_active
end

function Slot:getItemStack()
    return self.itemStack
end
