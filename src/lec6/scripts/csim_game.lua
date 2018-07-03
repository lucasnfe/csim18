--[[
    CSIM 2018
    Lecture 4

    -- Game Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

-- Loading external libraries
local sti = require "lib.sti"
local csim_object = require "scripts.csim_object"
local csim_math = require "scripts.csim_math"

-- Loading components
local csim_rigidbody = require "scripts.components.csim_rigidbody"
local csim_collider = require "scripts.components.csim_collider"

local csim_game = {}

function csim_game.load()
	-- Load map
	map = sti("map/lec6.lua")

	-- Load characters
	player, enemies = csim_game.loadCharacters()

	-- Load items
	items = csim_game.loadItems()

	-- Create rigid body
	local player_rigid_body = csim_rigidbody:new(1)
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
					player = csim_object:new(screen_y, screen_x, 0, spr)
					player.rect = {}
					player.rect.x = map_data[y][x].properties["x"]
					player.rect.y = map_data[y][x].properties["y"]
					player.rect.w = map_data[y][x].properties["w"]
					player.rect.h = map_data[y][x].properties["h"]
				else
					enemy = csim_object:new(screen_y, screen_x, 0, spr)
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
				table.insert(items, item)
			end
		end
	end

	map:removeLayer("Items")
	return items
end

function csim_game.update(dt)
	-- Move on x axis
	if (love.keyboard.isDown('left')) then
		player.pos.x = player.pos.x - 5
		love.audio.play(sounds["step"])
	elseif(love.keyboard.isDown('right')) then
		player.pos.x = player.pos.x + 5
		love.audio.play(sounds["step"])
	end

	-- Move on y axis
	if (love.keyboard.isDown('up')) then
		player.pos.y = player.pos.y - 5
		love.audio.play(sounds["step"])
	elseif(love.keyboard.isDown('down')) then
		player.pos.y = player.pos.y + 5
		love.audio.play(sounds["step"])
	end

	player:update(dt)

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
