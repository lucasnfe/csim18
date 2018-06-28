--[[
    CSIM 2018
    Lecture 3

    -- Game Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

-- Loading external libraries
local sti = require "lib.sti"
local csim_math = require "scripts.csim_math"

local csim_game = {}

function csim_game.load()
	player_x = csim_game.game_width/2
 	player_y = csim_game.game_height/2

	-- Load player sprite
	player = love.graphics.newImage("sprites/lec2-player.png")

	-- Load coins
	coins = {}

	local coins_amount = 10
	for i=1,coins_amount do
		c = {}
		c.x = 10 + 10 * i
		c.y = 50
		c.spr = love.graphics.newImage("sprites/lec2-coin.png")
		table.insert(coins, c)
	end

	-- Load step sound
	sounds = {}
	sounds["step"]=love.audio.newSource("sounds/lec2-step.wav", "static")
	sounds["coin"]=love.audio.newSource("sounds/lec2-coin.wav", "static")

	-- Load map
	map = sti("map/lec2.lua")
end

function csim_game.update(dt)
	-- Move on x axis
	if (love.keyboard.isDown('left')) then
		player_x = player_x - 0.5
		love.audio.play(sounds["step"])
	elseif(love.keyboard.isDown('right')) then
		player_x = player_x + 0.5
		love.audio.play(sounds["step"])
	end

	-- Move on y axis
	if (love.keyboard.isDown('up')) then
		player_y = player_y - 0.5
		love.audio.play(sounds["step"])
	elseif(love.keyboard.isDown('down')) then
		player_y = player_y + 0.5
		love.audio.play(sounds["step"])
	end

	-- Play a sound when player is near a coin
	for i=1,#coins do
		local d_coin = csim_math.distance(player_x, player_y, coins[i].x, coins[i].y)
		if (d_coin < 4) then
			love.audio.play(sounds["coin"])
		end
	end
end

function csim_game.draw()
	-- Draw map
	map:draw()

	-- Draw the player sprite
	love.graphics.draw(player, player_x, player_y)

	-- Draw coins
	for i=1,#coins do
		love.graphics.draw(coins[i].spr, coins[i].x, coins[i].y)
	end
end

return csim_game
