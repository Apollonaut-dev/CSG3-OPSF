jammers = {}

local jammerActivators = {
  [1] = {
    on = function ()
      local jammerSource = 2
      local jammer1 = 1
      jammers[1] = 99
    end,
    off = function() 
      local jammerSource = Unit.getByName("Growler1")
      local jammer = Sky

    end
  }
}

print(jammers[1])
local ref = jammerActivators[1].on
ref()
print(jammers[1])