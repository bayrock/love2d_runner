--[[
game.lua
Author: Bayrock (http://Devinity.org)
]]

require("game.player")
require("game.entity")

windowWidth = love.graphics.getWidth()
windowHeight = love.graphics.getHeight()
lg = love.graphics

game = {} -- main state constructor
function game:init()
	gameloop = love.audio.newSource("game/sound/gameloop.mp3")
	gameloop:setLooping(true)
end

function game:enter()
	lg.setBackgroundColor(64, 64, 64)
	gameloop:play()
	frequency = 5
	nextIncrement = 15
	newHighscore = false
	player.x = 200
	player.xVel = 0
	player.y = 380
	player.score = 0
end

function game:update(dt) -- update game
	for k,v in pairs(entGetAll()) do v:Update(dt) end
	player.Update(dt)
	entUpdate()
end

function game:draw() -- draw game
	for k,v in pairs(entGetAll()) do v:Draw() end
	lg.setFont(font(24))
	player.Draw()
	if debug then
		lg.print(projectName..version, 5, 5)
		lg.print("FPS: "..love.timer.getFPS( ), 5, 20)
		lg.print("Player X: "..math.floor(player.x), 5, 35)
		lg.print("Entities: "..entCount(), 5, 50)
		lg.print("Score: "..round(player.score, 1), 5, 65)
		lg.setColor(0,0,0, 127)
		lg.point(player.x, player.y)
		lg.rectangle("line", player.x - 25, player.y - 33.3, 50, 50)
	else
		lg.print(projectName..version, 5, 5)
		lg.print("Score: "..round(player.score, 1), 5, 20)
	end
end

function game:keypressed(key)
	if key == "`" and not debug or key == "/" and not debug then
		debug = true
		print("Debug overlay enabled")
	elseif key == "`" and debug or key == "/" and debug then
		debug = false
	 	print("Debug overlay disabled")
	end
	if key == " " then
		gamestate.push(pause)
	end
end

function game:keyreleased(key)
	if key == "left" or key == "right" then
		player.xVel = 0
	end
end

function game:focus(f)
	if not f then
		gamestate.push(pause)
	end
end
