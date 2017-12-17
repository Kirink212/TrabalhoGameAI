local animation = {
  values = {}
}

function animation.create(img, num_lines, num_columns, fps, total_time, begin_line)
	local new_animation = {}
  	new_animation.seq = {}
	local img_width, img_height = img:getDimensions()
	local tile_size = img_width/num_columns
	local pos = 1
	local start = begin_line and begin_line - 1 or 0

	i = start
	for j = 0, num_columns - 1 do
		new_animation.seq[pos] = love.graphics.newQuad(
													j*tile_size, 
													i*tile_size,
													tile_size,
													tile_size,
													img_width,
													img_height
												)
		pos = pos + 1
	end

	new_animation.values = {
		-- number of frames
		n_frames = pos - 1,
		-- frames per second
		fps = fps,
		-- total animation time in seconds
		total_time = total_time,
		-- animation timer
		timer = 0,
		-- current animation frame
		current_frame = 1
	}

	return new_animation
end

function animation.run_frames(dt, anim)
	local a = anim.values
	local time_per_frame = a.fps/a.total_time

	a.timer = a.timer + dt

	if a.timer > time_per_frame then
		a.current_frame = a.current_frame + 1

		if a.current_frame > a.n_frames then
			a.current_frame = 1
		end

		a.timer = 0
	end

end

return animation