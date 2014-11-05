--[[
entity.lua
Author: Bayrock (http://Devinity.org)
]]

local ENTS = {}

local entitymeta = {}
entitymeta.__index = entitymeta
math.random = love.math.random

function entitymeta:Kill()
	for k,v in pairs(ENTS) do
		if v == self then
			table.remove(ENTS, k)
			break
		end
	end
end

function entitymeta:GetPos()
	return self.pos
end

function entitymeta:Draw()
	for k, v in pairs(ENTS) do
		local pos = v.pos
		lg.setColor(153, 204, 255)
		lg.rectangle("fill", pos.x, pos.y, 50, 50)
	end
end

function entitymeta:Update(dt)
	for k, v in pairs(ENTS) do
		local pos = v.pos
		pos.y = pos.y + 0.25/frequency
		if pos.y >= love.window.getHeight() + 10 then
			pos.y = -10
			pos.x = math.random(20, love.window.getWidth() - 20)
		end
		if checkCollision(pos.x, pos.y, 50, 50, player.x - 25, player.y - 33.3, 50, 50) then
			player.dead = true
			frequency = 0
		end
	end
end

ent = {}
function ent.New(pos)
	local new = {}
	new.pos = pos
	setmetatable(new, entitymeta)
	
	table.insert(ENTS, new)
	
	return new
end

function ent.Update()
	if player.score > nextIncrement then
		frequency = frequency + 1
		nextIncrement = nextIncrement + 10
	end
	if frequency > ent.Count() then
		local randX = math.random(20, love.window.getWidth() - 20)
		local randY = math.random(-400, -10)
		ent.New(vector(randX, randY))
	elseif frequency < ent.Count() then
		for k, v in pairs(ENTS) do v:Kill() end
	end
end

function ent.KillAll()
	frequency = 0
	for k,v in pairs(ENTS) do
		ENTS = {}
	end
end

function ent.GetAll()
	return ENTS
end

function ent.Count()
	return #ENTS
end

function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end
