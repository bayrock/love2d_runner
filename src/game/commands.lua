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
    console.success("Enabled debugging")
  else
    debug = false
    ToggleClipping() -- ensure noclip is disabled
    console.success("Disabled debugging")
  end
end)

AddCommand("print", function(txt)
  if txt then
    print(txt)
  end
end)

AddCommand("powerup", function(txt)
  if debug then
    SpawnEnt(randomVec(), "powerup")
    console.success("Spawned powerup")
  else
    console.error("Invalid command: 'powerup'")
  end
end)

AddCommand("noclip", function()
  for k,v in pairs(GetAllEnts()) do
    v:Noclip()
  end
  console.success("Toggled entity clipping")
end)
