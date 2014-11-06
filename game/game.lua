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

menu = {} -- menu state constructor
function menu:init()
	lg.setBackgroundColor(0, 51, 51)
	local volume = love.audio.getVolume()
	gameloop = love.audio.newSource("sound/gameloop.mp3")
	gameloop:setLooping(true)
	menuloop = love.audio.newSource("sound/menuloop.mp3")
	menuloop:setLooping(true)
	menuloop:play()
	love.audio.setVolume(volume * 0.15)
end

function menu:draw()
    local w,h = windowWidth, windowHeight
    lg.setColor(255,255,255)
    lg.printf("Press space to play", 0, h/2, w, "center")
end

function menu:keyreleased(key)
	if key == " " then
		menuloop:stop()
    	Gamestate.switch(game)
    end
end

dead = {} -- dead state constructor
function dead:enter()
	lg.setBackgroundColor(0, 51, 51)
	gameloop:stop()
	menuloop:play()
end

function dead:draw()
	local w,h = windowWidth, windowHeight
	lg.setColor(255,255,255)
	lg.printf("Game over!", 0, h/2 - 65, w, "center")
	lg.printf("You scored: "..round(player.score, 1), 0, h/2 - 35, w, "center")
	lg.printf("Space to replay", 0, h/2 + 15, w, "center")
	lg.printf("backspace for menu", 0, h/2 + 30, w, "center")
	if newHighscore then
		lg.setColor(51, 255, 255)
		lg.printf("New highscore!", 0, h/2 - 20, w, "center")
	else
		lg.printf("Highscore: "..round(player.highscore, 1), 0, h/2 - 20, w, "center")
	end
end

function dead:keypressed(key)
	if key == "backspace" then
		Gamestate.switch(menu)
	elseif key == " " then
		menuloop:stop()
		Gamestate.switch(game)
	end
end

pause = {} -- pause state constructor
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
    gameloop:play()
end
