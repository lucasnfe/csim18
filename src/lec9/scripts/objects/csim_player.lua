--[[
    CSIM 2018

    -- Player program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_math = require "scripts.csim_math"
local csim_vector = require "scripts.csim_vector"

local csim_object = require "scripts.objects.csim_object"

local csim_player = class(csim_object)

function csim_player:init(x, y, w, h, r, spr, life)
    csim_object:init(x, y, w, h, r, spr)
    self.life = life or 1
    self.is_on_ground = false
    self.is_in_water = false
end

function csim_player:move(r, l, u, d)
	if(love.keyboard.isDown(r)) then
        local f = csim_vector(0.2, 0)
        self:getComponent("rigidbody"):applyForce(f)

        -- Play move animation
        self.dir = 1
        if(self:getComponent("rigidbody").vel.y == 0) then
            self:getComponent("animator"):play("move")
        end
    elseif(love.keyboard.isDown(l)) then
        local f = csim_vector(-0.2, 0)
        self:getComponent("rigidbody"):applyForce(f)

        -- Play move animation
        self.dir = -1
        if(self:getComponent("rigidbody").vel.y == 0) then
            self:getComponent("animator"):play("move")
        end
    elseif(self:getComponent("rigidbody").vel.y == 0) then
        self:getComponent("animator"):play("idle")
	end

	if(love.keyboard.isDown(u) and self.is_on_ground) then
        local f = csim_vector(0, -2)
        if (self.is_in_water) then
            f = csim_vector(0, -0.8)
        end

        self:getComponent("rigidbody"):applyForce(f)

        self:getComponent("animator"):play("jump")
        self.is_on_ground = false
	end

	if( love.keyboard.isDown(d)) then
		local f = csim_vector(0, 0.1)
        self:getComponent("rigidbody"):applyForce(f)
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
        self.is_on_ground = true
        self.is_in_water = true
    end
end

function csim_player:onHorizontalTriggerCollision(tile, vert_side)
    if(tile.id == 2) then
        print("Im in water")
        self.is_on_ground = true
        self.is_in_water = true
    end
end

function csim_player:update(dt)
    csim_object.update(self, dt)

    self:move("d", "a", "w", "s")

    if(self.is_on_ground) then
        -- Apply friction if is on ground
        self:getComponent("rigidbody"):applyFriction(0.15)
    else
        if(not self.is_on_water) then
            -- Apply air resistance on the horizontal axis only if is in the air
            self:getComponent("rigidbody"):applyResistance(0.1, true)
        else
            -- Apply water resistance if is in the air
            self:getComponent("rigidbody"):applyResistance(0.5)
        end
    end

    self.is_in_water = false

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
                print("Collide!")

                -- Take damage
                -- self:takeDamage(1)
            end
        end
    end
end

return csim_player
