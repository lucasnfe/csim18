--[[
    CSIM 2018
    Lecture 4

    -- Game Object Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_object = class()

function csim_object:init (x, y, rotation, spr)
    self.pos = csim_vector(x, y)
    self.rotation = rotation
    self.spr = spr
    self.components = {}
end

function csim_object:setPosition(x, y)
    self.pos.x = x or self.pos.x
    self.pos.y = y or self.pos.y
end

function csim_object:setRotation(r)
    self.rotation = r or self.rotation
end

function csim_object:addComponent(component)
    if(component ~= nil) then
        component.parent = self
        self.components[component.name] = component

        if(component.load) then
            component:load()
        end
    end
end

function csim_object:getComponent(name)
    return self.components[name]
end

function csim_object:update(dt)
    for name,component in pairs(self.components) do
        if(component.update ~= nil) then
            component:update(dt)
        end
    end
end

return csim_object
