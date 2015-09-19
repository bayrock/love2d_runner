--[[
console.lua
Author: Bayrock
]]

local prints = {}
function print(txt, r, g, b)
	table.insert(prints, {txt, r, g, b})
end

console = {} -- console state constructor
function console.success(txt)
	table.insert(prints, {txt, 204, 255, 153})
end

function console.error(txt)
	table.insert(prints, {txt, 255, 102, 102})
end

function console:init()
	love.keyboard.setKeyRepeat(true)
end

local carrot = ">"
function console:enter(from)
	self.from = from -- record previous state
	love.audio.pause()
	carrot = ">" -- reset carrot
	love.keyboard.setTextInput(true)
end

local tick = 0
local text = ""
function console:update(dt)
	if string.len(text) >= 1 then
		carrot = ">"
	else
		tick = tick + 1

		if tick == 1000 then
			carrot = ""
		elseif tick == 1500 then
			tick = 0
			carrot = ">"
		end
	end
end

function console:textinput(t)
	text = text..t
end

local MAX_LINES = 15
function console:display()
	lg.setColor(64, 64, 64, 200)
	lg.rectangle("fill", 0, 0, windowW, windowH)
	lg.setColor(255, 255, 255)
	lg.printf(carrot, 5, windowH - 30, windowW)
	lg.printf(text, 20, windowH - 30, windowW)

	for k, tbl in pairs(prints) do
		local txt = tbl[1]
		local r, g, b = tbl[2], tbl[3], tbl[4]

		if k > MAX_LINES then
			table.remove(prints, 1)
		end

		lg.setColor(r or 255, g or 255, b or 255)
		lg.printf("> "..txt, 20, k * 20, windowW)
	end
end

function console:draw()
	self.from:draw()
	self:display()
end

function console:toggle(key)
	if key == "`" then
		love.keyboard.setTextInput(false)
		gamestate.pop()
		love.audio.resume()
	end
end

function console:input(key)
	if key == "backspace" then
		text = string.sub(text, 1, -2)
	elseif key == "return"
	and string.len(text) >= 1 then
		local cmd = string.match(text, "^%w+") -- grab the first statement
		local args = string.match(text, "%s.+") -- grab the rest

		for id, tbl in pairs(self.commands) do
			if id == cmd then
				local func = tbl[1]
				text = "" -- reset the text field
				return func(args)
			end
		end
		self.error(string.format("Invalid command: '%s'", text))
		text = ""
	end
end

function console:keypressed(key)
	self:toggle(key)
	self:input(key)
end
