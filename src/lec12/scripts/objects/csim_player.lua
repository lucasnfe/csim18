--[[
    CSIM 2018

    -- Player program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_math = require "scripts.csim_math"
local csim_vector = require "scripts.csim_vector"

local csim_object = require "scripts.objects.csim_object"
local csim_animator = require "scripts.components.csim_animator"
local csim_psystem = require "scripts.components.csim_psystem"

local csim_player = class(csim_object)

function csim_player:init(x, y, w, h, r, spr, life)
    csim_object:init(x, y, w, h, r, spr)

    self.life = life or 1
    self.is_on_ground = false
    self.is_in_water = false
end

function csim_player:load()
    -- Add animator to player
    local animator = csim_animator(self.spr, self.width, self.height)
    animator:addClip("idle", {1}, 1, true)
    animator:addClip("move", {1,2,3,4,5}, 6, true)
    animator:addClip("jump", {3}, 1, true)
    self:addComponent(animator)

    -- Add particle system to player
    local p_system = csim_psystem(4, 1, 30, {1,1})
    self:addComponent(p_system)

    self:getComponent("rigidbody").apply_gravity = 0
end

function csim_player:move(r, l, u, d)
	if(love.keyboard.isDown(r)) then
        self:getComponent("rigidbody").vel.x = 1

        -- Play move animation
        self.dir = 1
        self:getComponent("animator"):play("move")
    elseif(love.keyboard.isDown(l)) then
        self:getComponent("rigidbody").vel.x = -1

        -- Play move animation
        self.dir = -1
        self:getComponent("animator"):play("move")
	end

	if(love.keyboard.isDown(u)) then
        self:getComponent("rigidbody").vel.y = -1
        self:getComponent("animator"):play("move")
    elseif( love.keyboard.isDown(d)) then
        self:getComponent("rigidbody").vel.y = 1
        self:getComponent("animator"):play("move")
	end
end

function csim_player:takeDamage(damage)
    self.life = self.life - damage
    if(self.life <= 0) then
        love.load()
    end
end

function csim_player:onVerticalCollision(tile, vert_side)
    if(vert_side == 1) then
        self.is_on_ground = true
    end
end

function csim_player:onHorizontalCollision(tile, hor_side)
    if(hor_side == 1) then
        print("right")
    elseif(hor_side == -1) then
        print("left")
    end
end

function csim_player:onVerticalTriggerCollision(tile, vert_side)
    if(tile.id == 2) then
        print("Im in water")
        self.is_in_water = true
    end
end

function csim_player:onHorizontalTriggerCollision(tile, vert_side)
    if(tile.id == 2) then
        print("Im in water")
        self.is_in_water = true
    end
end

function csim_player:shoot(shoot_key)
    if(love.keyboard.isDown(shoot_key)) then
        local f = csim_vector(5 * self.dir, love.math.random(-1, 1))
        self:getComponent("psystem"):shoot(f)
    end
end

function csim_player:update(dt)
    csim_object.update(self, dt)

    self:move("right", "left", "up", "down")
    if(self:getComponent("rigidbody").vel:mag() < 0.1) then
        self:getComponent("animator"):play("idle")
    end

    self:shoot("x")

    self:getComponent("rigidbody"):applyFriction(0.25)

    for i=1,#items do
        if(items[i] ~= nil) then
            local box_a = self:getComponent("collider"):getAABB()
            local box_b = items[i]:getComponent("collider"):getAABB()

            if(csim_math.checkBoxCollision(box_a, box_b)) then
                -- Collect coin
                table.remove(items, i)
            end
        end
    end

    for i=1,#enemies do
        if(enemies[i] ~= nil) then
            local box_a = self:getComponent("collider"):getAABB()
            local box_b = enemies[i]:getComponent("collider"):getAABB()

            if(csim_math.checkBoxCollision(box_a, box_b)) then
                -- Take damage
                -- self:takeDamage(1)
            end
        end
    end
end

return csim_player
