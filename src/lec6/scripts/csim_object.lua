
local csim_object = class()

function csim_object:init(x, y, spr)
    self.x = x
    self.y = y
    self.spr = spr
end

function csim_object:draw()
    love.graphics.draw(self.spr, self.x, self.y)
end

return csim_object
