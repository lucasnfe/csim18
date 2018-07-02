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
    obj.comp = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function csim_object:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
end

function csim_object.setRotation(r)
    self.rotation = r or self.rotation
end

function csim_object.setScale(sx, sy)
    self.scale_x = sx or self.scale_x
    self.scale_y = sy or self.scale_y
end

return csim_object
