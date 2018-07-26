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
		self.pos.x = self.pos.x + 1
        self.dir = 1
        if(self:getComponent("rigidbody").vel.y == 0) then
            self:getComponent("animator"):play("move")
        end
    elseif(love.keyboard.isDown(l)) then
		self.pos.x = self.pos.x - 1
        self.dir = -1
        if(self:getComponent("rigidbody").vel.y == 0) then
            self:getComponent("animator"):play("move")
        end
    elseif(self:getComponent("rigidbody").vel.y == 0) then
        self:getComponent("animator"):play("idle")
	end

	if(love.keyboard.isDown(u)) then
		-- self.pos.y = self.pos.y - 1
        local jumpForce = csim_vector(0, -0.5)
        self:getComponent("rigidbody"):applyForce(jumpForce)
        self:getComponent("animator"):play("jump")
	end

	if( love.keyboard.isDown(d)) then
		self.pos.y = self.pos.y + 1
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

    -- Stop player when it hits the ground
    if(self.pos.y >= 10*8) then
        self:getComponent("rigidbody").vel.y = 0
        self.pos.y = 10*8
    end

    self:move("d", "a", "w", "s")

    for i=1,#items do
        if(items[i] ~= nil) then
            if(csim_math.distance(self.pos.x, self.pos.y, items[i].pos.x, items[i].pos.y) < 5) then
                table.remove(items, i)
            end
        end
    end

    for i=1,#enemies do
        if(enemies[i] ~= nil) then
            if(csim_math.distance(self.pos.x, self.pos.y, enemies[i].pos.x, enemies[i].pos.y) < 5) then
                print("ouch! "..self.life)
                if(self.pos.x > enemies[i].pos.x) then
                    self.pos.x = enemies[i].pos.x + love.math.random(12, 16)
                else
                    self.pos.x = enemies[i].pos.x - love.math.random(12, 16)
                end
                self:takeDamage(1)
            end
        end
    end
end

return csim_player
