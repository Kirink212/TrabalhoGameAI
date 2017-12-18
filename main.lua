local map = require "map"
local player = require "player"
local player2 = require "player2"

io.stdout:setvbuf("no")

function love.load()
	map.load()
	player.load()
  player2.load()
end

function love.update(dt)
	player.update(dt)
  player2.update(dt)
end

function love.draw()
	map.draw()
  player2.draw()
	player.draw()
end

function love.keyreleased(key)
	player.keyreleased(key)
end