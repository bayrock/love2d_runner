--[[
main.lua
Author: Bayrock (http://Devinity.org)
]]

require("game.game")
gamestate = require ("lib.gamestate")
vector = require("lib.vector")

function love.load()
	love.filesystem.setIdentity("love2d_runner")
	gamestate.registerEvents()
	gamestate.switch(menu)
	love.keyboard.setTextInput(false)
	print("Loaded "..projectName)
end

function love.keyreleased(key)
	if key == "escape" then
		love.event.quit()
	end
end

function love.quit()
	print("Exiting...")
end
