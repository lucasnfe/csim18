--[[
    CSIM 2018

    -- Main Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

-- Loading external libraries
local sti = require "lib.sti"
local push = require "lib.push"

require "lib.class"

-- Loading objects
local csim_object = require "scripts.csim_object"

-- Setting values of global variables
local gameWidth, gameHeight = 128, 128
local windowWidth, windowHeight, flags = love.window.getMode()

function distance(x1,y1,x2,y2)
	return math.sqrt((x1-x2)^2 + (y1-y2)^2)
end

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	-- Initialize virtual resolution
	push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})

	-- Creating a table to represent the player with three variables: sprite, x and y
	local sprite = love.graphics.newImage("sprites/player.png")
	player = csim_object(0, 0, sprite)

	player.x = 0
	player.y = 0
	player.life = 10
	player.takeDamage = function(damage)
		player.life = player.life - damage
		if(player.life <= 0) then
			love.load()
		end
	end

	sound = love.audio.newSource("sounds/lec6.wav", "static")
	--sound:setLooping(true)

	-- Loading coins
	coins = {}
	number_coins = love.math.random(10, 100)

	for i=1,number_coins do
		local c = {}
		c.x = love.math.random(0, gameWidth)
		c.y = love.math.random(0, gameHeight)
		c.sprite = love.graphics.newImage("sprites/coin.png")

		table.insert(coins, c)	 -- coins[i] = c
	end

	-- Load enemy
	enemy = {}
	enemy.x = gameWidth/2
	enemy.y = gameHeight/2
	enemy.sprite = love.graphics.newImage("sprites/enemy.png")

	map = sti("map/lec6.lua")
end

function move(r, l, u, d, x, y)
	if( love.keyboard.isDown(r) ) then
		x = x + 1
	end

	if( love.keyboard.isDown(l) ) then
		x = x - 1
	end

	if( love.keyboard.isDown(u) ) then
		y = y - 1
	end

	if( love.keyboard.isDown(d) ) then
		y = y + 1
	end

	return x,y
end

function love.update(dt)
	player.x, player.y = move("d", "a", "w", "s", player.x, player.y)

	love.audio.play(sound)

	for i=1,#coins do
		if(coins[i] ~= nil) then

			if( distance(player.x, player.y, coins[i].x, coins[i].y) < 5 ) then
				table.remove(coins, i)
				number_coins = number_coins -1
			end

		end
	end

	if( distance(player.x, player.y, enemy.x, enemy.y) < 5 ) then
		print("ouch! "..player.life)
		player.x = enemy.x + love.math.random(10, 12)
		player.y = enemy.y + love.math.random(10, 12)
		player.takeDamage(1)
	end
end

function love.draw()
	push:start()

	map:draw()

	-- Draw the player
	love.graphics.draw(player.spr, player.x, player.y)

	-- Draw the coins
	for i=1,#coins do
		love.graphics.draw(coins[i].sprite, coins[i].x, coins[i].y)
	end

	-- Draw the number of coins
	love.graphics.print(number_coins, gameWidth - 20, 20)

	-- Draw the enemy
	love.graphics.draw(enemy.sprite, enemy.x, enemy.y)

	push:finish()
end
