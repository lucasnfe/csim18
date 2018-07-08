--[[
    CSIM 2018
    Lecture 8

    -- Level Parser Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_level_parser = class()

local csim_object = require "scripts.objects.csim_object"
local csim_player = require "scripts.objects.csim_player"
local csim_enemy = require "scripts.objects.csim_enemy"

local csim_collider = require "scripts.components.csim_collider"
local csim_rigidbody = require "scripts.components.csim_rigidbody"

function csim_level_parser:init(map)
    self.map = map
end

function csim_level_parser:loadCharacters(characters_layer)
	local player = nil
	local enemies = {}

    if(not map.layers[characters_layer]) then
        print("Characters Layer '"..characters_layer.."' does not exist in the level.")
        map:removeLayer(characters_layer)
        return player, enemies
    end

	local width = self.map.layers[characters_layer].width
	local height = self.map.layers[characters_layer].height
	local map_data = self.map.layers[characters_layer].data

	for x=1,width do
		for y=1,height do
			if map_data[y] and map_data[y][x] and map_data[y][x].properties["sprite"] then
				local spr = love.graphics.newImage(map_data[y][x].properties["sprite"])
				screen_x, screen_y = self.map:convertTileToPixel(y - 1, x - 1)

				if(map_data[y][x].objectGroup and map_data[y][x].objectGroup.objects[1].type == "Player") then
					player = csim_player(screen_y, screen_x, 0, spr)
                    if(map_data[y][x].objectGroup.objects[1].shape == "rectangle") then
                        self:loadSingleCharacter(map_data[y][x], player)
                    end
				else
					local enemy = csim_enemy(screen_y, screen_x, 0, spr)
                    if(map_data[y][x].objectGroup and map_data[y][x].objectGroup.objects[1].shape == "rectangle") then
                        self:loadSingleCharacter(map_data[y][x], enemy)
                    end

					table.insert(enemies, enemy)
				end
			end
		end
	end

	self.map:removeLayer(characters_layer)
	return player, enemies
end

function csim_level_parser:loadSingleCharacter(tile, character)
    local rect = {}
    rect.x = tile.objectGroup.objects[1].x
    rect.y = tile.objectGroup.objects[1].y
    rect.w = tile.objectGroup.objects[1].width
    rect.h = tile.objectGroup.objects[1].height

    -- Adding collider
    local collider = csim_collider(self.map, rect)
    character:addComponent(collider)

    -- Adding rigidbody
    local speed_x = 1
    local speed_y = 1
    local mass = 1

    if (tile.properties["mass"]) then
        mass = tile.properties["mass"]
    end

    if (tile.properties["speed_x"]) then
        speed_x = tile.properties["speed_x"]
    end

    if (tile.properties["speed_y"]) then
        speed_y = tile.properties["speed_y"]
    end

    local rigid_body = csim_rigidbody(mass, speed_x, speed_y)
    character:addComponent(rigid_body)
end

function csim_level_parser:loadItems(items_layer)
	local items = {}

    if(not self.map.layers[items_layer]) then
        print("Items Layer '"..items_layer.."' does not exist in the level.")
        self.map:removeLayer(items_layer)
        return items
    end

	local width = self.map.layers[items_layer].width
	local height = self.map.layers[items_layer].height
	local map_data = self.map.layers[items_layer].data

	for x=1,width do
		for y=1,height do
			if map_data[y] and map_data[y][x] and map_data[y][x].properties["sprite"] then
				local spr = love.graphics.newImage(map_data[y][x].properties["sprite"])
				screen_x, screen_y = self.map:convertTileToPixel(y - 1, x - 1)

                local item = csim_object(screen_y, screen_x, 0, spr)
                if(map_data[y][x].objectGroup and map_data[y][x].objectGroup.objects[1].shape == "rectangle") then
                    self:loadSingleItem(map_data[y][x], item)
                end

				table.insert(items, item)
			end
		end
	end

	self.map:removeLayer("Items")
	return items
end

function csim_level_parser:loadSingleItem(tile, item)
    local rect = {}
    rect.x = tile.objectGroup.objects[1].x
    rect.y = tile.objectGroup.objects[1].y
    rect.w = tile.objectGroup.objects[1].width
    rect.h = tile.objectGroup.objects[1].height

    -- Adding collider to item
    local collider = csim_collider(self.map, rect)
    item:addComponent(collider)
end

return csim_level_parser
