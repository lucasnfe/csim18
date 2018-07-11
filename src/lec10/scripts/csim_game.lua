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
local csim_particle_system = require "scripts.csim_particle_system"

-- Loading components
local csim_rigidbody = require "scripts.components.csim_rigidbody"
local csim_collider = require "scripts.components.csim_collider"
local csim_fsm = require "scripts.components.csim_fsm"
local csim_animator = require "scripts.components.csim_animator"
local csim_pathfinder = require "scripts.components.csim_pathfinder"

local csim_game = {}

function csim_game.load()
	csim_hud.collected_coins = 0

	-- Load map
	map = sti("map/lec10.lua")

	-- Load characters
	player, enemies = csim_game.loadCharacters()

	-- Create player rigid body
	local player_rigid_body = csim_rigidbody:new(1, 1, 1)
	player_rigid_body.gravity_scale = 0
	player:addComponent(player_rigid_body)

	-- Create player collider
	local player_collider = csim_collider:new(map, player.rect)
	player:addComponent(player_collider)

	-- Create player animator
	local player_animator = csim_animator:new(player.spr, 32, 32)
	player_animator:addClip("move", {1}, 3, true)
	player_animator:addClip("idle", {1,2,3,4,5,6}, 4, true)
	player:addComponent(player_animator)
	player:getComponent("animator"):play("idle")

	for i=1,#enemies do
		-- Adding collider to enemies
		local enemy_collider = csim_collider:new(map, enemies[i].rect)
		enemies[i]:addComponent(enemy_collider)

		-- Adding rigid body to enemies
		local rigid_body = csim_rigidbody:new(1, 1, 1)
		rigid_body.gravity_scale = 0
		enemies[i]:addComponent(rigid_body)

		-- Adding animator to enemy
		local enemy_animator = csim_animator:new(enemies[i].spr, 32, 32)
		enemy_animator:addClip("idle", {7,8,9,10,11,12}, 4, true)
		enemy_animator:addClip("move", {7,8,9,10,11,12}, 4, true)
		enemies[i]:addComponent(enemy_animator)

		-- Adding pathfinder to enemy
		local enemy_pathfinder = csim_pathfinder:new(map)
		enemies[i]:addComponent(enemy_pathfinder)

		-- Adding fsm to enemies
		local states = {}
		states["move"] = csim_fsm:newState("move", enemies[i].update_move_state, enemies[i].enter_move_state, enemies[i].exit_move_state)
		states["idle"] = csim_fsm:newState("idle", enemies[i].update_idle_state, enemies[i].enter_idle_state, enemies[i].exit_idle_state)
		local enemy_fsm = csim_fsm:new(states, "move")
		enemies[i]:addComponent(enemy_fsm)
	end

	-- Load items
	items = csim_game.loadItems()

	-- Adding collider to coins
	for i=1,#items do
		local item_collider = csim_collider:new(map, items[i].rect)
		items[i]:addComponent(item_collider)

		local animator = csim_animator:new(items[i].spr, 32, 32)
		animator:addClip("idle", {20}, 1, true)
		items[i]:addComponent(animator)
		items[i]:getComponent("animator"):play("idle")
	end

	-- Load Particle system
	-- local p_sprite = love.graphics.newImage("sprites/particles/fireball.png")
	-- local gravity_scale = 0
	-- local spawn_time = 0.1
	-- local lifetime_range = {2, 3}
	-- local speed_x_range = {-2, 2}
	-- local speed_y_range = {-7, -8}
	-- local width = 32
	-- local height = 32
	-- local pos = csim_vector:new(64*2, csim_game.game_height+50)
	-- particle_system = csim_particle_system:new(30, pos, p_sprite, width, height, gravity_scale, spawn_time, lifetime_range, speed_x_range, speed_y_range)

	-- Load step sound
	sounds = {}
	sounds["step"] = love.audio.newSource("sounds/lec2-step.wav", "static")
	sounds["coin"] = love.audio.newSource("sounds/lec2-coin.wav", "static")
	sounds["soundtrack"] = love.audio.newSource("sounds/soundtrack.mp3", "static")

	-- Play soundtrack in loop
	sounds['soundtrack']:setLooping(true)
	sounds['soundtrack']:play()
end

