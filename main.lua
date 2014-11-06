--[[
main.lua
Author: Bayrock (http://Devinity.org)
]]

require("game.game")
Gamestate = require ("libs.gamestate")
vector = require("libs.vector")

function love.load()
	lg.setBackgroundColor(64, 64, 64)
	Gamestate.registerEvents()
	Gamestate.switch(game)
	print("Loaded "..projectName..version)
end

function love.quit()
	print("Exiting...")
end

function round(num, idp) -- round to the nearest whole number or decimal
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end
