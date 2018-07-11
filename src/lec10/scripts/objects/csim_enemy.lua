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
    enemy:getComponent("rigidbody").vel.y = 0
    enemy:getComponent("animator"):play("idle")
end

function csim_enemy.exit_idle_state(state, enemy)
end

function csim_enemy.update_idle_state(dt, state, enemy)
end

-- FUNCTION OF THE MOVE STATE
function csim_enemy.enter_move_state(state, enemy)
end

function csim_enemy.exit_move_state(state, enemy)
end

function csim_enemy.update_move_state(dt, state, enemy)
    -- Play move animation
    local enemy_anim = enemy:getComponent("animator")
    if(not enemy_anim:isPlaying("move")) then
        enemy_anim:play("move")
    end

    -- Plan a path from enemy position to the player every second
    state.timer = state.timer + dt
    if(state.timer >= 1) then
        if(player) then
            local enemy_x, enemy_y = enemy:getComponent("collider"):worldToMapPos(enemy.pos)
            local enemy_pos = csim_vector:new(enemy_x + 1, enemy_y + 1)

            local player_x, player_y = player:getComponent("collider"):worldToMapPos(player.pos)
            local player_pos = csim_vector:new(player_x + 1, player_y + 1)

            enemy:getComponent("pathfinder"):plan(enemy_pos, player_pos)
            state.timer = 0
        end
    end
end

return csim_enemy
