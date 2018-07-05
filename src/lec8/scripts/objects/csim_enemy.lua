--[[
    CSIM 2018
    Lecture 8

    -- Player Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_enemy = require "scripts.objects.csim_object"
local csim_vector = require "scripts.csim_vector"

function csim_enemy.enter_move_state(state, enemy)
    enemy.direction = 1
end

function csim_enemy.exit_move_state(state, enemy)
end

function csim_enemy.update_move_state(dt, state, enemy)
    -- TODO: Move enemy to its current direction and flip it after 1 second
end

return csim_enemy
