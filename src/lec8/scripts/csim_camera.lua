--[[
    CSIM 2018
    Lecture 4

    -- Camera Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_camera = class()

function csim_camera:init(x, y)
    self.pos = csim_vector(x, y)
    self.scale_x = 1
    self.scale_y = 1
    self.rotation = 0
end

function csim_camera:setPosition(x, y)
  self.pos.x = x or self.pos.x
  self.pos.y = y or self.pos.y
end

function csim_camera:setRotation(r)
  self.rotation = r or self.rotation
end

function csim_camera:setScale(sx, sy)
  self.scale_x = sx or self.scale_x
  self.scale_y = sy or self.scale_y
end

function csim_camera:start()
    love.graphics.push()
    love.graphics.rotate(-self.rotation)
    love.graphics.scale(1 / self.scale_x, 1 / self.scale_y)
    love.graphics.translate(-self.pos.x, -self.pos.y)
end

function csim_camera:finish()
    love.graphics.pop()
end

return csim_camera
