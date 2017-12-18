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
  
  if i + 1 <= ai.grid.total_lines and ai.grid[i+1][j] == "X" then
    table.insert(neighbors, {i = i+1, j = j})
  end
  if i - 1 > 0  and ai.grid[i-1][j] == "X" then
    table.insert(neighbors, {i = i-1, j = j})
  end
  if j + 1 <= ai.grid.total_cols  and ai.grid[i][j+1] == "X" then
    table.insert(neighbors, {i = i, j = j+1})
  end
  if j - 1 > 0  and ai.grid[i][j-1] == "X" then
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
  Function returns if a node
  [i, j] can reach the goal
  without going back the path
]]
local function reachesGoal(i, j, current_path)
  if i == ai.goal.i and j == ai.goal.j then
    --file:write("chegou ao destino\n")
    return true
  end
  local neighbors = getNeighbors(i, j)
  table.insert(current_path, {i = i, j = j})
  --file:write("testa i=" .. i .. "\tj= " .. j .. "\n")
  for _,neighbor in ipairs(neighbors) do
    if not inTable(current_path, neighbor) and reachesGoal(neighbor.i, neighbor.j, current_path) then
      table.remove(current_path, #current_path)
      return true
    end
  end
  --file:write("remove i=" .. i .. "\tj= " .. j .. "\n")
  table.remove(current_path, #current_path)
  return false
end

--[[
  Function to return the best
  path towards the goal using
  the cost function
  (Greedy search)
]]
function ai.bestPath()
  local current = {
    i = ai.position.i,
    j = ai.position.j
    }
  local best
  local best_index

  table.insert(path, {i = current.i, j = current.j})
  
  while current.i ~= ai.goal.i or current.j ~= ai.goal.j do
    local neighbors = getNeighbors(current.i, current.j)
    best = 100
    best_index = -1
    for index,neighbor in ipairs(neighbors) do
      if reachesGoal(neighbor.i, neighbor.j, path) then
        neighbor_cost = cost(neighbor.i, neighbor.j)
        --file:write("neighbor_cost: " .. neighbor_cost .. "\tneighbor index: " .. index .. "\n")
        if neighbor_cost <= best then
          best = neighbor_cost
          best_index = index
        end
      end
    end
    --file:write("best_index: " .. best_index .. "\n")
    --for z,k in ipairs(path) do
      --file:write("path " .. z .. " i: " .. k.i .. " j: " .. k.j .. "\n")
    --end
    table.insert(path, neighbors[best_index])
    current.i = neighbors[best_index].i
    current.j = neighbors[best_index].j
  end
  
  return path
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
      ai.grid[i][j] = "X"
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
function ai.nextStep()
  local index = inTable(path, ai.position) + 1
  if index > #path then
    return "stop"
  end
  if path[index].i > ai.position.i then
    return "down"
  elseif path[index].i < ai.position.i then
    return "up"
  elseif path[index].j > ai.position.j then
    return "right"
  elseif path[index].j < ai.position.j then
    return "left"
  end
end

return ai