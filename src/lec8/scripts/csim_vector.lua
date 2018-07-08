--[[
    CSIM 2018
    Lecture 4

    -- Vector Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = class()

function csim_vector:init (x, y)
    self.x = x
    self.y = y
end

function csim_vector:add(v)
    self.x = self.x + v.x
    self.y = self.y + v.y
end

function csim_vector:sub(v)
    self.x = self.x - v.x
    self.y = self.y - v.y
end

function csim_vector:mul(s)
    self.x = self.x * s
    self.y = self.y * s
end

function csim_vector:div(s)
    self.x = self.x / s
    self.y = self.y / s
end

function csim_vector:mag()
    return math.sqrt(self.x*self.x + self.y*self.y)
end

function csim_vector:norm()
    local mag = self:mag()
    self:div(mag)
end

return csim_vector
