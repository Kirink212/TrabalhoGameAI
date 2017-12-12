local map = {
	tileSize = 32,
	width = 800,
	height = 600,
	grid = {}
}

local boxSize = 255
--[[
	Function to read TXT archives,
	transforming each positions in
	a grid's position
]]
local function loadMapGrid(filename)
	local archive = io.open(filename)
	local i = 1

	-- For each line in archive
	for line in archive:lines() do
		map.grid[i] = {}
		-- Counting lines
		map.grid.total_lines = map.grid.total_lines + 1
		-- For each char in line
		-- ZERATE PRA NAO DAR MERDATE
		map.grid.total_cols = 0
		for j=1, #line do
			-- Counting columns
			map.grid.total_cols = map.grid.total_cols + 1
			-- Use substring to get exacly what
			-- you're reading
			map.grid[i][j] = line:sub(j,j)
    	end
    	i = i + 1
  	end
	archive:close()
end

function map.load()
	-- map.grid total number of columns
	map.grid.total_cols = 0

	-- map.grid total number of lines
	map.grid.total_lines = 0

	--Box image
	box_image = love.graphics.newImage("assets/box_image.png")
	boxScale = map.tileSize/boxSize
	map.grid.pattern = { 
		B = box_image
	}

	-- Calling function loadMapGrid
	loadMapGrid("mapa_teste.txt")
end

function map.draw()
	-- Iterating in map.grid matrix
	for i=1, map.grid.total_lines do
		for j=1, map.grid.total_cols do
			local tipo = map.grid[i][j]
			local s = map.tileSize
			-- X in the TXT archive means
			-- there is no image to be placed
			-- in that specific position
			if tipo ~= "X" then
        	--love.graphics.print(tostring(tipo), (j-1)*s, (i-1)*s)
				love.graphics.draw(map.grid.pattern[tipo], (j-1)*s, (i-1)*s, 0, boxScale, boxScale)
			end
		end
	end
end

return map