--[[
    CSIM 2018
    Lecture 8

    -- FSM Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_fsm = {}

function csim_fsm:new(states, s_state)
    local comp = {}
    comp.c_state = s_state
    comp.states = states
    comp.name = "fsm"
    comp.parent = nil

    setmetatable(comp, self)
    self.__index = self
    return comp
end

function csim_fsm:load()
    -- TODO: Enter initial state
end

function csim_fsm:newState(name, f_update, f_enter, f_exit)
    -- TODO: Create a new state with update, enter, exit and timer
end

function csim_fsm:update(dt)
    -- TODO: Call the current state update function
end

function csim_fsm:changeState(new_state)
    -- TODO: Call the exit function if it exists

    -- TODO: If new state exist in the table
    -- 1. Set current state to be the new one
    -- 2. Reset timer and call the
    -- 3. Call the enter function if it exists
end

return csim_fsm
