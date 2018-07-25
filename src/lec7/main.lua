--[[
    CSIM 2018

    -- Main Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

-- Loading external libraries
local sti = require "lib.sti"
local push = require "lib.push"
local class = require "lib.class"

-- Loading objects
local csim_object = require "scripts.objects.csim_object"
local csim_enemy = require "scripts.objects.csim_enemy"
local csim_player = require "scripts.objects.csim_player"
local csim_camera = require "scripts.csim_camera"

-- Importing components
local csim_rigidbody = require "scripts.components.csim_rigidbody"

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
	player = csim_player(0, 0, sprite, 10)
	local rigidBody = csim_rigidbody()
	player:addComponent(rigidBody)

	sound = love.audio.newSource("sounds/lec7.wav", "static")
	--sound:setLooping(true)

	-- Loading coins
	coins = {}
	number_coins = love.math.random(10, 100)

	local sprite  = love.graphics.newImage("sprites/coin.png")

	for i=1,number_coins do
		local random_x = love.math.random(0, gameWidth)
		local random_y = love.math.random(0, gameHeight)
		local c = csim_object(random_x, random_y, sprite)

		table.insert(coins, c)
	end

	-- Load enemy
	local sprite = love.graphics.newImage("sprites/enemy.png")
	enemy = csim_enemy(gameWidth/2, gameHeight/2, sprite)

	-- Load Camera
	camera = csim_camera(0, 0)

	map = sti("map/lec7.lua")
end

function love.update(dt)
	player:update(dt)

	camera:setPosition(player.pos.x - gameWidth/2, player.pos.y - gameHeight/2)

	enemy:update(dt)
end

function drawGame()
	map:draw(-player.pos.x, -player.pos.y)

	-- Draw the player
	player:draw()

	-- Draw the enemy
	enemy:draw()

	-- Draw the coins
	for i=1,#coins do
		coins[i]:draw()
	end

	-- Draw the number of coins
	love.graphics.print(number_coins, gameWidth - 20, 20)
end

function love.draw()
	push:start()

	-- Enable camera
	camera:start()

	drawGame()

	-- Disable camera
	camera:finish()

	push:finish()
end
