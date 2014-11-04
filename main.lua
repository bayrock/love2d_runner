--[[
main.lua
Author: Bayrock (http://Devinity.org)
]]

require("game.game")
vector = require("libs.vector")

function love.load()
	lg.setBackgroundColor(64, 64, 64)
	print("Loaded "..projectName..version)
end

function love.draw()
	DRAW_GAME() -- Game drawing
end

function love.update(dt)
	UPDATE_GAME(dt) -- Game updating
--	print()
end

function love.focus(bool)
end

function love.keypressed( key, unicode )
	if player.dead then
		game:reload()
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
end

function love.mousepressed( x, y, button )
	if button == "l" then
		NewEntity(vector(math.random(20, love.window.getWidth() - 20), -10)) -- for debugging
		frequency = frequency + 1
	elseif button == "r" then
		frequency = frequency - 1
		for k, v in ipairs(ent.GetAll()) do v:Kill() end -- for debugging
	end
end

function love.mousereleased( x, y, button )
end

function love.quit()
	print("Exiting...")
end -- end of LOVE functions
