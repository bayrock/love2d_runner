--[[
commands.lua
Author: Bayrock
]]

console.commands = {}

function AddCommand(id, func)
  console.commands[id] = {func}
end

AddCommand("debug", function()
  if not debug then
    debug = true
    print("Enabled debugging", 204, 255, 153)
  else
    debug = false
    print("Disabled debugging", 204, 255, 153)
  end
end)

AddCommand("print", function(txt)
  if txt then
    print(txt)
  end
end)

AddCommand("powerup", function(txt)
  if debug then
    entNew(randomVec(), "powerup")
    print("Spawned powerup", 204, 255, 153)
  else
    print("Invalid command: 'powerup'", 255, 102, 102)
  end
end)
