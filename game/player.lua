--[[
player.lua
Author: Bayrock (http://Devinity.org)
]]

player = {
	x = 200,
	y = 380,
	speed = 500,
	score = 0,
	highscore = 0,
	dead = false
}

function player.Draw()
	local function triangleCenter(x1,y1,x2,y2,x3,y3)
   		return (x1+x2+x3)/3,(y1+y2+y3)/3 -- averaged point coordinates
	end
	local x1,y1,x2,y2,x3,y3 = 0,0,100,0,50,100 -- triangle coords
	local cx,cy = triangleCenter(x1,y1,x2,y2,x3,y3) -- center of triangle

	lg.setColor(153, 153, 255)

	lg.push() -- draw the player
	lg.translate(player.x,player.y)
	lg.scale(0.5,0.5)
	lg.rotate(math.pi)
	lg.translate(-cx,-cy)
	lg.polygon('fill',x1,y1,x2,y2,x3,y3)
	lg.pop()
end

local keyDown = love.keyboard.isDown
function player.Update(dt)
	local movementSpeed = player.speed * dt
	if keyDown("right") then
		if player.x < windowWidth - 25 then
			player.x = player.x + movementSpeed
		end
	elseif keyDown("left") then
		if player.x > 25 then 
			player.x = player.x - movementSpeed
		end
	end
	if player.dead then
		gameloop:stop()
		deadloop:play()
		ent.KillAll()
		if player.score > player.highscore then
			newHighscore = true
			player.highscore = player.score
		end
	else
		deadloop:stop()
		gameloop:play()
		player.score = player.score + dt
	end
end
