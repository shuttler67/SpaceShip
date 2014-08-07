
function Class( baseClass )

    local new_class = {}
    new_class.__index = new_class

    local new_class_mt = {__call = function (c, ...)
            local newinst = {}
            setmetatable( newinst, c )
            if newinst.init then newinst.init(newinst, ...) end
            return newinst
        end}

    if nil ~= baseClass then
        new_class_mt.__index = baseClass
    end

    setmetatable( new_class, new_class_mt)

    -- Implementation of additional OO properties starts here --

    -- Return the class object of the instance
    function new_class:getClass()
        return new_class
    end

    function new_class:getSuperClass()
        return baseClass
    end

    function new_class:get(tag)
        if self[tag] == nil then
            error("tag is not part of class")
        end
        return self[tag]
    end

    function new_class:set(tag, value)
        if self[tag] == nil then
            error("tag is not part of class")
        end
        self[tag] = value
    end

    -- Return the super class object of the instance
    -- func is a String
    function new_class:super(func, ...)
        baseClass[func](self,...)
    end

    -- Return true if the caller is an instance of theClass
    function new_class:is_a( theClass )
        local is_a = false

        local cur_class = new_class

        while ( nil ~= cur_class ) and ( false == is_a ) do
            if cur_class == theClass then
                is_a = true
            else
                cur_class = cur_class:getSuperClass()
            end
        end

        return is_a
    end

    return new_class
end
