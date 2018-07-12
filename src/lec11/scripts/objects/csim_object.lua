--[[
    CSIM 2018
    Lecture 4

    -- Game Object Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

csim_object = {}

local csim_vector = require "scripts.csim_vector"

function csim_object:new (x, y, w, h, rotation, spr)
    local obj = {}
    obj.pos = csim_vector:new(x, y)
    obj.rotation = rotation
    obj.width = w
    obj.height = h
    obj.spr = spr
    obj.quad = love.graphics.newQuad(0, 0, w, h, spr:getWidth(), spr:getHeight())
    obj.dir = 1
    obj.components = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
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

function csim_object:load()
    for i=1,#self.components do
        if(self.components[i].load ~= nil) then
            self.components[i]:load()
        end
    end
end

function csim_object:update(dt)
    for name,component in pairs(self.components) do
        if(component.update ~= nil) then
            component:update(dt)
        end
    end
end

function csim_object:draw(dt)
    local x_shift = 0
    if(self.dir == -1) then
        x_shift = self.width
    end
    love.graphics.draw(self.spr, self.quad, self.pos.x + x_shift, self.pos.y, self.rotaion, self.dir, 1, 0, 0, 0)
end

return csim_object
