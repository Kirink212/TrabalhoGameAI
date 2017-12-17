local ai = {
    position = {},
    grid = {},
    goal = {},
  }
local path = {}
  
local function distance(x, y)
  return math.abs(x - y)
end
  
--[[
  Function to calculate cost
  to node [i, j] if node
  [i, j] is a box, cost is 100
  else, cost is distance from
  start to node [i, j] +
  distance from node [i, j] to goal
  (A* search)
]]--
local function cost(i, j)
  if ai.grid[i][j] ~= "X" then
    return 100
  else
    --return distance(ai.position.i, i) + distance(ai.position.j, j) + distance(i, ai.goal.i) + distance(j, ai.goal.j)
    return distance(i, ai.goal.i) + distance(j, ai.goal.j)
  end
end
  
local function getNeighbors(i, j)
  local neighbors = {}
  
  if i + 1 <= ai.grid.total_lines then
    table.insert(neighbors, {i = i+1, j = j})
  end
  if i - 1 > 0 then
    table.insert(neighbors, {i = i-1, j = j})
  end
  if j + 1 <= ai.grid.total_cols then
    table.insert(neighbors, {i = i, j = j+1})
  end
  if j - 1 > 0 then
    table.insert(neighbors, {i = i, j = j-1})
  end
  
  return neighbors
end

--[[
  Function returns true if
  an item is in a table,
  otherwise false
]]
local function inTable(tbl, item)
  for key, value in pairs(tbl) do
    if value.i == item.i and value.j == item.j then return key end
  end
  return false
end

local function clearTable(tbl)
  for i=#tbl, 0 do
    table.remove(tbl,i)
  end
end

--[[
  Function to return the best path towards the goal
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
      if not inTable(path, neighbor) then
        neighbor_cost = cost(neighbor.i, neighbor.j)
        if neighbor_cost < best then
          best = neighbor_cost
          best_index = index
        end
      end
    end
    table.insert(path, neighbors[best_index])
    current.i = neighbors[best_index].i
    current.j = neighbors[best_index].j
  end
  return path
end

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

function ai.setGoal(i, j)
  ai.goal.i = i
  ai.goal.j = j
end

function ai.setLocation(i, j)
  ai.position.i = i
  ai.position.j = j
end

function ai.setObstacle(i, j)
  ai.grid[i][j] = "B"
end

function ai.clearPath()
  clearTable(path)
end

function ai.nextStep()
  local step = next(path, inTable(path, ai.position))
  return path[step]
end

return ai