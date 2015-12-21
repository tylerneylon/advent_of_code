#!/usr/local/bin/lua

-- day18/part1.lua

if arg[1] == nil then
  print('Usage: ./part1.lua <filename>')
  os.exit(1)
end

-- grid[x][y] = true for those that are alive.
grid = {}
nx, ny = 0, 0

function get(x, y)
  return grid[x] and grid[x][y]
end

function num_nbors(x, y)
  local num = 0
  for dx = -1, 1 do for dy = -1, 1 do
    if dx ~= 0 or dy ~= 0 then
      if get(x + dx, y + dy) then
        num = num + 1
      end
    end
  end end
  return num
end

-- This returns the number of lights on at the end of the step.
function step()
  io.write('\27[;H')  -- Jump to cursor location 0, 0.
  local next_grid = {}
  local num_on = 0
  for x = 1, nx do
    next_grid[x] = {}
    for y = 1, ny do
      local nbors = num_nbors(x, y)
      if get(x, y) then
        next_grid[x][y] = (nbors == 2 or nbors == 3)
      else
        next_grid[x][y] = (nbors == 3)
      end
      if next_grid[x][y] then num_on = num_on + 1 end
      io.write(next_grid[x][y] and '#' or ' ')
    end
    io.write('\n')
  end
  grid = next_grid
  return num_on
end

-- Read in the file.
for line in io.lines(arg[1]) do
  grid[#grid + 1] = {}
  for i = 1, #line do
    grid[#grid][i] = (line:sub(i, i) == '#' or nil)
  end
  ny = math.max(ny, #line)
end
nx = #grid

print('Grid size: ' .. nx .. 'x' .. ny)

num_on = 0
num_steps = 100

for i = 1, num_steps do
  num_on = step()
end
print('After ' .. num_steps .. ' steps, there are ' .. num_on .. ' lights on.')
