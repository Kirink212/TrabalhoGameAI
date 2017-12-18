local player = {
	dir = {
		w = -1,
		a = -1,
		s = 1,
		d = 1
	},
	velocity = 200,
	map_col = 0,
	map_line = 16,
  	x = 0,
  	y = 0
}

local anim = require "animation"
local map = require "map"
local collision = require "collision"

local img
local ts

local movement_keys = {
  	y = {"w","s"} ,
  	x = {"a", "d"}
}

local keys_animations = {
	w = "walk_up",
	a = "walk_left",
	s = "walk_down",
	d = "walk_right"
}


function player.load()
	img = love.graphics.newImage("assets/player_sprite.png")

	player.states = {
		--idle = anim.create("assets/player_sprite.png", 1, 4, 20, 100),
		walk_up = anim.create(img, 1, 5, 20, 100, 3),
		walk_down = anim.create(img, 1, 5, 20, 100, 1),
		walk_right = anim.create(img, 1, 5, 20, 100, 4),
		walk_left = anim.create(img, 1, 5, 20, 100, 2)
	}

	player.curr_state = player.states.walk_right

	ts = player.curr_state.values.tileSize
	player.x = (map.start[2]-1)*ts + 1
	player.y = (map.start[1]-1)*ts + 1
end

function player.canMove(key, coord)
	local offset = player.dir[key]
	local col = player.map_col
	local line = player.map_line
	local m
	-- if coord == "x" then
	--  	m = map.grid[line][col + offset]
	-- else
	-- 	m = map.grid[line+ offset][col]
	-- end

	-- if m == "B" then
	-- 	return false
	-- end

	return true
end

function player.update(dt)
	local player_previous_x = player.x
	local player_previous_y = player.y

	for coord, keys in pairs(movement_keys) do
		local p = player
		for k = 1, #keys do
			local key = keys[k]
			if love.keyboard.isDown(key) then
				local ka = keys_animations[key]
	        	player[coord] = player[coord] + p.velocity*p.dir[key]*dt
	        	player.curr_state = player.states[ka]
	        	anim.run_frames(dt, player.curr_state)
			end
		end
	end

	for i=1, map.grid.total_lines do
		for j=1, map.grid.total_cols do
			local map_x = (j-1)*ts
			local map_y = (i-1)*ts
			if map.grid[i][j] == "B" then
				if collision.checkBoxes(player.x - ts/2, player.y, ts/2, ts/2, map_x, map_y, ts, ts) then
					print("Colidiu")
					player.x = player_previous_x
			        player.y = player_previous_y
        		end
      		end
		end
	end

	if player.x < 0 then
		player.x = 0
	elseif player.x > map.width - ts then
		player.x = map.width - ts
	end

	if player.y < 0 then
		player.y = 0
	elseif player.y > map.height - ts then
		player.y = map.height - ts
	end	

	player.map_col = math.floor(player.x/ts)
	player.map_line = math.floor(player.y/ts)
end

function player.draw()
	local frame = player.curr_state.values.current_frame
  	love.graphics.draw(img, player.curr_state.seq[frame], player.x, player.y, 0, 1, 1, ts/2, ts/2)

  	-- love.graphics.setColor(255,0,0)
  	-- love.graphics.rectangle("line", player.x - ts/2, player.y, ts/2, ts/2)

  	-- love.graphics.print(tostring(player.map_col))
  	-- love.graphics.print(tostring(player.map_line), 0, 50)

 --  	for i=1, map.grid.total_lines do
	-- 	for j=1, map.grid.total_cols do
	-- 		local map_x = (j-1)*ts
	-- 		local map_y = (i-1)*ts
	-- 		love.graphics.rectangle("line", map_x, map_y, ts, ts)
	-- 	end
	-- end
	love.graphics.setColor(255,255,255)
end

function player.keyreleased(key)
	for i, v in pairs(player.dir) do
		if key == i then
			player.curr_state.values.current_frame = 1
		end
	end
end

return player