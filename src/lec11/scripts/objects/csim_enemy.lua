--[[
    CSIM 2018

    -- Enemy program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_object = require "scripts.objects.csim_object"
local csim_animator = require "scripts.components.csim_animator"

local csim_enemy = class(csim_object)

function csim_enemy:init(x, y, w, h, r, spr, life)
    csim_object:init(x, y, w, h, r, spr)
    self.life = life or 1
end

function csim_enemy:load()
    -- Add animator to player
    local animator = csim_animator(self.spr, self.width, self.height)
    animator:addClip("idle", {1, 2}, 2, true)
    self:addComponent(animator)

    self:getComponent("animator"):play("idle")
end

function csim_enemy:update(dt)
    csim_object.update(self, dt)
end

return csim_enemy
