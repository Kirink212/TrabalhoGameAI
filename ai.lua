local ai = {
    position = {},
    grid = {},
    goal = {},
    previous = {},
  }
  
local path = {}

--local file = io.open("path.txt", "w")

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
  Function to return the best
  path towards the goal using
  the cost function
  (Greedy search)
]]
function ai.nextStep(map)
  local current = {
    i = ai.position.i,
    j = ai.position.j
  }
  
  if current.i == ai.goal.i and current.j == ai.goal.j then
    return "stop"
  end
  
  local n = getNeighbors(current.i, current.j)
  local new_n = {}
  --[[for i=1, #n do
    local neighbor = n[i] 
    if ai.grid[neighbor.i][neighbor.j] == "J" then
      table.insert(new_n, neighbor)
    end
  end

  for i=1, #n do
    local neighbor = n[i] 
    if ai.grid[neighbor.i][neighbor.j] == "X" and (neighbor.i ~= ai.previous.i or neighbor.j ~= ai.previous.j) then
      table.insert(new_n, neighbor)
    end
  end
  
  for i=1, #n do
    local neighbor = n[i]
    if neighbor.i == ai.previous.i or neighbor.j == ai.previous.j then
      table.insert(new_n, neighbor)
    end
  end]]
  
  while #n > 0 do
    local lowest = 1
    for i=1, #n do
      if ai.grid[n[i].i][n[i].j] < ai.grid[n[lowest].i][n[lowest].j] then
        lowest = i
      end
    end
    table.insert(new_n, n[lowest])
    table.remove(n, lowest)
  end

  print(#new_n)
  for i=1, #new_n do
    print(ai.grid[new_n[i].i][new_n[i].j] .. " " .. new_n[i].i .. " " .. new_n[i].j)
  end

  print("next i= " .. new_n[1].i .. " j= " .. new_n[1].j .. "")
  if map.grid[new_n[1].i][new_n[1].j] == "B" then
    ai.setObstacle(new_n[1].i, new_n[1].j)
    return "stop"
  elseif new_n[1].i > ai.position.i then
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
      ai.grid[i][j] = 0
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
  ai.previous.i = ai.position.i
  ai.previous.j = ai.position.j
  ai.position.i = i
  ai.position.j = j
  ai.grid[i][j] = ai.grid[i][j] + 1
  --ai.grid[i][j] = "X"
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