--[[
    CSIM 2018
    Lecture 10

    -- Pathfinder Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_pathfinder = {}

function csim_pathfinder:new(map)
    local comp = {}
    comp.map = map
    return comp
end

function csim_pathfinder:adj(node)
end

function csim_pathfinder:cost(node1, node2)
end

function csim_pathfinder:plan(source, goal)
end

function csim_pathfinder:bfs(source, goal)
end

return csim_pathfinder
