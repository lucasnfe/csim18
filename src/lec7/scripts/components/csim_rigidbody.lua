
local csim_rigidbody = class()

function csim_rigidbody:init()
    self.name = "rigidbody"
end

function csim_rigidbody:load()
    print("load!")
end

function csim_rigidbody:update(dt)
    print("update!")
end

return csim_rigidbody
