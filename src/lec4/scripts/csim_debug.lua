--[[
    CSIM 2018
    Lecture 4

    -- Debug Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_debug = {}

function csim_debug.init(screen_width, screen_height, console_height)
    csim_debug.width = screen_width
    csim_debug.height = console_height
    csim_debug.x = 0
    csim_debug.y = screen_height - console_height
    csim_debug.messages = {}
    csim_debug.rects = {}
    csim_debug.show_console = false
    csim_debug.state = 0
    csim_debug.font = love.graphics.newFont('fonts/font.ttf', 4)
end

function csim_debug.showConsole()
    csim_debug.show_console = true
    csim_debug.state = 0
end

function csim_debug.hideConsole()
    csim_debug.show_console = false
    csim_debug.state = 0
end

function csim_debug.isShowing()
    return csim_debug.show_console
end

function csim_debug.debug(message)
    if csim_debug.messages[message] == nil then
        csim_debug.messages[message] = 1
    else
        csim_debug.messages[message] = csim_debug.messages[message] + 1
    end
end

function csim_debug.rect(x, y, w, h)

end

function csim_debug.draw()
    if (csim_debug.show_console == true) then
        -- Save graphics state
        r,g,b,a = love.graphics.getColor()
        prev_font = love.graphics.getFont()

        -- Draw grey console
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.rectangle("fill", csim_debug.x, csim_debug.y, csim_debug.width, csim_debug.height)

        -- Draw console label
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(csim_debug.font)
        love.graphics.printf("console", csim_debug.x, csim_debug.y, csim_debug.width)

        local i = 1
        for message,count in pairs(csim_debug.messages) do
            love.graphics.printf(message, csim_debug.x, csim_debug.y + i * 10, csim_debug.width)
            love.graphics.printf(count, csim_debug.width - 8, csim_debug.y + i * 10, csim_debug.width)
            i = i + 1
        end

        local mode = ""
        if (csim_debug.state == 0) then
            mode = ""
        elseif (csim_debug.state == 1) then
            mode = "single step"
        elseif (csim_debug.state == 2) then
            mode = "slow motion"
        end

        love.graphics.printf(mode, csim_debug.width - 45, csim_debug.y, csim_debug.width)

        -- Reset graphics state
        love.graphics.setColor(r,g,b,a)
        love.graphics.setFont(prev_font)
    end
end

return csim_debug