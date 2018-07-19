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
end

function love.update(dt)

end

function love.draw()
	push:start()

	-- Draw map using sti library
	love.graphics.circle("line", 20, 20, 5, 10)

	push:finish()
end
