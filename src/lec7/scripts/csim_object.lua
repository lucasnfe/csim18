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
end

function csim_object:draw()
    love.graphics.draw(self.spr, self.pos.x, self.pos.y)
end

return csim_object
