--[[
    CSIM 2018

    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_object = class()

function csim_object:init(x, y, spr)
    self.pos = csim_vector(x, y)
    self.spr = spr
    self.components = {}
end

function csim_object:addComponent(component)
    if component ~= nil and component.name ~= nil then
        if component.load ~= nil then
            component:load()    
        end

        component.parent = self
        self.components[component.name] = component
    end
end

function csim_object:getComponent(name)
    return self.components[name]
end

function csim_object:draw()
    love.graphics.draw(self.spr, self.pos.x, self.pos.y)
end

function csim_object:update(dt)
    for name, comp in pairs(self.components) do
        if comp.update ~= nil then
            comp:update(dt)
        end
    end
end

return csim_object
