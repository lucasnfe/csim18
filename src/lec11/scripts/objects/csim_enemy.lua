--[[
    CSIM 2018

    -- Enemy program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_object = require "scripts.objects.csim_object"
local csim_animator = require "scripts.components.csim_animator"
local csim_fsm = require "scripts.components.csim_fsm"

local csim_enemy = class(csim_object)

function csim_enemy:init(x, y, w, h, r, spr, life)
    csim_object:init(x, y, w, h, r, spr)
    self.life = life or 1
end

function csim_enemy:load()
    -- Add animator to enemy
    local animator = csim_animator(self.spr, self.width, self.height)
    animator:addClip("idle", {1, 2}, 2, true)
    self:addComponent(animator)
    self:getComponent("animator"):play("idle")

    -- Add a fsm to enemy
    states = {}
    states["idle"] = {}
    states["idle"].enter = self.idleEnter
    states["idle"].update = self.idleUpdate
    states["idle"].exit = self.idleExit

    states["move"] = {}
    states["move"].enter = self.moveEnter
    states["move"].update = self.moveUpdate
    states["move"].exit = self.moveExit

    local fsm = csim_fsm(states, "idle")
    self:addComponent(fsm)
end

function csim_enemy:update(dt)
    csim_object.update(self, dt)
end

-- FSM IDLE STATE FUNCTIONS
function csim_enemy:idleEnter()
    print("blah!")
    self:getComponent("rigidbody").vel = csim_vector(0,0)
end

function csim_enemy:idleUpdate(dt)
    local fsm = self:getComponent("fsm")
    fsm.timer = fsm.timer + dt
    if(fsm.timer > 1) then
        fsm:changeState("move")
    end
end

function csim_enemy:idleExit()
end

-- FSM MOVE STATE FUNCTIONS
function csim_enemy:moveEnter()
    print("Blah! Blah! Blah!")
    self.dir = self.dir * -1
    self:getComponent("rigidbody").vel.x = 0.5 * self.dir
end

function csim_enemy:moveUpdate(dt)
    local fsm = self:getComponent("fsm")
    fsm.timer = fsm.timer + dt
    if(fsm.timer > 2) then
        fsm:changeState("idle")
    end
end

function csim_enemy:moveExit()
end

return csim_enemy
