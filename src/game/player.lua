--[[
player.lua
Author: Bayrock
]]

player = {
	x = 200,
	xVel = 0,
	y = 380,
	speed = 900,
	score = 0,
	highscore = 0
}

function player.Draw()
	lg.setColor(153,153,255)
	lg.push() -- draw the player
	lg.translate(player.x,player.y)
	lg.rectangle('fill', 0, -35, 50, 50)
	lg.pop()
end

local keyDown = love.keyboard.isDown
function player.Update(dt)
	player.score = player.score + dt
	player.x = player.x + player.xVel * dt

	if keyDown("right") and player.xVel < player.speed then
		player.xVel = player.xVel + player.speed * dt
	elseif keyDown("left") and player.xVel > -player.speed then
		player.xVel = player.xVel - player.speed * dt
	end
	if player.x < 0 then
		player.x = 0
		player.xVel = 0
	elseif player.x > windowW - 50 then
		player.x = windowW - 50
		player.xVel = 0
	end
end
