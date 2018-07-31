local csim_vector = require "scripts.csim_vector"
local csim_object = require "scripts.objects.csim_object"

local csim_particle = class(csim_object)

function csim_particle:init(x, y, w, h, r, spr, lifetime, system)
    csim_object:init(x, y, w, h, r, spr)
    self.isAlive = false
    self.lifetime = lifetime
    self.timer = 0
    self.system = system
end

function csim_particle:update(dt)
    if(not self.isAlive) then
        self.pos = csim_vector(self.system.pos.x, self.system.pos.y)
        self:getComponent("rigidbody").vel = csim_vector(0,0)
    else
        csim_object.update(self, dt)

        self.timer = self.timer + dt
        if(self.timer >= self.lifetime) then
            self.isAlive = false
            self.timer = 0
        end
    end
end

return csim_particle
