local csim_math = require "scripts.csim_math"
local csim_object = require "scripts.objects.csim_object"
local csim_vector = require "scripts.csim_vector"

local csim_player = class(csim_object)

function csim_player:init(x, y, spr, life)
    csim_object:init(x, y, spr)
    self.life = life
end

function csim_player:move(r, l, u, d)
	if(love.keyboard.isDown(r)) then
		self.pos.x = self.pos.x + 1
	end

	if(love.keyboard.isDown(l)) then
		self.pos.x = self.pos.x - 1
	end

	if(love.keyboard.isDown(u)) then
		-- self.pos.y = self.pos.y - 1
        local jumpForce = csim_vector(0, -0.5)
        self:getComponent("rigidbody"):applyForce(jumpForce)
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

    if(self.pos.y >= 17) then
        self:getComponent("rigidbody").vel.y = 0
        self.pos.y = 17
    end

    self:move("d", "a", "w", "s")

    for i=1,#coins do
        if(coins[i] ~= nil) then
            if(csim_math.distance(self.pos.x, self.pos.y, coins[i].pos.x, coins[i].pos.y) < 5) then
                table.remove(coins, i)
                number_coins = number_coins -1
            end
        end
    end

    if(csim_math.distance(self.pos.x, self.pos.y, enemy.pos.x, enemy.pos.y) < 5) then
        print("ouch! "..self.life)
        self.pos.x = enemy.pos.x + love.math.random(10, 12)
        self.pos.y = enemy.pos.y + love.math.random(10, 12)
        self:takeDamage(1)
    end
end

return csim_player
