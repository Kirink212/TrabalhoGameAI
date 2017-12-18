local ai = {
    position = {},
    grid = {},
    goal = {},
  }
local path = {}

--local file = io.open("path.txt", "w")

--[[
  Returns distance between x and y
]]
local function distance(x, y)
  return math.abs(x - y)
end
  
--[[
  Function to calculate cost
  to node [i, j] if node
  [i, j] is a box, cost is 100
  else, cost is distance from
  node [i, j] to goal
]]--
local function cost(i, j)
  if ai.grid[i][j] ~= "X" then
    return 100
  else
    return distance(i, ai.goal.i) + distance(j, ai.goal.j)
  end
end

--[[
  Function returns valid 
  neighbors of node [i, j]
]]
function getNeighbors(i, j)
  local neighbors = {}
  
  if i + 1 <= ai.grid.total_lines and ai.grid[i+1][j] ~= "B" then
    table.insert(neighbors, {i = i+1, j = j})
  end
  if i - 1 > 0  and ai.grid[i-1][j] ~= "B" then
    table.insert(neighbors, {i = i-1, j = j})
  end
  if j + 1 <= ai.grid.total_cols  and ai.grid[i][j+1] ~= "B" then
    table.insert(neighbors, {i = i, j = j+1})
  end
  if j - 1 > 0  and ai.grid[i][j-1] ~= "B" then
    table.insert(neighbors, {i = i, j = j-1})
  end
  
  return neighbors
end

--[[
  Function returns index if
  an item is in a table,
  otherwise false
]]
local function inTable(tbl, item)
  for key, value in pairs(tbl) do
    if value.i == item.i and value.j == item.j then return key end
  end
  return false
end

--[[
  Function to return the best
  path towards the goal using
  the cost function
  (Greedy search)
]]
function ai.nextStep()
  local current = {
    i = ai.position.i,
    j = ai.position.j
  }
  
  local n = getNeighbors(current.i, current.j)
  local new_n = {}
  for i=1, #n do
    local neighbor = n[i] 
    if ai.grid[neighbor.i][neighbor.j] == "J" then
      table.insert(new_n, neighbor)
    end
  end

  for i=1, #n do
    local neighbor = n[i] 
    if ai.grid[neighbor.i][neighbor.j] == "X" then
      table.insert(new_n, neighbor)
    end
  end

  for i=1, #new_n do
    print(ai.grid[new_n[i].i][new_n[i].j])
  end

  if new_n[1].i > ai.position.i then
    return "down"
  elseif new_n[1].i < ai.position.i then
    return "up"
  elseif new_n[1].j > ai.position.j then
    return "right"
  elseif new_n[1].j < ai.position.j then
    return "left"
  end
end

--[[
  Set the map size for the
  AI to know which nodes are
  valid
]]
function ai.setMapSize(x, y)
  ai.grid.total_lines = x
  ai.grid.total_cols = y
  for i=1, x do
    ai.grid[i] = {}
    for j=1, y do
      ai.grid[i][j] = "J"
    end
  end
end

--[[
  Set the AI goal for the
  bestPath search
]]
function ai.setGoal(i, j)
  ai.goal.i = i
  ai.goal.j = j
end

--[[
  Set the AI current location.
  Should always be used to
  update AI location
]]
function ai.setLocation(i, j)
  ai.position.i = i
  ai.position.j = j
end

--[[
  Adds a box on the target
  node [i, j]
]]
function ai.setObstacle(i, j)
  ai.grid[i][j] = "B"
end

--[[
  Clears path table.
  Should be used when
  current path is wrong
  and needs to be recalculated
]]
function ai.clearPath()
  for i in pairs(path) do
    path[i] = nil
  end
end

--[[
  Returns the next step
  on the AI path
]]
-- function ai.nextStep()
--   local index = inTable(path, ai.position) + 1
--   if index > #path then
--     return "stop"
--   end
-- end

return ai