--[[
    CSIM 2018
    Lecture 8

    -- Player Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_enemy = require "scripts.objects.csim_object"
local csim_vector = require "scripts.csim_vector"

-- FUNCTION OF THE IDLE STATE
function csim_enemy.enter_idle_state(state, enemy)
    enemy:getComponent("rigidbody").vel.x = 0
    enemy:getComponent("animator"):play("idle")
end

function csim_enemy.exit_idle_state(state, enemy)
end

function csim_enemy.update_idle_state(dt, state, enemy)
    enemy:getComponent("rigidbody").vel.x = 0
    state.timer = state.timer + dt
    if(state.timer > 1) then
        enemy.dir = enemy.dir * -1
        state.timer = 0
        enemy:getComponent("fsm"):changeState("move")
    end
end

-- FUNCTION OF THE MOVE STATE
function csim_enemy.enter_move_state(state, enemy)
end

function csim_enemy.exit_move_state(state, enemy)
end

function csim_enemy.update_move_state(dt, state, enemy)
    -- TODO: Move enemy to its current direction and flip it after 1 second
    local speed_x = enemy:getComponent("rigidbody").speed.x
    enemy:getComponent("rigidbody").vel.x = speed_x * -enemy.dir

    -- Play move animation
    local enemy_anim = enemy:getComponent("animator")
    if(not enemy_anim:isPlaying("move")) then
        enemy_anim:play("move")
    end

    state.timer = state.timer + dt

    if(state.timer > 2) then
        state.timer = 0
        enemy:getComponent("fsm"):changeState("idle")
    end
end

return csim_enemy
