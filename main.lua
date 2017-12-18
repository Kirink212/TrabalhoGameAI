local map = require "map"
local player = require "player"

io.stdout:setvbuf("no")

function love.load()
	map.load()
	player.load()
end

function love.update(dt)
	player.update(dt)
end

function love.draw()
	map.draw()
	player.draw()
end

function love.keyreleased(key)
	player.keyreleased(key)
end