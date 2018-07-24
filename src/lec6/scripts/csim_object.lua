
local csim_object = class()

function csim_object:init(x, y, spr)
    self.x = x
    self.y = y
    self.spr = spr
end

return csim_object
