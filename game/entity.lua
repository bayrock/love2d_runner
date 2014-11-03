--[[
entity.lua
Author: Bayrock (http://Devinity.org)
]]

entity = {}
math.random = love.math.random

function entity:new()
	table.insert(entity, {x = math.random(20, love.window.getWidth() - 20), y = 0})
end

function entity:killAll()
	for k, v in ipairs(entity) do
		table.remove(entity, k)
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
			v.y = 0
			v.x = math.random(20, love.window.getWidth() - 20)
		end
	end
end