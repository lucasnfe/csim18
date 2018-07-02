--[[
    CSIM 2018
    Lecture 4

    -- Vector Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = {}

function csim_vector:new (x, y)
    local v = {}
    v.x = x
    v.y = y
    setmetatable(v, self)
    self.__index = self
    return v
end

function csim_vector:add(v)
    self.x = self.x + v.x
    self.y = self.y + v.y
end

function csim_vector:sub(v)
end

function csim_vector:mul(s)
end

function csim_vector:div(s)
end

function csim_vector:mag(s)
end

function csim_vector:norm()
end

return csim_vector
