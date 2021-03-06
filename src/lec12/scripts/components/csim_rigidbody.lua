--[[
    CSIM 2018

    -- Rigid Body Component --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_rigidbody = class()

local MAX_SPEED = 3

function csim_rigidbody:init(mass, max_speed, apply_gravity)
    self.vel = csim_vector(0,0)
    self.acc = csim_vector(0,0)
    self.max_speed = max_speed or MAX_SPEED
    self.mass = mass or 1
    self.apply_gravity = apply_gravity or 1
    self.name = "rigidbody"
end

function csim_rigidbody:load()

end

function csim_rigidbody:applyForce(f)
    if(self.mass ~= 0) then
        self.acc.x = self.acc.x + f.x/self.mass
        self.acc.y = self.acc.y + f.y/self.mass
    end
end

function csim_rigidbody:applyFriction(u)
    if(self.vel:mag() > 0.1) then
        local f = self.vel:norm()
        f = f:mul(-1 * u)
        self:applyForce(f)
    else
        self.vel = csim_vector(0,0)
    end
end

function csim_rigidbody:applyResistance(c_d, only_horizontal)
    only_horizontal = only_horizontal or false

    if(self.vel:mag() > 0.1) then

        local speed = self.vel:mag()
        local dragMagnitude = c_d * speed * speed

        local f = self.vel:mul(-1)
        f = f:norm()
        f = f:mul(dragMagnitude)

        if(only_horizontal) then
            f.y = 0
        end

        self:applyForce(f)
    else
        local f = csim_vector(0,0)
        if(only_horizontal) then
            f.y = self.vel.y
        end

        self.vel = f
    end
end

function csim_rigidbody:update(dt)
    -- Apply weight force
    if(self.apply_gravity == 1) then
        local g = csim_vector(0, 0.098)
        local weight = g:mul(self.mass)
        self:applyForce(weight)
    end

    self.vel = self.vel:add(self.acc)

    local collider = self.parent:getComponent("collider")
    if(collider) then
        collider:detectVerticalCollision(self.vel)
        collider:detectHorizontalCollision(self.vel)
    end

    if(self.vel:mag() > self.max_speed) then
        self.vel = self.vel:norm()
        self.vel = self.vel:mul(self.max_speed)
    end

    self.parent.pos = self.parent.pos:add(self.vel)

    self.acc = csim_vector(0, 0)
end

return csim_rigidbody
