--[[
game.lua
Author: Bayrock (http://Devinity.org)
]]

require("game.player")
require("game.entity")

windowWidth = love.graphics.getWidth()
windowHeight = love.graphics.getHeight()
lg = love.graphics

game = {} -- main gamestate
function game:init() -- load
	local volume = love.audio.getVolume()
	gameloop = love.audio.newSource("sound/gameloop.mp3")
	gameloop:setLooping(true)
	deadloop = love.audio.newSource("sound/deadloop.mp3")
	deadloop:setLooping(true)
	love.audio.setVolume(volume * 0.15)
end

function game:enter() -- reload
	frequency = 5
	nextIncrement = 15
	newHighscore = false
	player.x = 200
	player.xVel = 0
	player.y = 380
	player.score = 0
end

function game:update(dt)
	for k,v in pairs(entGetAll()) do v:Update(dt) end
	player.Update(dt)
	entUpdate()
end

function game:draw()
	for k,v in pairs(entGetAll()) do v:Draw() end -- draw ents
	player.Draw() -- draw player
	if debug then -- draw debug overlay
		lg.print(projectName..version, 5, 5)
		lg.print("FPS: "..love.timer.getFPS( ), 5, 20)
		lg.print("Player X: "..math.floor(player.x), 5, 35)
		lg.print("Entities: "..entCount(), 5, 50)
		lg.print("Score: "..round(player.score, 1), 5, 65)
		lg.setColor(0,0,0, 127)
		lg.point(player.x, player.y)
		lg.rectangle("line", player.x - 25, player.y - 33.3, 50, 50)
	else -- draw overlay
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
		Gamestate.push(pause)
	end
	if key == "escape" then
      love.event.quit()
   end
end

function game:keyreleased(key)
	if key == "left" or key == "right" then
		player.xVel = 0
	end
end

function game:focus(f)
	if not f then
		Gamestate.push(pause)
	end
end

dead = {} -- dead gamestate
function dead:draw()
	local w,h = windowWidth, windowHeight
	lg.setColor(0,51,51)
	lg.rectangle("fill", 0, 0, w, w)
	lg.setColor(255,255,255)
	lg.printf("Game over!", 0, h/2 - 65, w, "center")
	lg.printf("You scored: "..round(player.score, 1), 0, h/2 - 35, w, "center")
	lg.printf("Press any key to replay", 0, h/2 + 15, w, "center")
	if newHighscore then
		lg.setColor(51, 255, 255)
		lg.printf("New highscore!", 0, h/2 - 20, w, "center")
	else
		lg.printf("Highscore: "..round(player.highscore, 1), 0, h/2 - 20, w, "center")
	end
end

function dead:keypressed()
	Gamestate.switch(game)
end

pause = {} -- pause gamestate
function pause:enter(from)
    self.from = from -- record previous state
    gameloop:pause()
end

function pause:draw()
    local w,h = windowWidth, windowHeight
    self.from:draw() -- draw previous state
    lg.setColor(0,0,0 ,100)
    lg.rectangle("fill", 0,0, w,h)
    lg.setColor(255,255,255)
    lg.printf("PAUSED", 0, h/2, w, "center")
   	lg.printf("Press any key to continue", 0, h/2 + 15, w, "center")
end

function pause:keypressed(key)
    Gamestate.pop() -- return previous state
end
