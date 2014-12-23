--[[
entity.lua
Author: Bayrock (http://Devinity.org)
]]

local ENTS = {}

local entitymeta = {}
entitymeta.__index = entitymeta

math.random = love.math.random

function entitymeta:Draw()
	for k, v in pairs(ENTS) do
		local pos = v.pos
		lg.setColor(153,204,255)
		lg.rectangle("fill", pos.x, pos.y, 50, 50)
	end
end

local frequency = 5
local entSpeed = 35
function entitymeta:Update(dt)
	local function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
		return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
	end
	for k, v in pairs(ENTS) do
		local pos = v.pos
		pos.y = pos.y + entSpeed * dt
		if pos.y >= windowHeight + 10 then
			pos.y = -10
			pos.x = math.random(20, windowWidth - 20)
		end
		if checkCollision(pos.x, pos.y, 50, 50, player.x - 25, player.y - 33.3, 50, 50) then
			gamestate.switch(dead)
			frequency = 0
		end
	end
end

function entitymeta:Kill()
	for k,v in pairs(ENTS) do
		if v == self then
			table.remove(ENTS, k)
			break
		end
	end
end

function entKillAll()
	frequency = 0
	ENTS = {}
end

function entNew(pos)
	local new = {}
	new.pos = pos
	setmetatable(new, entitymeta)

	table.insert(ENTS, new)

	return new
end

local nextIncrement = 15 -- frequency increment
function entUpdate()
	if player.score > nextIncrement then
		local incSum = 15
		nextIncrement = nextIncrement + incSum
		frequency = frequency + 0.4
		entSpeed = entSpeed + 0.01
		if incSum > 10 then
			incSum = incSum - 0.5
		end
	end
	if round(frequency) > #ENTS and #ENTS < 10 then
		entNew(vector(math.random(20, windowWidth - 20), math.random(-800, -10)))
	elseif round(frequency) < #ENTS then
		for k, v in pairs(ENTS) do v:Kill() end
	end
end

function entGetAll()
	return ENTS
end

function entCount()
	return #ENTS
end

function resetFrequency()
	frequency = 5
	nextIncrement = 15
end
