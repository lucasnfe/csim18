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

function love.load()
	-- Set love's default filter to "nearest-neighbor".
	love.graphics.setDefaultFilter('nearest', 'nearest')

	 -- Initialize retro text font
	font = love.graphics.newFont('fonts/font.ttf', 8)
	love.graphics.setFont(font)

	-- Initialize virtual resolution
	push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})

	-- Load player as a table
	player = {}
	player.pos_x = gameWidth/2
	player.pos_y = gameHeight/2
	player.speed = 25
	player.spr = love.graphics.newImage("sprites/lec2-player.png")

	-- Load coins
	coins = {}

	for i=1,5 do
		coin = {}
		coin.pos_x = 30 + i * 10
		coin.pos_y = 50
		coin.spr = love.graphics.newImage("sprites/lec2-coin.png")
		table.insert(coins, coin)
	end

	-- Load sound effects
	sounds = {}
	sounds['player-step'] = love.audio.newSource('sounds/lec2-step.wav', 'static')

	-- Load map
	map = sti("map/lec2.lua")
end

function love.update(dt)
	-- Move player with keyboard
	if love.keyboard.isDown('left') then
		player.pos_x = player.pos_x - player.speed * dt
		love.audio.play(sounds['player-step'])
	elseif love.keyboard.isDown('right') then
		player.pos_x = player.pos_x + player.speed * dt
		love.audio.play(sounds['player-step'])
	elseif love.keyboard.isDown('up') then
		player.pos_y = player.pos_y - player.speed * dt
		love.audio.play(sounds['player-step'])
	elseif love.keyboard.isDown('down') then
		player.pos_y = player.pos_y + player.speed * dt
		love.audio.play(sounds['player-step'])
	end
end

function love.draw()
	push:start()

	-- Draw map using sti library
	map:draw()

	-- Draw player
	love.graphics.draw(player.spr, player.pos_x, player.pos_y)

	-- Draw all coins
	for i=1,#coins do
		love.graphics.draw(coins[i].spr, coins[i].pos_x, coins[i].pos_y)
	end

	push:finish()
end
