--[[
menu.lua
Author: Bayrock (http://Devinity.org)
]]

function font(size, font)
	return lg.newFont(font or "game/font/coders_crux.ttf", size)
end

function round(num, idp) -- round to the nearest whole number or decimal
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

menu = {} -- menu state constructor
function menu:init()
	lg.setBackgroundColor(0, 51, 51)
	local volume = love.audio.getVolume()
	love.audio.setVolume(volume * 0.15)
	menuloop = love.audio.newSource("game/sound/menuloop.mp3")
	menuloop:setLooping(true)
	menuloop:play()
end

local alpha = 253
function menu:draw()
	local w,h = windowWidth, windowHeight
	lg.setFont(font(32))
	lg.setColor(153,153,255)
	lg.printf(projectName..version, 0, h/2 - 40, w, "center")
	lg.setColor(255,255,255, alpha)
	lg.printf("Press space to play", 0, h/2, w, "center")
end

function menu:enter()
	alpha = 255
end

local animate = false
function anim(dt)
	if alpha >= 254 then
		animate = false
		elseif alpha <= 30 then
			animate = true
		end
		if animate then
			alpha = alpha + 90 * dt
		else
			alpha = alpha - 90 * dt
	end
end

function menu:update(dt)
	anim(dt)
end

function menu:keyreleased(key)
	if key == " " then
		menuloop:stop()
		gamestate.switch(game)
	end
end

dead = {} -- dead state constructor
function dead:enter()
	lg.setBackgroundColor(0, 51, 51)
	alpha = 255
	gameloop:stop()
	menuloop:play()
	entKillAll()
	if player.score > player.highscore then
		newHighscore = true
		player.highscore = player.score
	end
end

function dead:draw()
	local w,h = windowWidth, windowHeight
	lg.setColor(255,255,255)
	lg.setFont(font(32))
	lg.printf("Game over!", 0, h/2 - 80, w, "center")
	lg.printf("You scored: "..round(player.score, 1), 0, h/2 - 35, w, "center")
	lg.setColor(255,255,255, alpha)
	lg.printf("Space to replay", 0, h/2 + 30, w, "center")
	lg.printf("backspace for menu", 0, h/2 + 50, w, "center")
	if newHighscore then
		lg.setColor(51, 255, 255)
		lg.printf("New highscore!", 0, h/2 - 15, w, "center")
	else
		lg.printf("Highscore: "..round(player.highscore, 1), 0, h/2 - 15, w, "center")
	end
end

function dead:update(dt)
	anim(dt)
end

function dead:keypressed(key)
	if key == "backspace" then
		gamestate.switch(menu)
	elseif key == " " then
		menuloop:stop()
		gamestate.switch(game)
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
	lg.setFont(font(32))
	lg.setColor(0,0,0 ,100)
	lg.rectangle("fill", 0,0, w,h)
	lg.setColor(255,255,255)
	lg.printf("PAUSED", 0, h/2, w, "center")
	lg.printf("Press any key to continue", 0, h/2 + 20, w, "center")
end

function pause:keypressed(key)
	gamestate.pop() -- return previous state
	gameloop:play()
end