function csim_game.loadCharacters()
	local player = nil
	local enemies = {}

	if(not map.layers["Characters"]) then
		return player, enemies
	end

	local width = map.layers["Characters"].width
	local height = map.layers["Characters"].height
	local map_data = map.layers["Characters"].data

	for x=1,width do
		for y=1,height do
			if map_data[y] and map_data[y][x] then
				if(map_data[y][x].properties["sprite"]) then
					local spr = love.graphics.newImage(map_data[y][x].properties["sprite"])
					screen_x, screen_y = map:convertTileToPixel(y - 1, x - 1)

					if(map_data[y][x].properties["isPlayer"]) then
						player = csim_player:new(screen_y, screen_x, map.tilewidth, map.tileheight, 0, spr)
						player.rect = {}
						player.rect.x = map_data[y][x].properties["x"]
						player.rect.y = map_data[y][x].properties["y"]
						player.rect.w = map_data[y][x].properties["w"]
						player.rect.h = map_data[y][x].properties["h"]
					else
						local enemy = csim_enemy:new(screen_y, screen_x, map.tilewidth, map.tileheight, 0, spr)
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
	end

	map:removeLayer("Characters")
	return player, enemies
end

function csim_game.loadItems()
	local items = {}

	if(not map.layers["Items"]) then
		return items
	end

	local width = map.layers["Items"].width
	local height = map.layers["Items"].height
	local map_data = map.layers["Items"].data

	for x=1,width do
		for y=1,height do
			if map_data[y] and map_data[y][x] then
				if(map_data[y][x].properties["sprite"]) then
					local spr = love.graphics.newImage(map_data[y][x].properties["sprite"])
					screen_x, screen_y = map:convertTileToPixel(y - 1, x - 1)

					local item = csim_object:new(screen_y, screen_x, map.tilewidth, map.tileheight, 0, spr)

					item.rect = {}
					item.rect.x = map_data[y][x].properties["x"]
					item.rect.y = map_data[y][x].properties["y"]
					item.rect.w = map_data[y][x].properties["w"]
					item.rect.h = map_data[y][x].properties["h"]

					table.insert(items, item)
				end
			end
		end
	end

	map:removeLayer("Items")
	return items
end

function csim_game.detectDynamicCollision(dynamic_objs, obj_type)
	-- TODO: Check AABB collision against all dynamic objs
	-- Hint: Use a for loop and create boxes for the player and the items.
	-- csim_math.checkBoxCollision(min_a, max_a, min_b, max_b)
	local player_collider = player:getComponent("collider")
	min_a, max_a = player_collider:createAABB()

	csim_debug.rect(min_a.x, min_a.y, player_collider.rect.w, player_collider.rect.h)

	for i=1,#dynamic_objs do
		if(dynamic_objs[i] ~= nil) then
			local obj_collider = dynamic_objs[i]:getComponent("collider")
			min_b, max_b = obj_collider:createAABB()

			csim_debug.rect(min_b.x, min_b.y, obj_collider.rect.w, obj_collider.rect.h)

			if(csim_math.checkBoxCollision(min_a, max_a, min_b, max_b)) then
				-- Destroy item after a collision
				if(obj_type == "items") then
					table.remove(dynamic_objs, i)
					love.audio.play(sounds["coin"])
					csim_hud.collected_coins = csim_hud.collected_coins + 1
				elseif(obj_type == "enemies") then
					love.audio.stop()
					csim_game:load()
				end
			end
		end
	end
end

function csim_game.update(dt)
	if(player) then
		local player_animator = player:getComponent("animator")

		-- Move on x axis
		if (love.keyboard.isDown('left')) then
			player:move_x(-1)
			love.audio.play(sounds["step"])
		elseif(love.keyboard.isDown('right')) then
			player:move_x(1)
			love.audio.play(sounds["step"])
		end

		-- Move on y axis
		if (love.keyboard.isDown('up')) then
			player:move_y(-1)
			love.audio.play(sounds["step"])
		elseif(love.keyboard.isDown('down')) then
			player:move_y(1)
			love.audio.play(sounds["step"])
		end

		player:update(dt)

		local player_rigid_body = player:getComponent("rigidbody")

		-- TODO: Apply friction
		player_rigid_body:applyFriction(0.25)

		csim_game.detectDynamicCollision(items, "items")
		csim_game.detectDynamicCollision(enemies, "enemies")

		-- Camera is following the player
		csim_camera.setPosition(0, player.pos.y - csim_game.game_height/2)

		-- Lock the camera
		csim_camera.y = csim_math.clamp(csim_camera.y, 0, csim_game.game_height/4)
	end

	for i=1,#enemies do
		enemies[i]:update(dt)
	end

	for i=1,#items do
		items[i]:update(dt)
	end

	-- particle_system:update(dt)

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
	player:draw()

	-- Draw items
	for i=1,#items do
		items[i]:draw()
	end

	-- Draw enemies
	for i=1,#enemies do
		enemies[i]:draw()
	end

	-- particle_system:draw()
end

return csim_game
