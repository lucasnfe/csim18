--[[
    CSIM 2018
    Lecture 7

    -- Game Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

-- Loading external libraries
local sti = require "lib.sti"

-- Loading game objects
local csim_object = require "scripts.objects.csim_object"
local csim_player = require "scripts.objects.csim_player"
local csim_enemy = require "scripts.objects.csim_enemy"

-- Loading internal libraries
local csim_math = require "scripts.csim_math"
local csim_vector = require "scripts.csim_vector"
local csim_level_parser = require "scripts.csim_level_parser"

-- Loading components
local csim_rigidbody = require "scripts.components.csim_rigidbody"
local csim_collider = require "scripts.components.csim_collider"
local csim_fsm = require "scripts.components.csim_fsm"

local csim_game = {}

function csim_game.load()
	-- Load map
	map = sti("map/lec6.lua")

	-- Load level parser
	level_parser = csim_level_parser:new(map)

	-- Load characters
	player, enemies = level_parser:loadCharacters("Characters")
	if(player == nil) then
		print("Player could not be loaded.")
		love.event.quit()
	end

	for i=1,#enemies do
		-- Adding fsms to enemies
		local states = {}
		states["move"] = csim_fsm:newState("move", enemies[i].update_move_state, enemies[i].enter_move_state, enemies[i].exit_move_state)
		local enemy_fsm = csim_fsm:new(states, "move", csim_enemy)
		enemies[i]:addComponent(enemy_fsm)
	end

	-- Load items
	items = level_parser:loadItems("Items")

	-- Load step sound
	sounds = {}
	sounds["step"]=love.audio.newSource("sounds/lec2-step.wav", "static")
	sounds["coin"]=love.audio.newSource("sounds/lec2-coin.wav", "static")
end

function csim_game.detectDynamicCollision(dynamic_objs)
	-- TODO: Check AABB collision against all dynamic objs
	-- Hint: Use a for loop and create boxes for the player and the items.
	-- csim_math.checkBoxCollision(min_a, max_a, min_b, max_b)
	local player_collider = player:getComponent("collider")
	if (not player_collider) then return end

	min_a, max_a = player_collider:createAABB()

	csim_debug.rect(min_a.x, min_a.y, player_collider.rect.w, player_collider.rect.h)

	for i=1,#dynamic_objs do
		local dynamic_collider = dynamic_objs[i]:getComponent("collider")

		if (dynamic_collider) then
			min_b, max_b = dynamic_collider:createAABB()

			csim_debug.rect(min_b.x, min_b.y, dynamic_collider.rect.w, dynamic_collider.rect.h)

			if(csim_math.checkBoxCollision(min_a, max_a, min_b, max_b)) then
				csim_debug.text("yay yay yay!")
			end
		end
	end
end

function csim_game.update(dt)
	-- Move on x axis
	if (love.keyboard.isDown('left')) then
		player:move(-1)
		love.audio.play(sounds["step"])
	elseif(love.keyboard.isDown('right')) then
		player:move(1)
		love.audio.play(sounds["step"])
	end

	-- Move on y axis
	if (love.keyboard.isDown('up') and player.is_on_ground) then
		player:jump()
		love.audio.play(sounds["step"])
	end

	if(player.is_on_ground) then
		player:getComponent("rigidbody"):applyFriction(0.25)
	end

	-- Update characters
	player:update(dt)

	for i=1,#enemies do
		enemies[i]:update(dt)
	end

	-- Detect collision against dynamic objects
	csim_game.detectDynamicCollision(items)
	csim_game.detectDynamicCollision(enemies)

	-- Camera is following the player
	csim_camera.setPosition(player.pos.x - csim_game.game_width/2, player.pos.y - csim_game.game_height/2)

	-- Set background color
	if(map.backgroundcolor) then
		love.graphics.setBackgroundColor(map.backgroundcolor[1]/255,
			map.backgroundcolor[2]/255, map.backgroundcolor[3]/255)
	end
end

function csim_game.draw()
	-- Draw map
	map:draw(-csim_camera.x, -csim_camera.y)

	-- Draw the player sprite
	love.graphics.draw(player.spr, player.pos.x, player.pos.y)

	-- Draw items
	for i=1,#items do
		love.graphics.draw(items[i].spr, items[i].pos.x, items[i].pos.y)
	end

	-- Draw enemies
	for i=1,#enemies do
		love.graphics.draw(enemies[i].spr, enemies[i].pos.x, enemies[i].pos.y)
	end
end

return csim_game
