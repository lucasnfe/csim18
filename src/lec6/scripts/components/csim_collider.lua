--[[
    CSIM 2018
    Lecture 6

    -- Collider Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_collider = {}

function csim_collider:new(map, rect)
    local comp = {}
    comp.map = map
    comp.name = "collider"
    comp.parent = nil
    comp.rect = rect
    setmetatable(comp, self)
    self.__index = self
    return comp
end

function csim_collider:update(dt)
    parent_rigid_body = self.parent:getComponent("rigidbody")
    if(parent_rigid_body == nil) then return end

    -- Object is moving down
    local vert_side = 1
    if(parent_rigid_body.vel.y < 0) then
        -- Object is moving up
        vert_side = -1
    end

    local col_pos1 = csim_vector:new(self.parent.pos.x + self.rect.x, self.parent.pos.y + self.rect.y)
    local col_pos2 = csim_vector:new(self.parent.pos.x + self.rect.x + self.rect.w, self.parent.pos.y + self.rect.y)

    if(vert_side == -1) then
        col_pos1 = csim_vector:new(self.parent.pos.x + self.rect.x, self.parent.pos.y + self.rect.y + self.rect.h)
        col_pos2 = csim_vector:new(self.parent.pos.x + self.rect.x + self.rect.w, self.parent.pos.y + self.rect.y + self.rect.h)
    end

    csim_debug.rect(col_pos1.x, col_pos1.y, self.rect.w, self.rect.h)

    local tile_x1, tile_y1 = self:worldToMapPos(col_pos1)
    local tile_x2, tile_y2 = self:worldToMapPos(col_pos2)

    -- if(vert_side == 1) then
    --     if(self:detectVerticalCollision(tile_x1+1, tile_y1+1, vert_side)) then
    --        self:didCollideVertically(tile_x1, tile_y1, vert_side)
    --     end
    -- end

    -- if(vert_side == -1) then
    --     if(self:detectVerticalCollision(tile_x2-1, tile_y2-1, vert_side)) then
    --         self:didCollideVertically(tile_x2, tile_y2, vert_side)
    --     end
    -- end

    -- Object is moving right
    local horiz_side = 1
    if(parent_rigid_body.vel.x < 0) then
        -- Object is moving left
        horiz_side = -1
    end

    local col_pos1 = csim_vector:new(self.parent.pos.x + self.rect.x + self.rect.w, self.parent.pos.y + self.rect.y)
    local col_pos2 = csim_vector:new(self.parent.pos.x + self.rect.x + self.rect.w, self.parent.pos.y + self.rect.y + self.rect.h)

    if(horiz_side == -1) then
        col_pos1 = csim_vector:new(self.parent.pos.x + self.rect.x, self.parent.pos.y + self.rect.y)
        col_pos2 = csim_vector:new(self.parent.pos.x + self.rect.x, self.parent.pos.y + self.rect.y + self.rect.h)
    end

    local tile_x1, tile_y1 = self:worldToMapPos(col_pos1)
    local tile_x2, tile_y2 = self:worldToMapPos(col_pos2)

    -- if(horiz_side == 1) then
    --     if(self:detectHorizontalCollision(tile_x1, tile_y1, horiz_side)) then
    --         self:didCollideHorizontally(tile_x1, tile_y1, horiz_side)
    --     end
    -- end
    --
    -- if(horiz_side == -1) then
    --     if(self:detectHorizontalCollision(tile_x2, tile_y2, horiz_side)) then
    --         self:didCollideHorizontally(tile_x2, tile_y2, horiz_side)
    --     end
    -- end
end

function csim_collider:didCollideVertically(tile_x, tile_y, vert_side)
    -- TODO: Set y component of velocity to zero


    -- TODO: Set rigidbody y position to be the tile y pos
    -- Hint: use map:convertTileToPixel

end

function csim_collider:didCollideHorizontally(tile_x, tile_y, horiz_side)
    -- TODO: Set x component of velocity to zero


    -- TODO: Set rigidbody x position to be the tile x pos
    -- Hint: use map:convertTileToPixel

end

function csim_collider:worldToMapPos(pos)
    -- TODO: return the tile in which the object is right now
    -- Hint: use map:convertPixelToTile(x,y) and math.floor(n) to

end

function csim_collider:detectVerticalCollision(tile_x, tile_y, vert_side)
    -- TODO: Create a variable to store the tile which the object is trying to visit
    -- Hint: Use map.layers['Terrain']

    -- TODO: Check if the tile has property "collide", then return true

end

function csim_collider:detectHorizontalCollision(tile_x, tile_y, horiz_side)
    -- TODO: Create a variable to store the tile which the object is trying to visit
    -- Hint: Use map.layers['Terrain']

    -- TODO: Check if the tile has property "collide", then return true

end

return csim_collider
