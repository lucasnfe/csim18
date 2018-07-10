--[[
    CSIM 2018
    Lecture 7

    -- Player Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_object = require "scripts.objects.csim_object"
local csim_vector = require "scripts.csim_vector"

local csim_player = class(csim_object)

function csim_player:init(x, y, rotation, spr)
    csim_object:init(self, x, y, rotation, spr)
    self.is_on_ground = false
end

function csim_player:onVerticalCollision(tile, vert_side)
    -- TODO: Check if the collision is from the top and, if so, set is_on_ground to true
    if(vert_side == 1) then
        self.is_on_ground = true
    end
end

function csim_player:onHorizontalCollision(tile, horiz_side)

end

function csim_player:onHorizontalTriggerCollision(tile, horiz_side)
    -- TODO: If tile is water (has boolean property "isWater"), apply resitance
end

function csim_player:onVerticalTriggerCollision(tile, vert_side)
    -- TODO: If tile is water (has boolean property "isWater"), apply resitance
end

function csim_player:update(dt)
    csim_object.update(self, dt)

    -- Move on x axis
    if (love.keyboard.isDown('left')) then
        self:move(-1)
        love.audio.play(sounds["step"])
    elseif(love.keyboard.isDown('right')) then
        self:move(1)
        love.audio.play(sounds["step"])
    end

    -- Move on y axis
    if (love.keyboard.isDown('up') and player.is_on_ground) then
        self:jump()
        love.audio.play(sounds["step"])
    end

    if(self.is_on_ground) then
        self:getComponent("rigidbody"):applyFriction(0.25)
    end
end

function csim_player:jump()
    -- TODO: Apply a vertical force to player with magnitude speed_y
    local speed_y = player:getComponent("rigidbody").speed.y
    self:getComponent("rigidbody"):applyForce(csim_vector(0, -speed_y))

    -- TODO: Set is_on_ground to false
    self.is_on_ground = false
end

function csim_player:move(dir)
    -- TODO: Apply a horizontal force to player with magnitude speed_x
    local speed_x = self:getComponent("rigidbody").speed.x
    self:getComponent("rigidbody"):applyForce(csim_vector(speed_x * dir, 0))
end

return csim_player
