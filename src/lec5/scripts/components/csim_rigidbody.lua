--[[
    CSIM 2018
    Lecture 4

    -- Rigid Body Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_rigidbody = {}

function csim_rigidbody:new(parent, mass)
    local comp = {}
    comp.vel = csim_vector:new(0,0)
    comp.acc = csim_vector:new(0,0)
    comp.mass = mass
    comp.name = "rigidbody"
    comp.parent = parent
    setmetatable(comp, self)
    self.__index = self
    return comp
end

function csim_rigidbody:applyForce(f)
    -- TODO: sum vector f (f.x, f.y) to self.acc (self.acc.x, self.acc.y)
    -- f = m * a
    -- a = f/m
    f:div(self.mass)
    self.acc:add(f)
end

function csim_rigidbody:update(dt)
    -- TODO: create a vector g (0,9.8) representing gravity
    -- using csim_vector:new()
    local g = csim_vector:new(0, 0.98*self.mass)
    self:applyForce(g)

    -- TODO: Sum acc to self.vel
    self.vel:add(self.acc)

    -- TODO: Sum self.vel to self.parent.pos
    self.parent.pos:add(self.vel)

    -- TODO: set set self.acc to (0,0)
    self.acc.x = 0
    self.acc.y = 0
end

return csim_rigidbody
