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

-- Loading components
local csim_rigidbody = require "scripts.components.csim_rigidbody"
local csim_collider = require "scripts.components.csim_collider"
local csim_fsm = require "scripts.components.csim_fsm"

local csim_game = {}

function csim_game.load()
	-- Load map
	map = sti("map/lec6.lua")

	-- Load characters
	player, enemies = csim_game.loadCharacters()

	for i=1,#enemies do
		-- Adding collider to enemies
		local enemy_collider = csim_collider:new(map, enemies[i].rect)
		enemies[i]:addComponent(enemy_collider)

		-- Adding rigidbody to enemies
		local enemy_rigid_body = csim_rigidbody:new(1, 1, 12)
		enemies[i]:addComponent(enemy_rigid_body)

		-- Adding fsms to enemies
		local states = {}
		states["move"] = csim_fsm:newState("move", enemies[i].update_move_state, enemies[i].enter_move_state, enemies[i].exit_move_state)

		local enemy_fsm = csim_fsm:new(states, "move", csim_enemy)
		enemies[i]:addComponent(enemy_fsm)
	end

	-- Load items
	items = csim_game.loadItems()

	-- Adding collider to coins
	for i=1,#items do
		local item_collider = csim_collider:new(map, items[i].rect)
		items[i]:addComponent(item_collider)
	end

	-- Create rigid body
	local player_rigid_body = csim_rigidbody:new(1, 1, 12)
	player:addComponent(player_rigid_body)

	-- Create collider
	local player_collider = csim_collider:new(map, player.rect)
	player:addComponent(player_collider)

	-- Load step sound
	sounds = {}
	sounds["step"]=love.audio.newSource("sounds/lec2-step.wav", "static")
	sounds["coin"]=love.audio.newSource("sounds/lec2-coin.wav", "static")
end

function csim_game.loadCharacters()
	local player = nil
	local enemies = {}

	local width = map.layers["Characters"].width
	local height = map.layers["Characters"].height
	local map_data = map.layers["Characters"].data

	for x=1,width do
		for y=1,height do
			if map_data[y] and map_data[y][x] then
				local spr = love.graphics.newImage(map_data[y][x].properties["sprite"])
				screen_x, screen_y = map:convertTileToPixel(y - 1, x - 1)

				if(map_data[y][x].properties["isPlayer"]) then
					player = csim_player:new(screen_y, screen_x, 0, spr)
					player.rect = {}
					player.rect.x = map_data[y][x].properties["x"]
					player.rect.y = map_data[y][x].properties["y"]
					player.rect.w = map_data[y][x].properties["w"]
					player.rect.h = map_data[y][x].properties["h"]
				else
					local enemy = csim_enemy:new(screen_y, screen_x, 0, spr)

					enemy.rect = {}
					enemy.rect.x = map_data[y][x].properties["x"]
					enemy.rect.y = map_data[y][x].properties["y"]
					enemy.rect.w = map_data[y][x].properties["w"]
					enemy.rect.h = map_data[y][x].properties["h"]

					table.insert(enemies, enemy)
				end
			end
		end
	end

	map:removeLayer("Characters")
	return player, enemies
end

function csim_game.loadItems()
	local items = {}

	local width = map.layers["Items"].width
	local height = map.layers["Items"].height
	local map_data = map.layers["Items"].data

	for x=1,width do
		for y=1,height do
			if map_data[y] and map_data[y][x] then
				local spr = love.graphics.newImage(map_data[y][x].properties["sprite"])
				screen_x, screen_y = map:convertTileToPixel(y - 1, x - 1)

				local item = csim_object:new(screen_y, screen_x, 0, spr)

				item.rect = {}
				item.rect.x = map_data[y][x].properties["x"]
				item.rect.y = map_data[y][x].properties["y"]
				item.rect.w = map_data[y][x].properties["w"]
				item.rect.h = map_data[y][x].properties["h"]

				table.insert(items, item)
			end
		end
	end

	map:removeLayer("Items")
	return items
end

function csim_game.detectDynamicCollision(dynamic_objs)
	-- TODO: Check AABB collision against all dynamic objs
	-- Hint: Use a for loop and create boxes for the player and the items.
	-- csim_math.checkBoxCollision(min_a, max_a, min_b, max_b)
	local player_collider = player:getComponent("collider")
	min_a, max_a = player_collider:createAABB()

	csim_debug.rect(min_a.x, min_a.y, player_collider.rect.w, player_collider.rect.h)

	for i=1,#dynamic_objs do
		local enemy_collider = dynamic_objs[i]:getComponent("collider")
		min_b, max_b = enemy_collider:createAABB()

		csim_debug.rect(min_b.x, min_b.y, enemy_collider.rect.w, enemy_collider.rect.h)

		if(csim_math.checkBoxCollision(min_a, max_a, min_b, max_b)) then
			csim_debug.text("yay yay yay!")
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
	love.graphics.setBackgroundColor(map.backgroundcolor[1]/255,
		map.backgroundcolor[2]/255, map.backgroundcolor[3]/255)
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
