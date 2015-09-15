--[[
entity.lua
Author: Bayrock
]]

local ENTS = {}

local entitymeta = {}
entitymeta.__index = entitymeta

math.random = love.math.random

function entitymeta:Draw()
	for k, v in pairs(ENTS) do
		local pos = v.pos
		local id = v.id

		if id == "entity" then
			lg.setColor(153,204,255)
			lg.rectangle("fill", pos.x, pos.y, 40, 40)
		elseif id == "powerup" then
			lg.setColor(253,255,150)
			lg.rectangle("fill", pos.x, pos.y, 25, 25)
		end
	end
end

local function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

local frequency = 5
local entSpeed = 35
function entitymeta:Update(dt)
	for k, v in pairs(ENTS) do
		local pos = v.pos
		local id = v.id

		if id == "entity" then
			pos.y = pos.y + entSpeed * dt
			if checkCollision(pos.x, pos.y, 40, 40, player.x, player.y - 35, 50, 50) then
				gamestate.switch(dead)
				frequency = 0
			end
		elseif id == "powerup" then
			pos.y = pos.y + (entSpeed - 10) * dt
			if checkCollision(pos.x, pos.y, 25, 25, player.x, player.y - 35, 50, 50) then
				AddBonus(pos.x, pos.y, player.score + 5)
				v:Kill() -- remove powerup
				frequency = frequency - 1
			end
		end

		if pos.y >= windowH + 10 then
			pos.y = -10
			pos.x = math.random(20, windowW - 20)
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

local bonus ={}
function AddBonus(x, y, score, gain)
	player.score = player.score + (gain or 5)
	table.insert(bonus, {x, y, score})
end

function resetBonus()
	bonus = {}
end

function bonusDraw()
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

function entKillAll()
	frequency = 0
	ENTS = {}
end

function entNew(pos, id)
	local new = {}
	new.pos = pos
	new.id = id

	setmetatable(new, entitymeta)

	table.insert(ENTS, new)

	return new
end

function randomVec()
	local vec = vector(math.random(20, windowW - 20), math.random(-800, -10))
	return vec
end

local incSum = 10
local nextIncrement = incSum
function entUpdate()
	if player.score > nextIncrement then
		nextIncrement = nextIncrement + incSum
		frequency = frequency + 1
	end

	if round(frequency) > #ENTS then
		local rand = math.random(1, 3)

		if rand < 3 or nextIncrement == 10 then
			entNew(randomVec(), "entity")
		elseif nextIncrement > 10 then -- not if we just started
			entNew(randomVec(), "powerup")
		end
	elseif round(frequency) < #ENTS then
		if not debug then
			return ENTS[#ENTS]:Kill()
		end
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
	nextIncrement = incSum
end
