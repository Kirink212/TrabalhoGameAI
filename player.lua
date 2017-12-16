local player = {
	initial_col = 
}

local movement_keys = {"w","a","s","d"}

function player.load()
	
end

function player.movement(dt, key)
	
end

function player.update(dt)
	for i=1, #movement_keys do
		local key = movement_keys[i]
		if love.keyboard.isDown(key) then
			player.movement(dt, key)
		end
	end
end

function player.draw()
	love.graphics.draw(player.animation[frame], player.x, player.y)
end

return player