local map = require "map"
local player = require "player"
local player2 = require "player2"

io.stdout:setvbuf("no")

function love.load()
	win_font = love.graphics.newFont(50)
	map.load()
	player.load()
  	player2.load()
end

function love.update(dt)
	if not (player.win or player2.win) then
		player.update(dt)
  		player2.update(dt)
  	end
end

function love.draw()
	map.draw()
  	player2.draw()
	player.draw()

	love.graphics.setColor(255,0,0)
	love.graphics.setFont(win_font)

	if player2.win then
		love.graphics.printf("VOCÊ PERDEU!", 0, 0, map.width, "center")
	elseif player.win then
		love.graphics.printf("PARABÉNS, VOCÊ VENCEU!", 0, 0, map.width, "center")
	end

	love.graphics.setColor(255,255,255)
end

function love.keyreleased(key)
	player.keyreleased(key)
end