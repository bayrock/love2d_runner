--[[
entity.lua
Author: Bayrock (http://Devinity.org)
]]

entity = {}
math.random = love.math.random

function entity:new()
	table.insert(entity, {x = math.random(20, love.window.getWidth() - 20), y = -10})
end

function entity:killAll()
	for k, v in ipairs(entity) do
		table.remove(entity, k)
	end
end

function entity:kill()
local diff = #entity - frequency
	for i=#entity, diff, -1 do
		table.remove(entity, i)
	end
end

function entity:draw()
	for k, v in ipairs(entity) do
		love.graphics.setColor(153, 204, 255)
		love.graphics.rectangle("fill", v.x, v.y, 50, 50)
	end
end

function entity:update(dt)
	for k, v in ipairs(entity) do
		v.y = v.y + 180 * dt
		if v.y >= love.window.getHeight() + 10 then
			v.y = -10
			v.x = math.random(20, love.window.getWidth() - 20)
		end
		if checkCollision(v.x, v.y, 50, 50, player.x - 25, player.y - 33.3, 50, 50) then
			player.dead = true
			frequency = 0
		end
	end
	if #entity < frequency then
		entity:new()
	elseif #entity > frequency then
		entity:kill()
	end
end

function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end