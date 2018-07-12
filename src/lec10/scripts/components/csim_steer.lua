--[[
    CSIM 2018
    Lecture 9

    -- Animator Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_steer = {}

function csim_steer:new()
    local comp = {}
    comp.name = "steer"
    comp.parent = nil

    setmetatable(comp, self)
    self.__index = self
    return comp
end

function csim_steer:seek(target)
    local rigid_body = self.parent:getComponent("rigidbody")
    if(rigid_body) then
        -- Desired force = target.pos - self.parent.pos
        -- Target is the PLAYER and self.parent is the ENEMY
        local desired_force = csim_vector:new(target.pos.x, target.pos.y)
        desired_force:sub(self.parent.pos)

        -- Scale steering force by enemy speed
        desired_force:norm()
        desired_force:mul(4)

        -- Steering force = desired_force - vel
        local steering_force = csim_vector:new(desired_force.x, desired_force.y)
        steering_force:sub(rigid_body.vel)

        -- Normalize steering force
        steering_force:norm()
        steering_force:mul(0.05)

        -- Apply steering force to the enemy
        rigid_body:applyForce(steering_force)
    end
end

function csim_steer:flee(target)
    local rigid_body = self.parent:getComponent("rigidbody")
    if(rigid_body) then
        -- Desired force = target.pos - self.parent.pos
        -- Target is the PLAYER and self.parent is the ENEMY
        local desired_force = csim_vector:new(self.parent.pos.x, self.parent.pos.y)
        desired_force:sub(target.pos)

        -- Scale steering force by enemy speed
        desired_force:norm()
        desired_force:mul(1)

        -- Steering force = desired_force - vel
        local steering_force = csim_vector:new(desired_force.x, desired_force.y)
        steering_force:sub(rigid_body.vel)

        -- Normalize steering force
        steering_force:norm()
        steering_force:mul(1)

        -- Apply steering force to the enemy
        rigid_body:applyForce(steering_force)
    end
end

return csim_steer
