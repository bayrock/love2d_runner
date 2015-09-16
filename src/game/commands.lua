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
    printSuccess("Enabled debugging")
  else
    debug = false
    printSuccess("Disabled debugging")
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
    printSuccess("Spawned powerup")
  else
    printError("Invalid command: 'powerup'")
  end
end)
