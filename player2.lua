local player2 = {
	dir = {
		up = -1,
		left = -1,
		down = 1,
		right = 1
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
local ai = require "ai"

local img
local ts

local movement_keys = {
  	y = {"up","down"} ,
  	x = {"left", "right"}
}

local keys_animations = {
	up = "walk_up",
	left = "walk_left",
	down = "walk_down",
	right = "walk_right"
}


function player2.load()
	img = love.graphics.newImage("assets/player_sprite.png")

	player2.states = {
		--idle = anim.create("assets/player_sprite.png", 1, 4, 20, 100),
		walk_up = anim.create(img, 1, 5, 20, 100, 3),
		walk_down = anim.create(img, 1, 5, 20, 100, 1),
		walk_right = anim.create(img, 1, 5, 20, 100, 4),
		walk_left = anim.create(img, 1, 5, 20, 100, 2)
	}

	player2.curr_state = player2.states.walk_right

	ts = player2.curr_state.values.tileSize
	player2.x = player2.map_col*ts + 1
	player2.y = player2.map_line*ts
  
  ai.setLocation(player2.map_line+1, player2.map_col+1)
  ai.setGoal(1, 23)
  --ai.bestPath()
end

function player2.canMove(key, coord)
	local offset = player2.dir[key]
	local col = player2.map_col
	local line = player2.map_line
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

function player2.update(dt)
	local player2_previous_x = player2.x
	local player2_previous_y = player2.y

	for coord, keys in pairs(movement_keys) do
		local p = player2
		for k = 1, #keys do
			--local key = keys[k]
      		local key = ai.nextStep()
			if keys[k] == key then
        		print(key)
				local ka = keys_animations[key]
        		player2[coord] = player2[coord] + p.velocity*p.dir[key]*dt
        		player2.curr_state = player2.states[ka]
        		anim.run_frames(dt, player2.curr_state)
			end
		end
	end

	for i=1, map.grid.total_lines do
		for j=1, map.grid.total_cols do
			local map_x = (j-1)*ts
			local map_y = (i-1)*ts
			if map.grid[i][j] ~= "X" then
				if collision.checkBoxes(player2.x - ts/2, player2.y, ts/2, ts/2, map_x, map_y, ts, ts) then
					--print("Colidiu")
					ai.setObstacle(i, j)
					--print("Adicionado obstaculo em [" .. i .. ", " .. j .. "]")
					--ai.clearPath()
					--path = ai.bestPath()
					player2.x = player2_previous_x
					player2.y = player2_previous_y
				end
			end
		end
	end

	if player2.x < 0 then
		player2.x = 0
	elseif player2.x > map.width - ts then
		player2.x = map.width - ts
	end

	if player2.y < 0 then
		player2.y = 0
	elseif player2.y > map.height - ts then
		player2.y = map.height - ts
	end	

	player2.map_col = math.floor((player2.x - ts/2)/ts)
	player2.map_line = math.floor((player2.y + ts/2)/ts)
  
  if player2.map_col < 0 then
    player2.map_col = 0
  end
  if player2.map_line < 0 then
    player2.map_line = 0
  end
  
  ai.setLocation(player2.map_line+1, player2.map_col+1)
end

function player2.draw()
	local frame = player2.curr_state.values.current_frame
  	love.graphics.setColor(50,255,255)
  	love.graphics.draw(img, player2.curr_state.seq[frame], player2.x, player2.y, 0, 1, 1, ts/2, ts/2)
    love.graphics.rectangle("line", player2.x - ts/2, player2.y, ts/2, ts/2)

  	-- love.graphics.setColor(255,0,0)
  	-- love.graphics.rectangle("line", player.x - ts/2, player.y, ts/2, ts/2)

  	-- love.graphics.print(tostring(player.map_col))
  	-- love.graphics.print(tostring(player.map_line), 0, 50)

 	-- for i=1, map.grid.total_lines do
	-- 	for j=1, map.grid.total_cols do
	-- 		local map_x = (j-1)*ts
	-- 		local map_y = (i-1)*ts
	-- 		love.graphics.rectangle("line", map_x, map_y, ts, ts)
	-- 	end
	-- end
	love.graphics.setColor(255,255,255)
	love.graphics.print("map_line: " .. player2.map_line+1 .. "\tmap_col: " .. player2.map_col+1 .. "", 0, 0)
	-- for i,v in ipairs(path) do
	-- 	love.graphics.print("i: " .. v.i .. "\tj: " .. v.j .. "", 0, 15*i)
	-- end
end

return player2