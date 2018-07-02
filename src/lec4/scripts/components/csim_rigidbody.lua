--[[
    CSIM 2018
    Lecture 4

    -- Rigid Body Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

csim_rigidbody = {}

function csim_rigidbody:new (parent, mass)
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
end

function csim_rigidbody:update(dt)
end

return csim_rigidbody
