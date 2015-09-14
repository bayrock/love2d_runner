--[[
game.lua
Author: Bayrock (http://Devinity.org)
]]

require("game.menu")
require("game.player")
require("game.entity")
require("game.console")
require("game.commands")

lg = love.graphics
windowWidth = lg.getWidth()
windowHeight = lg.getHeight()

game = {} -- game state constructor
function game:init()
	gameloop = love.audio.newSource("game/sound/gameloop.mp3")
	gameloop:setLooping(true)
end

local function reset()
	resetFrequency()
	newHighscore = false
	player.x = 200
	player.xVel = 0
	player.y = 380
	player.score = 0
end

function game:enter()
	lg.setBackgroundColor(64, 64, 64)
	gameloop:play()
	reset()
end

function game:update(dt) -- update game
	for k,v in pairs(entGetAll()) do v:Update(dt) end
	entUpdate()
	player.Update(dt)
end

function game:debug()
	if debug then
		lg.print(projectName, 5, 5)
		lg.print("FPS: "..love.timer.getFPS(), 5, 20)
		lg.print("Player X: "..math.floor(player.x), 5, 35)
		lg.print("Entities: "..entCount(), 5, 50)
		lg.print("Score: "..round(player.score, 1), 5, 65)
		lg.setColor(0,0,0, 127)
		lg.point(player.x, player.y)
		lg.rectangle("line", player.x, player.y - 35, 50, 50)
	else
		lg.print(projectName, 5, 5)
		lg.print("Score: "..round(player.score, 1), 5, 20)
	end
end

function game:draw() -- draw game
	for k,v in pairs(entGetAll()) do v:Draw() end
	lg.setFont(font(24))
	player.Draw()
	self:debug()
end

function game:keypressed(key)
	if key == "`" then
		gamestate.push(console)
	elseif key == " " then
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
