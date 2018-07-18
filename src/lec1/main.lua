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
	-- Set love's default filter to "nearest-neighbor".
	love.graphics.setDefaultFilter('nearest', 'nearest')

	-- Initialize virtual resolution
	push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})

	-- Load map created with Tiled and exported to lua format
	map = sti("", {})

	-- Load sound effects
	-- sounds = {
	-- 	['track1'] = love.audio.newSource('', 'static')
	-- }

	-- Play soundtrack in loop
	-- sounds['track1']:setLooping(true)
	-- sounds['track1']:play()
end

function love.draw()
	push:start()

	-- Draw map using sti library
	map:draw(0, 0)

	push:finish()
end
