local csim_vector = require "scripts.csim_vector"
local csim_particle = require "scripts.components.csim_particle"
local csim_rigidbody = require "scripts.components.csim_rigidbody"

local csim_psystem = class()

function csim_psystem:init(x, y, p_amount, p_lrange)
    -- Position relative to the component parent
    self.pos = csim_vector(x,y)
    self.init_pos = csim_vector(self.pos.x, self.pos.y)
    self.p_amount = p_amount
    self.p_lrange = p_lrange
    self.particles = {}
    self.name = "psystem"
end

function csim_psystem:load()
    -- Here I can use self.parent
    self.pos = self.parent.pos:add(self.init_pos)

    for i=1,self.p_amount do
        -- p_lrange = {3,5}
        local lifetime = love.math.random(self.p_lrange[1], self.p_lrange[2])
        local w = 8
        local h = 8
        local r = 0
        local spr = love.graphics.newImage("sprites/bullet.png")

        local p = csim_particle(self.pos.x, self.pos.y, w, h, r, spr, lifetime, self)

        -- Add a rigid body to the particle
        local rigidbody = csim_rigidbody(1, 10, 0)
        p:addComponent(rigidbody)

        table.insert(self.particles, p)
    end
end

function csim_psystem:update(dt)
    self.pos = self.parent.pos:add(self.init_pos)

    for i=1,#self.particles do
        self.particles[i]:update(dt)
    end
end

function csim_psystem:draw()
    for i=1,#self.particles do
        self.particles[i]:draw()
    end
end

function csim_psystem:shoot(f)
    for i=1,#self.particles do
        if(not self.particles[i].isAlive) then
            self.particles[i].isAlive = true
            self.particles[i]:getComponent("rigidbody"):applyForce(f)
            return
        end
    end
end

return csim_psystem
