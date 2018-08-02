--[[
    CSIM 2018

    -- Enemy program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"
local csim_math = require "scripts.csim_math"

local csim_object = require "scripts.objects.csim_object"
local csim_animator = require "scripts.components.csim_animator"
local csim_fsm = require "scripts.components.csim_fsm"
local csim_pathfinder = require "scripts.components.csim_pathfinder"

local csim_enemy = class(csim_object)

function csim_enemy:init(x, y, w, h, r, spr, life)
    csim_object:init(x, y, w, h, r, spr)
    self.life = life or 1
    self.path = {}
    self.current_tile_i = 0
    self.current_tile = nil
end

function csim_enemy:load()
    -- Add animator to enemy
    local animator = csim_animator(self.spr, self.width, self.height)
    animator:addClip("idle", {1, 2}, 2, true)
    self:addComponent(animator)
    self:getComponent("animator"):play("idle")

    -- Add pathfinder to enemy
    local pathfinder = csim_pathfinder(map)
    self:addComponent(pathfinder)

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

    states["seek"] = {}
    states["seek"].enter = self.seekEnter
    states["seek"].update = self.seekUpdate
    states["seek"].exit = self.seekExit

    local fsm = csim_fsm(states, "seek")
    self:addComponent(fsm)

    self:getComponent("rigidbody").apply_gravity = 0
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

-- FSM SEEK STATE FUNCTIONS
function csim_enemy:seekEnter()
end

function csim_enemy:seekTarget(target)
    local vel = target:sub(self.pos)
    vel = vel:norm()
    self:getComponent("rigidbody").vel = vel:div(2)
end

function csim_enemy:seekUpdate(dt)
    local fsm = self:getComponent("fsm")
    fsm.timer = fsm.timer + dt

    -- Plan a path from enemy position to the player every second
    if(fsm.timer >= 0.5) then
        if(player) then
            local enemy_x, enemy_y = self:getComponent("collider"):worldToMapPos(self.pos)
            local enemy_pos = csim_vector(enemy_x + 1, enemy_y + 1)

            local player_x, player_y = player:getComponent("collider"):worldToMapPos(player.pos)
            local player_pos = csim_vector(player_x + 1, player_y + 1)

            self.path = self:getComponent("pathfinder"):plan(enemy_pos, player_pos)
            if(self.path and #self.path >= 1) then
                self.current_tile_i = #self.path - 1
                local screen_x, screen_y = map:convertTileToPixel(self.path[self.current_tile_i].x - 1,
                                                                  self.path[self.current_tile_i].y - 1)
                self.current_tile = csim_vector(screen_x, screen_y)
            else
                self.current_tile_i = 0
                self.current_tile = nil
                self:getComponent("rigidbody").vel = csim_vector(0,0)
            end

            fsm.timer = 0
        end
    end

    if(self.current_tile) then
        self:seekTarget(self.current_tile)

        if(csim_math.distance(self.pos, self.current_tile) < 0.1) then
            self:getComponent("rigidbody").vel = csim_vector(0,0)

            self.current_tile_i = self.current_tile_i - 1
            if(self.current_tile_i >= 1) then
                local screen_x, screen_y = map:convertTileToPixel(self.path[self.current_tile_i].x - 1,
                                                                  self.path[self.current_tile_i].y - 1)
                self.current_tile = csim_vector(screen_x, screen_y)
            else
                self.current_tile_i = 0
                self.current_tile = nil
            end
        end
    end
end

function csim_enemy:seekExit()
end

return csim_enemy
