--[[
    CSIM 2018
    Lecture 9

    -- Particle System Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_rigidbody = require "scripts.components.csim_rigidbody"
local csim_particle = require "scripts.objects.csim_particle"
local csim_vector = require "scripts.csim_vector"

local csim_particle_system = {}

function csim_particle_system:new(p_amount, pos, spr, w, h, gravity_scale, spawn_time, lifetime_range, speed_x_range, speed_y_range)
    local obj = {}
    obj.pos = pos
    obj.timer = 0
    obj.lifetime_range = lifetime_range
    obj.spawn_time = spawn_time
    obj.speed_x_range = speed_x_range
    obj.speed_y_range = speed_y_range
    obj.particles = {}

    for i=1,p_amount do
        -- Create particle
        local particle = csim_particle:new(pos.x, pos.y, w, h, 0, spr)
        particle.system = obj

        -- Add rigidbody to the particle
        local rigid_body = csim_rigidbody:new(1, 1, 1)
        rigid_body.gravity_scale = gravity_scale
        particle:addComponent(rigid_body)

        table.insert(obj.particles, particle)
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function csim_particle_system:update(dt)
    self.timer = self.timer + dt
    if(self.timer > self.spawn_time) then
        self:shoot()
        self.timer = 0
    end

    for i=1,#self.particles do
        self.particles[i]:update(dt)
    end
end

function csim_particle_system:draw()
    for i=1,#self.particles do
        if(self.particles[i].is_alive) then
            love.graphics.draw(self.particles[i].spr, self.particles[i].pos.x, self.particles[i].pos.y)
        end
    end
end

function csim_particle_system:shoot()
    for i=1,#self.particles do
        if(not self.particles[i].is_alive) then
            self.particles[i]:getComponent("rigidbody").vel = csim_vector:new(0,0)
            self.particles[i].pos.x = self.pos.x
            self.particles[i].pos.y = self.pos.y

            self.particles[i]:shoot(
                love.math.random(self.lifetime_range[1], self.lifetime_range[2]),
                love.math.random(self.speed_x_range[1], self.speed_x_range[2]),
                love.math.random(self.speed_y_range[1], self.speed_y_range[2]))
            return
        end
    end
end

return csim_particle_system
