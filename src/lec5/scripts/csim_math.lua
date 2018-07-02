--[[
    CSIM 2018
    Lecture 4

    -- Math Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

csim_math = {}

function csim_math.distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

return csim_math
