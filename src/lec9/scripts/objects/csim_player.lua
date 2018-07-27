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

	if(love.keyboard.isDown(u)) then
        local jumpForce = csim_vector(0, -0.3)
        self:getComponent("rigidbody"):applyForce(jumpForce)
        self:getComponent("animator"):play("jump")
	end

	if( love.keyboard.isDown(d)) then
		local f = csim_vector(0, 0.3)
        self:getComponent("rigidbody"):applyForce(f)
	end
end

function csim_player:takeDamage(damage)
    self.life = self.life - damage
    if(self.life <= 0) then
        love.load()
    end
end

function csim_player:update(dt)
    csim_object.update(self, dt)

    self:move("d", "a", "w", "s")

    -- Apply resistence if is on ground
    if(self:getComponent("rigidbody").vel.y == 0) then
        self:getComponent("rigidbody"):applyFriction(0.15)
    end

    for i=1,#items do
        if(items[i] ~= nil) then
            local box_a = self:getComponent("collider"):getAABB()
            local box_b = items[i]:getComponent("collider"):getAABB()

            if(csim_math.checkBoxCollision(box_a, box_b)) then
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
