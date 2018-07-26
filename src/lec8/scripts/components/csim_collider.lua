--[[
    CSIM 2018

    -- Collider Component --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_collider = class()
local SKIN = 0.01

function csim_collider:init(map, rect)
    self.map = map
    self.rect = rect
    self.name = "collider"
end

function csim_collider:getColliderWorldPos()
        return csim_vector(self.parent.pos.x + self.rect.x,
                           self.parent.pos.y + self.rect.y)
end

function csim_collider:detectHorizontalCollision(vel)
    local horiz_side = 1
    if(vel.x < 0) then
        horiz_side = -1
    end

    local col_pos1 = csim_vector(self.parent.pos.x + self.rect.x + self.rect.w,
                        self.parent.pos.y + self.rect.y + SKIN)
    local col_pos2 = csim_vector(self.parent.pos.x + self.rect.x + self.rect.w,
                        self.parent.pos.y + self.rect.y + self.rect.h - SKIN)

    if(horiz_side == -1) then
        col_pos1 = csim_vector(self.parent.pos.x + self.rect.x,
                            self.parent.pos.y + self.rect.y + SKIN)
        col_pos2 = csim_vector(self.parent.pos.x + self.rect.x,
                            self.parent.pos.y + self.rect.y + self.rect.h - SKIN)
    end

    col_pos1.x = col_pos1.x + vel.x
    col_pos2.x = col_pos2.x + vel.x

    local tile_x1, tile_y1 = self:worldToMapPos(col_pos1)
    local tile_x2, tile_y2 = self:worldToMapPos(col_pos2)

    if(self:isCollidingHorizontically(tile_x1, tile_y1, horiz_side)) then
        self:didCollideHorizontally(tile_x1, tile_y1, horiz_side)
    end

    if(self:isCollidingHorizontically(tile_x2, tile_y2, horiz_side)) then
        self:didCollideHorizontally(tile_x2, tile_y2, horiz_side)
    end
end

function csim_collider:detectVerticalCollision(vel)
    local vert_side = 1
    if(vel.y < 0) then
        vert_side = -1
    end

    local col_pos1 = csim_vector(self.parent.pos.x + self.rect.x + SKIN,
                        self.parent.pos.y + self.rect.y + self.rect.h)
    local col_pos2 = csim_vector(self.parent.pos.x + self.rect.x + self.rect.w - SKIN,
                        self.parent.pos.y + self.rect.y + self.rect.h)

    if(vert_side == -1) then
        col_pos1 = csim_vector(self.parent.pos.x + self.rect.x + SKIN,
                            self.parent.pos.y + self.rect.y)
        col_pos2 = csim_vector(self.parent.pos.x + self.rect.x + self.rect.w - SKIN,
                            self.parent.pos.y + self.rect.y)
    end

    col_pos1.y = col_pos1.y + vel.y
    col_pos2.y = col_pos2.y + vel.y

    local tile_x1, tile_y1 = self:worldToMapPos(col_pos1)
    local tile_x2, tile_y2 = self:worldToMapPos(col_pos2)

    if(self:isCollidingVertically(tile_x1, tile_y1, vert_side)) then
        self:didCollideVertically(tile_x1, tile_y1, vert_side)
    end

    if(self:isCollidingVertically(tile_x2, tile_y2, vert_side)) then
        self:didCollideVertically(tile_x2, tile_y2, vert_side)
    end
end

function csim_collider:worldToMapPos(pos)
    local x,y = self.map:convertPixelToTile(pos.x, pos.y)
    return math.floor(x), math.floor(y)
end

function csim_collider:isCollidingVertically(tile_x, tile_y, vert_side)
    local map_data = self.map.layers["Terrain"].data
    if map_data[tile_y+1] and map_data[tile_y+1][tile_x+1] then
        local tile = map_data[tile_y+1][tile_x+1]

        if (tile) then
            if(tile.properties["trigger"]) then
                -- Callback function
                if(self.parent.onVerticalTriggerCollision) then
                    self.parent:onVerticalTriggerCollision(tile, vert_side)
                end
            end

            if(tile.properties["collide"]) then
                -- Callback function
                if(self.parent.onVerticalCollision) then
                    self.parent:onVerticalCollision(tile, vert_side)
                end

                return true
            end
        end
    end

    return false
end

function csim_collider:didCollideVertically(tile_x, tile_y, vert_side)
    local parent_rigid_body = self.parent:getComponent("rigidbody")

    parent_rigid_body.vel.y = 0

    screen_x, screen_y = self.map:convertTileToPixel(tile_x, tile_y)
    if(vert_side == -1) then
        self.parent.pos.y = screen_y + self.map.tileheight - self.rect.y
    elseif(vert_side == 1) then
        self.parent.pos.y = screen_y - self.rect.y - self.rect.h
    end
end

function csim_collider:isCollidingHorizontically(tile_x, tile_y, horiz_side)
    local map_data = self.map.layers["Terrain"].data
    if map_data[tile_y+1] and map_data[tile_y+1][tile_x+1] then
        local tile = map_data[tile_y+1][tile_x+1]

        if(tile) then
            if(tile.properties["trigger"]) then
                -- Callback function
                if(self.parent.onHorizontalTriggerCollision) then
                    self.parent:onHorizontalTriggerCollision(tile, horiz_side)
                end
            end

            if(tile.properties["collide"]) then
                -- Callback function
                if(self.parent.onHorizontalCollision) then
                    self.parent:onHorizontalCollision(tile, horiz_side)
                end

                return true
            end
        end
    end

    return false
end

function csim_collider:didCollideHorizontally(tile_x, tile_y, horiz_side)
    local parent_rigid_body = self.parent:getComponent("rigidbody")

    parent_rigid_body.vel.x = 0

    screen_x, screen_y = self.map:convertTileToPixel(tile_x, tile_y)
    if(horiz_side == -1) then
        self.parent.pos.x = screen_x + self.map.tilewidth - self.rect.x
    elseif(horiz_side == 1) then
        self.parent.pos.x = screen_x - self.rect.x - self.rect.w
    end
end

return csim_collider
