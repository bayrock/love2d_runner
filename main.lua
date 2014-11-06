--[[
main.lua
Author: Bayrock (http://Devinity.org)
]]

require("game.game")
vector = require("libs.vector")

function love.load()
	lg.setBackgroundColor(64, 64, 64)
	game.LoadAudio()
	print("Loaded "..projectName..version)
end

function love.draw()
	DRAW_GAME() -- game drawing
end

function love.update(dt)
	UPDATE_GAME(dt) -- game updating
end

function love.focus(bool)
end

function love.keypressed( key, unicode )
	if player.dead then
		game:Reload()
	end
end

function love.keyreleased( key, unicode )
	if key == "`" and not debug or key == "/" and not debug then
		debug = true
		print("Debug overlay enabled")
	elseif key == "`" and debug or key == "/" and debug then
		debug = false
	 	print("Debug overlay disabled")
	end
	if key == "left" or key == "right" then
		player.xVel = 0
	end
end

function love.mousepressed( x, y, button )
	if button == "l" then
		frequency = frequency + 1
	elseif button == "r" then
		frequency = frequency - 1
--		ent.KillAll()
	end
end

function love.mousereleased( x, y, button )
end

function love.quit()
	print("Exiting...")
end -- end of LOVE functions
