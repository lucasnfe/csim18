--[[
    CSIM 2018
    Lecture 4

    -- Rigid Body Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_rigidbody = class()
local GRAVITY = 9.8
local MAX_SPEED = 5

function csim_rigidbody:init(mass, speed_x, speed_y)
    self.speed = csim_vector(speed_x, speed_y)
    self.vel = csim_vector(0,0)
    self.acc = csim_vector(0,0)
    self.mass = mass
    self.name = "rigidbody"
    self.parent = nil
end

function csim_rigidbody:applyForce(f)
    -- TODO: sum vector f (f.x, f.y) to self.acc (self.acc.x, self.acc.y)
    -- f = m * a
    -- a = f/m
    f:div(self.mass)
    self.acc:add(f)
end

function csim_rigidbody:applyFriction(u)
    -- TODO: Implement friction with the ground
    -- Hint: F = -1 * u * v:norm()
    if(self.vel:mag() > 0.1) then
        local f = csim_vector(self.vel.x, self.vel.y)
        f:norm()
        f:mul(-1 * u)
        self:applyForce(f)
    else
        self.vel = csim_vector(0,0)
    end
end

function csim_rigidbody:applyResistance(c_d)
    -- TODO: Implement friction with the ground
    -- Hint: F = v:mag()^2 * c_d * v:norm()
end

function csim_rigidbody:update(dt)
    -- TODO: create a vector g (0,9.8) representing gravity
    -- using csim_vector:new()
    local g = csim_vector(0, GRAVITY*0.05*self.mass)
    self:applyForce(g)

    -- TODO: Sum acc to self.vel
    self.vel:add(self.acc)

    local collider = self.parent:getComponent("collider")
    if(collider) then
        -- TODO: Check for horizontal collision
        collider:updateVertical()

        -- TODO: Check for vertical collision
        collider:udpateHorizontal()
    end

    self.vel.x = csim_math.clamp(self.vel.x, -MAX_SPEED, MAX_SPEED)

    -- TODO: Sum self.vel to self.parent.pos
    self.parent.pos:add(self.vel)

    -- TODO: set set self.acc to (0,0)
    self.acc = csim_vector(0, 0)
end

return csim_rigidbody
