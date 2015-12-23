#!/usr/local/bin/lua

-- day19/part2_attempt1.lua

-- This one guarantees finding the right answer but was too slow on the official
-- input.

if arg[1] == nil then
  print('Usage: ./part2.lua <filename>')
  os.exit(1)
end

-- moves[i] = {from, to}
moves = {}
start_str = nil

-- Read in the file.
mode = 'moves'  -- or 'start_str'
for line in io.lines(arg[1]) do
  if line == '' then
    mode = 'start_str'
  elseif mode == 'moves' then
    local from, to = line:match('(%w+) => (%w+)')
    moves[#moves + 1] = {from, to}
  else
    start_str = line
  end
end

-- Define an iterator over strings backwards-adjacent to an input.
function adj(s)
  local i, j = 1, 1
  local iter = function ()
    while true do
      if i > #moves then return nil end
      local from, to = moves[i][2], moves[i][1]
      local first, last = s:find(from, j, true)
      if first then
        local out = s:sub(1, first - 1) .. to .. s:sub(last + 1)
        j = first + 1
        return out, to
      end
      i = i + 1
      j = 1
    end
  end
  return iter
end

-- We'll basically do a breadth-first search from start_str back to e.

-- d[s] = shortest-known dist to string s from start_str
d = {}

explore_now  = {[start_str] = true}
explore_next = {}
explored     = {}

num_steps = 1

while true do
  for s in pairs(explore_now) do
    -- print('s = ' .. s)
    for a, new_part in adj(s) do
      -- print('  a = ' .. a)
      if a == 'e' then
        print(num_steps)
        os.exit(0)
      end
      if new_part ~= 'e' and not explored[a] and not explore_now[a] then
        explore_next[a] = true
      end
    end
    explored[s] = true
  end
  explore_now, explore_next = explore_next, {}
  num_steps = num_steps + 1
  print('num_steps = ' .. num_steps)
  -- print('#explored = ' .. #explored)
  -- print('#explore_now = ' .. #explore_now)
  -- print('')
end
