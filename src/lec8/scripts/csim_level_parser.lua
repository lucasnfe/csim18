--[[
    CSIM 2018
    Lecture 8

    -- Level Parser Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_level_parser = {}

local csim_object = require "scripts.objects.csim_object"
local csim_player = require "scripts.objects.csim_player"
local csim_enemy = require "scripts.objects.csim_enemy"

local csim_collider = require "scripts.components.csim_collider"
local csim_rigidbody = require "scripts.components.csim_rigidbody"

function csim_level_parser:new(map)
    local obj = {}
    obj.map = map
    setmetatable(obj, self)
    self.__index = self
    return obj
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
					player = csim_player:new(screen_y, screen_x, 0, spr)

                    if(map_data[y][x].objectGroup.objects[1].shape == "rectangle") then
                        local rect = {}
                        rect.x = map_data[y][x].objectGroup.objects[1].x
                        rect.y = map_data[y][x].objectGroup.objects[1].y
                        rect.w = map_data[y][x].objectGroup.objects[1].width
                        rect.h = map_data[y][x].objectGroup.objects[1].height

                        -- Adding collider to player
                        local collider = csim_collider:new(self.map, rect)
                        player:addComponent(collider)

                        print(player:getComponent("collider").rect.y)

                        -- Adding rigidbody to player
                        local rigid_body = csim_rigidbody:new(1, 1, 12)
                        player:addComponent(rigid_body)
                    end
				else
					local enemy = csim_enemy:new(screen_y, screen_x, 0, spr)

                    if(map_data[y][x].objectGroup and map_data[y][x].objectGroup.objects[1].shape == "rectangle") then
                        local rect = {}
                        rect.x = map_data[y][x].objectGroup.objects[1].x
                        rect.y = map_data[y][x].objectGroup.objects[1].y
                        rect.w = map_data[y][x].objectGroup.objects[1].width
                        rect.h = map_data[y][x].objectGroup.objects[1].height

                        -- Adding collider to enemy
                        local collider = csim_collider:new(self.map, rect)
                        enemy:addComponent(collider)

                        -- Adding rigidbody to enemy
                        local rigid_body = csim_rigidbody:new(1, 1, 1)
                        enemy:addComponent(rigid_body)
                    end

					table.insert(enemies, enemy)
				end
			end
		end
	end

	self.map:removeLayer(characters_layer)
	return player, enemies
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

                local item = csim_object:new(screen_y, screen_x, 0, spr)

                if(map_data[y][x].objectGroup and map_data[y][x].objectGroup.objects[1].shape == "rectangle") then
                    local rect = {}
                    rect.x = map_data[y][x].objectGroup.objects[1].x
                    rect.y = map_data[y][x].objectGroup.objects[1].y
                    rect.w = map_data[y][x].objectGroup.objects[1].width
                    rect.h = map_data[y][x].objectGroup.objects[1].height

                    -- Adding collider to item
                    local collider = csim_collider:new(self.map, rect)
                    item:addComponent(collider)
                end

				table.insert(items, item)
			end
		end
	end

	self.map:removeLayer("Items")
	return items
end

return csim_level_parser
