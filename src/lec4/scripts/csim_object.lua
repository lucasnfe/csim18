--[[
    CSIM 2018
    Lecture 4

    -- Game Object Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

csim_object = {}

function csim_object:new (x, y, rotation, spr)
    local obj = {}
    obj.x = x
    obj.y = y
    obj.rotation = rotation
    obj.spr = spr
    obj.components = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function csim_object:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
end

function csim_object:setRotation(r)
    self.rotation = r or self.rotation
end

function csim_object:addComponent(component)
    table.insert(self.components, component)
end

function csim_object:load()
    for i=1,#self.components do
        if(self.components[i].load ~= nil) then
            self.components[i]:load()
        end
    end
end

function csim_object:update(dt)
    for i=1,#self.components do
        if(self.components[i].update ~= nil) then
            self.components[i]:update(dt)
        end
    end
end

return csim_object
