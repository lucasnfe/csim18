local csim_fsm = class()

function csim_fsm:init(states, init_state)
    self.name = "fsm"
    self.states = states
    self.c_state = init_state
    self.timer = 0
end

function csim_fsm:load()
    -- c_state is equal to init_state
    self.states[self.c_state].enter(self.parent)
end

function csim_fsm:update(dt)
    -- update the current state
    self.states[self.c_state].update(self.parent, dt)
end

function csim_fsm:changeState(newState)
    -- exit current state
    self.states[self.c_state].exit(self.parent)

    -- update current state
    self.c_state = newState

    -- enter new state
    self.timer = 0
    self.states[self.c_state].enter(self.parent)
end

function csim_fsm:createState(stateName)
end

return csim_fsm
