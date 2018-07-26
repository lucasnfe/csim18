--[[
    CSIM 2018

    -- Enemy program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_object = require "scripts.objects.csim_object"

local csim_enemy = class(csim_object)

function csim_enemy:init(x, y, w, h, r, spr, life)
    csim_object:init(x, y, w, h, r, spr)
    self.life = life or 1
end

function csim_enemy:update(dt)
    local vel = player.pos:sub(self.pos)
    vel = vel:norm()
    vel = vel:div(2)

    self.pos = self.pos:add(vel)
end

return csim_enemy
