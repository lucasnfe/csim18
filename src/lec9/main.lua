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

-- Loading components
local csim_rigidbody = require "scripts.components.csim_rigidbody"
local csim_animator = require "scripts.components.csim_animator"

-- Loading CSIM libraries
local csim_math = require "scripts.csim_math"
local csim_camera = require "scripts.csim_camera"
local csim_level_parser = require "scripts.csim_level_parser"

-- Setting values of global variables
local gameWidth, gameHeight = 128, 128

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	-- Initialize virtual resolution
	local windowWidth, windowHeight, flags = love.window.getMode()
	push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})

	-- Load the map
	map = sti("map/lec9.lua")

	-- Load level parser
	level_parser = csim_level_parser(map)

	-- Load characters
	player, enemies = level_parser:loadCharacters("Characters")
	local sprite = love.graphics.newImage("sprites/player.png")
	local animator = csim_animator(sprite, 8, 8)
	animator:addClip("idle", {1}, 1, true)
	animator:addClip("move", {1,2,3,4,5}, 6, true)
	animator:addClip("jump", {3}, 1, true)
	player:addComponent(animator)

	-- Load items
	items = level_parser:loadItems("Items")

	sound = love.audio.newSource("sounds/lec9.wav", "static")
	sound:setLooping(true)
	sound:play()

	-- Load Camera
	camera = csim_camera(0, 0)
end

function love.update(dt)
	if(player) then
		player:update(dt)

		camera:setPosition(player.pos.x - gameWidth/2, player.pos.y - gameHeight/2)
		camera.x = csim_math.clamp(camera.x, 0, map.tilewidth*map.width)
		camera.y = csim_math.clamp(camera.y, 0, 0)
	end

	for i=1,#enemies do
		enemies[i]:update(dt)
	end

	if(map.backgroundcolor) then
		love.graphics.setBackgroundColor(map.backgroundcolor[1]/255,
			map.backgroundcolor[2]/255, map.backgroundcolor[3]/255)
	end
end

function drawGame()
	map:draw(-camera.x, -camera.y)

	-- Draw the player
	if(player) then
		player:draw()
	end

	-- Draw the enemies
	for i=1,#enemies do
		enemies[i]:draw()
	end

	-- Draw the coins
	for i=1,#items do
		items[i]:draw()
	end
end

function love.draw()
	push:start()

	-- Enable camera
	camera:start()

	drawGame()

	-- Disable camera
	camera:finish()

	-- Draw the number of coins
	love.graphics.print(#items, gameWidth - 8, 0)

	push:finish()
end
