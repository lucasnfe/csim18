--[[
    CSIM 2018
    Lecture 1

    -- Main Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

-- Loading external libraries
local sti = require "lib.sti"
local push = require "lib.push"

-- Setting values of global variables
local gameWidth, gameHeight = 256, 256
local windowWidth, windowHeight, flags = love.window.getMode()

function love.load()
	-- Initialize virtual resolution
	push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})

	sprite = love.graphics.newImage("map/lec3.png")

	sound = love.audio.newSource("sounds/lec3.wav", "static")
	--sound:setLooping(true)

	map = sti("map/lec3.lua")

	x_sprite = 0
	y_sprite = 0

	x_circle = 0
	y_circle = 0
	timer = 0
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
	x_circle, y_circle = move("right", "left", "up", "down", x_circle, y_circle)
	x_sprite, y_sprite = move("d", "a", "w", "s", x_sprite, y_sprite)

	love.audio.play(sound)
end

function love.draw()
	push:start()

	map:draw()

	-- Draw map using sti library
	love.graphics.circle("line", x_circle, y_circle, 20, 30)

	love.graphics.draw(sprite, x_sprite-8, y_sprite-8)

	push:finish()
end
