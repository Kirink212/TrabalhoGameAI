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

local img

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
end

function player.update(dt)
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
end

function player.draw()
	local frame = player.curr_state.values.current_frame
  
  --love.graphics.print(tostring(frame), player.x, player.y)
  --love.graphics.print(tostring(player.curr_state.seq), player.x, player.y)
  love.graphics.draw(img, player.curr_state.seq[frame], player.x, player.y)
end

return player