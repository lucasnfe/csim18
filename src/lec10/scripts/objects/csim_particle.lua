--[[
    CSIM 2018
    Lecture 9

    -- Particle Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_particle = require "scripts.objects.csim_object"
local csim_vector = require "scripts.csim_vector"

csim_particle.is_alive = false
csim_particle.lifetime = 0
csim_particle.timer = 0
csim_particle.system = nil

function csim_particle:shoot(lifetime, speed_x, speed_y)
    self.lifetime = lifetime
    self.is_alive = true
    self:getComponent("rigidbody"):applyForce(csim_vector:new(speed_x, speed_y))
end

function csim_particle:reset()
    self.timer = 0
    self.is_alive = false
end

function csim_particle:onVerticalCollision(tile, vert_side)
    self:reset()
end

function csim_particle:onHorizontalCollision(tile, horiz_side)
    self:reset()
end

return csim_particle
