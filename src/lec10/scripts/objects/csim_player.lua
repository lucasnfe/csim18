--[[
    CSIM 2018
    Lecture 7

    -- Player Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_player = require "scripts.objects.csim_object"
local csim_vector = require "scripts.csim_vector"

function csim_player:move_y(dir)
    -- TODO: Apply a vertical force to player with magnitude speed_y
    local speed_y = player:getComponent("rigidbody").speed.y
    self:getComponent("rigidbody"):applyForce(csim_vector:new(0, speed_y * dir))
end

function csim_player:move_x(dir)
    -- TODO: Apply a horizontal force to player with magnitude speed_x
    self.dir = dir

    local speed_x = player:getComponent("rigidbody").speed.x
    self:getComponent("rigidbody"):applyForce(csim_vector:new(speed_x * dir, 0))
end

return csim_player
