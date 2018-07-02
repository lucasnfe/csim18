--[[
    CSIM 2018
    Lecture 4

    -- Game Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

-- Loading external libraries
local sti = require "lib.sti"
local csim_object = require "scripts.csim_object"
local csim_math = require "scripts.csim_math"

local csim_game = {}

function csim_game.load()
	-- Create player
	local player_x = csim_game.game_width/2
 	local player_y = csim_game.game_height/2
	local player_r = 0
	local player_spr = love.graphics.newImage("sprites/lec2-player.png")
	player = csim_object:new(player_x, player_y, player_r, player_spr)

	-- Load coins
	coins = {}

	local coins_amount = 5
	for i=1,coins_amount do
		coin_x = 30 + 10 * i
		coin_y = 50
		coin_r = 0
		coin_spr = love.graphics.newImage("sprites/lec2-coin.png")
		c = csim_object:new(coin_x, coin_y, coin_r, coin_spr)
		table.insert(coins, c)
	end

	-- Load step sound
	sounds = {}
	sounds["step"]=love.audio.newSource("sounds/lec2-step.wav", "static")
	sounds["coin"]=love.audio.newSource("sounds/lec2-coin.wav", "static")

	-- Load map
	map = sti("map/lec4.lua")
end

function csim_game.update(dt)
	-- Move on x axis
	if (love.keyboard.isDown('left')) then
		player.x = player.x - 0.5
		love.audio.play(sounds["step"])
	elseif(love.keyboard.isDown('right')) then
		player.x = player.x + 0.5
		love.audio.play(sounds["step"])
	end

	-- Move on y axis
	if (love.keyboard.isDown('up')) then
		player.y = player.y - 0.5
		love.audio.play(sounds["step"])
	elseif(love.keyboard.isDown('down')) then
		player.y = player.y + 0.5
		love.audio.play(sounds["step"])
	end

	csim_debug.rect(player.x, player.y, 8, 8)

	-- Play a sound when player is near a coin
	for i=1,#coins do
		if (coins[i] ~= nil) then
			local d_coin = csim_math.distance(player.x, player.y, coins[i].x, coins[i].y)
			if (d_coin < 4) then
				-- Play coin sfx
				love.audio.play(sounds["coin"])

				-- Destroy coin
				table.remove(coins, i)
			end
		end
	end

	csim_camera.setPosition(player.x - csim_game.game_width/2, player.y - csim_game.game_height/2)
end

function csim_game.draw()
	-- Draw map
	map:draw(-csim_camera.x, -csim_camera.y)

	-- Draw the player sprite
	love.graphics.draw(player.spr, player.x, player.y)

	-- Draw coins
	for i=1,#coins do
		love.graphics.draw(coins[i].spr, coins[i].x, coins[i].y)
	end
end

return csim_game
