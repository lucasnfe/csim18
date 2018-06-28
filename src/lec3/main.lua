--[[
    CSIM 2018
    Lecture 3

    -- Main Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

-- Loading external libraries
local push = require "lib.push"

-- Loading CSIM libraries
csim_debug = require('scripts.csim_debug')
csim_game = require('scripts.csim_game')

-- Setting values of global variables
csim_game.game_width = 128
csim_game.game_height = 128

function love.keypressed(key, scancode, isrepeat)
	if (key == "-") then
		if (csim_debug.isShowing() == true) then
			csim_debug.hideConsole()
		else
			csim_debug.showConsole()
		end
	end

	if (key == "=") then
		if (csim_debug.isShowing() == true) then
			csim_debug.state = (csim_debug.state + 1) % 3
		end
	end
end

function love.load()
	-- Set love's default filter to "nearest-neighbor".
	love.graphics.setDefaultFilter('nearest', 'nearest')

	-- Initialize virtual resolution
	local window_width, window_height, flags = love.window.getMode()
	push:setupScreen(csim_game.game_width, csim_game.game_height, window_width, window_height, {fullscreen = false})

	-- Load Debugger
	csim_debug.init(csim_game.game_width, csim_game.game_height, 30)

	-- Load Game
	csim_game.load()
end

function love.update(dt)
	if(csim_debug.state == 0) then
		csim_game.update(dt)
	elseif (csim_debug.state == 1) then
		if (love.keyboard.isDown("]")) then
			csim_game.update(dt)
			love.timer.sleep(0.5)
		end
	elseif (csim_debug.state == 2) then
		csim_game.update(dt)
		love.timer.sleep(0.1)
	end
end

function love.draw()
	push:start()

	-- Draw game
	csim_game.draw()

	-- Draw debugger
	csim_debug.draw()

	push:finish()
end
