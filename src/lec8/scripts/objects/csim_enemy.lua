--[[
    CSIM 2018
    Lecture 8

    -- Player Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_object = require "scripts.objects.csim_object"
local csim_vector = require "scripts.csim_vector"

local csim_enemy = class(csim_object)

-- FUNCTION OF THE IDLE STATE
function csim_enemy.enter_idle_state(state, enemy)
    enemy:getComponent("rigidbody").vel.x = 0
end

function csim_enemy.exit_idle_state(state, enemy)
end

function csim_enemy.update_idle_state(dt, state, enemy)
    enemy:getComponent("rigidbody").vel.x = 0
    state.timer = state.timer + dt
    if(state.timer > 1) then
        enemy.direction_x = enemy.direction_x * -1
        state.timer = 0
        enemy:getComponent("fsm"):changeState("move")
    end
end

-- FUNCTION OF THE MOVE STATE
function csim_enemy.enter_move_state(state, enemy)
    if(enemy.direction_x == nil) then
        enemy.direction_x = 1
    end
end

function csim_enemy.exit_move_state(state, enemy)
end

function csim_enemy.update_move_state(dt, state, enemy)
    -- TODO: Move enemy to its current direction and flip it after 1 second
    enemy:move(enemy.direction_x)
    state.timer = state.timer + dt

    if(state.timer > 2) then
        state.timer = 0
        enemy:getComponent("fsm"):changeState("idle")
    end
end

function csim_enemy:update(dt)
    csim_object.update(self, dt)
    self:getComponent("rigidbody"):applyFriction(0.25)
end

function csim_enemy:move(dir)
    -- TODO: Apply a horizontal force to player with magnitude speed_x
    local speed_x = self:getComponent("rigidbody").speed.x
    self:getComponent("rigidbody").vel.x = speed_x * dir
end

return csim_enemy
