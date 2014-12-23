--[[
main.lua
Author: Bayrock (http://Devinity.org)
]]

require("game.game")
gamestate = require ("libs.gamestate")
vector = require("libs.vector")

function love.load()
	gamestate.registerEvents()
	gamestate.switch(menu)
	print("Loaded "..projectName..version)
end

function love.keyreleased(key)
	if key == "escape" then
		love.event.quit()
	end
end

function love.quit()
	print("Exiting...")
end
