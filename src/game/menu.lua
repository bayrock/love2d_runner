--[[
menu.lua
Author: Bayrock
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
	local w,h = windowW, windowH
	lg.setFont(font(32))
	lg.setColor(153,153,255)
	lg.printf(projectName, 0, h/2 - 40, w, "center")
	lg.setColor(255,255,255, alpha)
	lg.printf("Press space to play", 0, h/2, w, "center")
end

function menu:enter()
	alpha = 255
end

local animate = false
function menu:anim(dt)
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
	self:anim(dt)
end

function menu:keypressed(key)
	if key == " " then
		menuloop:stop()
		gamestate.switch(game)
	elseif key == "`" then
		gamestate.push(console)
	end
end

dead = {} -- dead state constructor
function dead:save()
	local sav = {}
	if not love.filesystem.exists("score.sav") then
		print("Save file did not exist or could not be found")
		print("Creating file..")
		if love.filesystem.write("score.sav", "") then
			print("Created sav file successfully!")
		else
			printError("Error creating sav file!")
		end
	else
		print("Loaded highscore from file")
	end
	for lines in love.filesystem.lines("score.sav") do
		table.insert(sav, lines)
	end
	if sav[1] and tonumber(sav[1]) > player.score then
		player.highscore = tonumber(sav[1]) -- set saved highscore
	end
	saved = true
end

function dead:init()
	self:save()
end

function dead:enter()
	lg.setBackgroundColor(0, 51, 51)
	alpha = 255
	gameloop:stop()
	menuloop:play()
	entKillAll()
	if saved and player.score > player.highscore
	and not debug then
		newHighscore = true
		player.highscore = player.score
		if love.filesystem.write("score.sav", player.highscore) then
			print("Saved highscore to file")
		else
			printError("Error writing highscore to file!")
		end
	end
end

function dead:draw()
	local w,h = windowW, windowH
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
		lg.setColor(255,255,255)
		lg.printf("Highscore: "..round(player.highscore, 1), 0, h/2 - 15, w, "center")
	end
end

function dead:update(dt)
	menu:anim(dt)
end

function dead:keypressed(key)
	if key == "backspace" then
		gamestate.switch(menu)
	elseif key == " " then
		menuloop:stop()
		gamestate.switch(game)
	elseif key == "`" then
		gamestate.push(console)
	end
end

pause = {} -- pause state constructor
function pause:enter(from)
	self.from = from -- record previous state
	love.audio.pause()
end

function pause:draw()
	local w,h = windowW, windowH
	self.from:draw() -- draw previous state
	lg.setFont(font(32))
	lg.setColor(0,0,0 ,100)
	lg.rectangle("fill", 0,0, w,h)
	lg.setColor(255,255,255)
	lg.printf("PAUSED", 0, h/2, w, "center")
	lg.printf("Press any key to continue", 0, h/2 + 20, w, "center")
end

function pause:keypressed(key)
	if key == "`" then
		gamestate.push(console)
	else
		gamestate.pop() -- return previous state
		love.audio.resume()
	end
end
