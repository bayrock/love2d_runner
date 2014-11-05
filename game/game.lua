--[[
game.lua
Author: Bayrock (http://Devinity.org)
]]

require("game.player")
require("game.entity")

local function round(num, idp) -- round to the nearest whole number or decimal
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function game.Reload()
	for k, v in pairs(ent.GetAll()) do v:Kill() end
	frequency = 4
	nextIncrement = 10
	player.x = 200
	player.y = 380
	player.speed = 500
	player.score = 0
	player.dead = false
end

lg = love.graphics
function game.Draw()
	player.Draw() -- draw player

	if debug then -- draw debug
		lg.print(projectName..version, 5, 5)
		lg.print("FPS: "..love.timer.getFPS( ), 5, 20)
		lg.print("Player X: "..math.floor(player.x), 5, 35)
		lg.print("Entities: "..ent.Count(), 5, 50)
		lg.print("Score: "..round(player.score, 1), 5, 65)
		lg.setColor(0, 0, 0, 127)
		lg.point(player.x, player.y) -- draw point at player.xy
		lg.rectangle("line", player.x - 25, player.y - 33.3, 50, 50) -- draw hitbox outline
	end

	if player.dead then -- draw game over
		lg.setColor(0, 51, 51)
		lg.rectangle("fill", 0, 0, love.window.getWidth(), love.window.getHeight())
		lg.setColor(255, 255, 255)
		lg.printf("Game over!", love.window.getWidth()/4, love.window.getHeight()/2.5, 350, "center")
		lg.printf("You scored: "..round(player.score), love.window.getWidth()/4, love.window.getHeight()/2.5 + 15, 350, "center")
		lg.printf("Press any key to replay", love.window.getWidth()/4, love.window.getHeight()/2.5 + 45, 350, "center")
	end
end

function game.LoadAudio()
	local volume = love.audio.getVolume()
	gameloop = love.audio.newSource("sound/gameloop.mp3")
	gameloop:setLooping(true)
	love.audio.setVolume(volume * 0.15)
end

function UPDATE_GAME(dt) -- called by love.update
	for k,v in pairs(ent.GetAll()) do v:Update() end
	player.Update(dt)
	ent.Update(dt)
end

function DRAW_GAME() -- called by love.draw
	for k,v in pairs(ent.GetAll()) do v:Draw() end
	game.Draw()
end
