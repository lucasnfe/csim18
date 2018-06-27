--[[
    CSIM 2018
    Lecture 2

    -- Main Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

-- Loading external libraries
local sti = require "lib.sti"
local push = require "lib.push"

-- Setting values of global variables
local gameWidth, gameHeight = 128, 128
local windowWidth, windowHeight, flags = love.window.getMode()

function distance(x1, y1, x2, y2)
	return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function love.load()

	player_x = gameWidth/2
 	player_y = gameHeight/2

	-- Set love's default filter to "nearest-neighbor".
	love.graphics.setDefaultFilter('nearest', 'nearest')

	 -- Initialize retro text font
	font = love.graphics.newFont('fonts/font.ttf', 8)
	love.graphics.setFont(font)

	-- Initialize virtual resolution
	push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})

	-- Load player sprite
	player = love.graphics.newImage("sprites/lec2-player.png")

	-- Load a coin
	local coins_amount = 10
	coins = {}

	for i=1,coins_amount do
		c = {}
		c.x = 10 + 10 * i
		c.y = 50
		c.spr = love.graphics.newImage("sprites/lec2-coin.png")
		table.insert(coins, c)
	end

	-- Load step sound
	step_sfx = love.audio.newSource("sounds/lec2-step.wav", "static")

	-- Load map
	map = sti("map/lec2.lua")
end

function love.update(dt)
	-- Move on x axis
	if (love.keyboard.isDown('left')) then
		player_x = player_x - 2
		love.audio.play(step_sfx)
	elseif(love.keyboard.isDown('right')) then
		player_x = player_x + 2
		love.audio.play(step_sfx)
	end

	-- Move on y axis
	if (love.keyboard.isDown('up')) then
		player_y = player_y - 2
		love.audio.play(step_sfx)
	elseif(love.keyboard.isDown('down')) then
		player_y = player_y + 2
		love.audio.play(step_sfx)
	end
end

function love.draw()
	push:start()

	-- Draw map
	map:draw()

	-- Draw the player sprite
	love.graphics.draw(player, player_x, player_y)

	-- Draw coins
	for i=1,#coins do
		love.graphics.draw(coins[i].spr, coins[i].x, coins[i].y)
	end

	push:finish()
end
