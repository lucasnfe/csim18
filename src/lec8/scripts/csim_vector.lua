--[[
    CSIM 2018

    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = class()

function csim_vector:init(x, y)
    self.x = x
    self.y = y
end

function csim_vector:add(v)
    return csim_vector(self.x + v.x, self.y + v.y)
end

function csim_vector:sub(v)
    return csim_vector(self.x - v.x, self.y - v.y)
end

function csim_vector:mul(s)
    return csim_vector(self.x * s, self.y * s)
end

function csim_vector:div(s)
    return csim_vector(self.x/s, self.y/s)
end

function csim_vector:mag()
    return math.sqrt(self.x*self.x + self.y*self.y)
end

function csim_vector:norm()
    return self:div(self:mag())
end

return csim_vector
