--[[
game.lua
Author: Bayrock (http://Devinity.org)
]]

require("game.player")
require("game.entity")

function game:reload()
	frequency = 1
	player.x = 200
	player.y = 380
	player.speed = 500
	player.dead = false
end

lg = love.graphics
function game:draw()
	player:draw() -- Draw player

	if debug then -- Draw debug
		lg.print(projectName..version, 5, 5)
		lg.print("FPS: "..love.timer.getFPS( ), 5, 20)
		lg.print("Player X: "..math.floor(player.x), 5, 35)
		lg.print("Entities: "..#entity, 5, 50)
		lg.setColor(0, 0, 0, 127)
		lg.point(player.x, player.y) -- draw point at player.xy
		lg.rectangle("line", player.x - 25, player.y - 33.3, 50, 50) -- draw hitbox outline
	end

	if player.dead then -- Draw game over
		lg.setColor(0, 51, 51)
		lg.rectangle("fill", 0, 0, love.window.getWidth(), love.window.getHeight())
		lg.setColor(255, 255, 255)
		lg.printf("Game over!", love.window.getWidth()/4, love.window.getHeight()/2.5, 350, "center")
		lg.printf("Press any key to replay", love.window.getWidth()/4, love.window.getHeight()/2.5 + 15, 350, "center")
	end
end

function UPDATE_GAME(dt) -- Called by love.update constantly
	player:move(dt)
	entity:update(dt)
end

function DRAW_GAME() -- Draws to the screen
	entity:draw()
	game:draw()
end
