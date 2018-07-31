--[[
    CSIM 2018
    Lecture 4

    -- Camera Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_camera = class()

function csim_camera:init(x, y, sx, sy, r)
  self.x = x or 0
  self.y = y or 0
  self.scale_x = sx or 1
  self.scale_y = sy or 1
  self.rotation = r or 0
end

function csim_camera:setPosition(x, y)
  self.x = x or self.x
  self.y = y or self.y
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
    love.graphics.translate(-self.x, -self.y)
end

function csim_camera:finish()
    love.graphics.pop()
end

return csim_camera
