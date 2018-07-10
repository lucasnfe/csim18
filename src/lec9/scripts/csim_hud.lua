--[[
    CSIM 2018
    Lecture 9

    -- HUD Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_hud = {}

csim_hud.collected_coins = 0

function csim_hud.init(font_path, font_size)
    csim_hud.font = love.graphics.newFont(font_path, font_size)
end

function csim_hud.draw()
    love.graphics.setFont(csim_hud.font)
    love.graphics.print(csim_hud.collected_coins,
    csim_game.game_width - csim_hud.font:getWidth(csim_hud.collected_coins), 10)
end

return csim_hud
