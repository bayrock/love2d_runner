--[[
entity.lua
Author: Bayrock
]]

local ENTS = {}

local entity = {}
entity.__index = entity

math.random = love.math.random

function entity:Draw()
	local pos = self.pos
	local id = self.id

	if id == "entity" then
		lg.setColor(153,204,255)
		lg.rectangle("fill", pos.x, pos.y, 40, 40)
	elseif id == "powerup" then
		lg.setColor(253,255,150)
		lg.rectangle("fill", pos.x, pos.y, 25, 25)
	end
end

function entity:Collided(w1,h1, x2,y2,w2,h2)
	local pos = self.pos
	return pos.x < x2+w2 and x2 < pos.x+w1 and pos.y < y2+h2 and y2 < pos.y+h1
end

function entity:Noclip()
	if not self.noclip then
		self.noclip = true
  else
    self.noclip = false
  end
end

local frequency = 5
local entSpeed = 200
function entity:Update(dt)
	local pos = self.pos
	local id = self.id

	if id == "entity" then
		pos.y = pos.y + entSpeed * dt
		if self:Collided(40, 40, player.x, player.y - 35, 50, 50)
		and not self.noclip then
			gamestate.switch(dead)
			frequency = 0
		end
	elseif id == "powerup" then
		pos.y = pos.y + (entSpeed - 10) * dt
		if self:Collided(25, 25, player.x, player.y - 35, 50, 50)
		and not self.noclip then
			AddBonus(pos.x, pos.y, player.score + 5)
			self:Kill() -- remove powerup
			frequency = frequency - 1
		end
	end

	if pos.y >= windowH + 10 then
		pos.y = -10
		pos.x = math.random(20, windowW - 20)
	end
end

function entity:Kill()
	table.remove(ENTS, ENTS.self)
end

function resetEnts()
	ENTS = {}
end

local bonus ={}
function AddBonus(x, y, score, gain)
	player.score = player.score + (gain or 5)
	table.insert(bonus, {x, y, score})
end

function resetBonus()
	bonus = {}
end

function drawBonus()
	for _, tbl in pairs(bonus) do
		local x, y, score = tbl[1], tbl[2], tbl[3]

		lg.setColor(153, 255, 153)
		if score + 2 > player.score then
			local diff = score - player.score
			lg.printf("+5", x, y + diff * 10, windowW)
		else
			table.remove(bonus, _)
		end
	end
end

function SpawnEnt(pos, id)
	local new = {}
	new.pos = pos
	new.id = id

	setmetatable(new, entity)
	table.insert(ENTS, new)

	return new
end

function randomVec()
	local vec = vector(math.random(20, windowW - 20), math.random(-800, -10))
	return vec
end

local incSum = 10
local nextIncrement = incSum
function entityHandler()
	if player.score > nextIncrement then
		nextIncrement = nextIncrement + incSum
		frequency = frequency + 1
	end

	if round(frequency) > #ENTS then
		local rand = math.random(1, 2)

		if rand < 2 or nextIncrement == 10 then
			SpawnEnt(randomVec(), "entity")
		elseif nextIncrement > 10 then -- not if we just started
			SpawnEnt(randomVec(), "powerup")
		end
	elseif round(frequency) < #ENTS then
		if not debug then
			return ENTS[#ENTS]:Kill()
		end
	end
end

function GetAllEnts()
	return ENTS
end

function GetEntCount()
	return #ENTS
end

function resetFrequency()
	frequency = 5
	nextIncrement = incSum
end
