--[[
    CSIM 2018

    -- Animator Component --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_animator = class()
local TIMER_START = 999999

function csim_animator:init(spritesheet, width, height)
    self.timer = TIMER_START
    self.current_animation = ""
    self.spritesheet = spritesheet
    self.clips = {}
    self.quads = {}
    self.name = "animator"

    for y = 0, spritesheet:getHeight() - height, height do
        for x = 0, spritesheet:getWidth() - width, width do
            table.insert(self.quads, love.graphics.newQuad(x, y, width, height, spritesheet:getDimensions()))
        end
    end
end

function csim_animator:addClip(name, frames, fps, loop)
    self.clips[name] = {frames, fps, loop}
end

function csim_animator:play(name)
    if(self.clips[name]) then
        local loop = self.clips[name][3]

        if(self:isPlaying(name) and loop) then
            return
        end

        self.current_frame = 1
        self.current_animation = name
        self.timer = TIMER_START
    end
end

function csim_animator:isPlaying(name)
    return self.current_animation == name
end

function csim_animator:update(dt)
    if(self.clips[self.current_animation]) then
        self.timer = self.timer + dt

        local frames = self.clips[self.current_animation][1]
        local fps = self.clips[self.current_animation][2]
        local loop = self.clips[self.current_animation][3]

        if(self.timer > 1/fps) then
            self.parent.quad = self.quads[frames[self.current_frame]]

            self.current_frame = self.current_frame + 1
            if(self.current_frame >= #frames + 1) then
                if(loop) then
                    self.current_frame = 1
                else
                    self.current_frame = #frames
                end
            end

            self.timer = 0
        end
    end
end

return csim_animator
