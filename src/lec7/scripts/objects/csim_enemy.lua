local csim_object = require "scripts.objects.csim_object"

local csim_enemy = class(csim_object)

function csim_enemy:init(x, y, spr)
    csim_object:init(x, y, spr)
    self.life = 10
end

function csim_enemy:update(dt)
    local vel = player.pos:sub(self.pos)
    vel = vel:norm()
    vel = vel:div(2)

    self.pos = self.pos:add(vel)
end

return csim_enemy
