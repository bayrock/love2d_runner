--[[
main.lua
Author: Bayrock (http://Devinity.org)
]]

require("game.game")

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
--		entity:new()
		frequency = frequency + 2
	elseif button == "r" then
--		entity:killAll()
		frequency = frequency - 2
	end
end

function love.mousereleased( x, y, button )
end

function love.quit()
	print("Exiting...")
end -- end of LOVE functions
