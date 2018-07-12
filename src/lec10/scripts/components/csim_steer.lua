--[[
    CSIM 2018
    Lecture 9

    -- Animator Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_steer = {}

function csim_steer:new(spriteSheet, width, height)
    local comp = {}
    comp.name = "steer"
    comp.parent = nil

    setmetatable(comp, self)
    self.__index = self
    return comp
end

function csim_steer:seek(target)
end

function csim_steer:flee(target)
end

return csim_steer
