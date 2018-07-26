--[[
    CSIM 2018

    -- Collider Component --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_collider = class()

function csim_collider:init(map, rect)
end

function csim_collider:detectHorizontalCollision()
end

function csim_collider:detectVerticalCollision()
end

function csim_collider:worldToMapPos(pos)
end

function csim_collider:resolveHorizontalCollision()
end

function csim_collider:resolveVerticalCollision()
end

return csim_collider
