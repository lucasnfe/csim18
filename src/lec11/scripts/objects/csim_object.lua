--[[
    CSIM 2018

    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_object = class()

function csim_object:init(x, y, w, h, r, spr)
    self.pos = csim_vector(x, y)
    self.width = w or 0
    self.height = h or 0
    self.rotation = r or 0
    self.quad = love.graphics.newQuad(0, 0, w, h, spr:getWidth(), spr:getHeight())
    self.dir = 1
    self.spr = spr
    self.components = {}
end

function csim_object:addComponent(component)
    if component ~= nil and component.name ~= nil then
        component.parent = self
        if component.load ~= nil then
            component:load()
        end

        self.components[component.name] = component
    end
end

function csim_object:getComponent(name)
    return self.components[name]
end

function csim_object:load()
end

function csim_object:draw()
    local x_shift = 0
    if(self.dir == -1) then
        x_shift = self.width
    end

    love.graphics.draw(self.spr, self.quad, self.pos.x + x_shift, self.pos.y, self.rotation, self.dir, 1, 0, 0, 0)

    for name, comp in pairs(self.components) do
        if comp.draw ~= nil then
            comp:draw()
        end
    end
end

function csim_object:update(dt)
    for name, comp in pairs(self.components) do
        if comp.update ~= nil then
            comp:update(dt)
        end
    end
end

return csim_object
