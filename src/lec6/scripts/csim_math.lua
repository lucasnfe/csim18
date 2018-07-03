--[[
    CSIM 2018
    Lecture 4

    -- Math Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

csim_math = {}

function csim_math.distance(v1, v2)
    return math.sqrt((v2.x - v1.x)^2 + (v2.y - v1.y)^2)
end

function csim_math.checkBoxCollision(min_a, max_a, min_a, max2_a)
    -- TODO: Implement AABB vs AABB collision detection
end

return csim_math
