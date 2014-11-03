--[[
game.lua
Author: Bayrock (http://Devinity.org)
]]

require("game.player")
require("game.entity")

lg = love.graphics
function game:draw()
	player:draw() -- Draw player
	if debug then -- Draw debug
		lg.print(projectName..version, 5, 5)
		lg.print("FPS: "..love.timer.getFPS( ), 5, 20)
		lg.print("Player X: "..math.floor(player.x), 5, 35)
		lg.print("Entities: "..#entity, 5, 50)
	end
end

function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function UPDATE_GAME(dt) -- Called by love.update constantly
	player:move(dt)
	entity:update(dt)
end

function DRAW_GAME() -- Draws to the screen
	game:draw()
	entity:draw()
end
