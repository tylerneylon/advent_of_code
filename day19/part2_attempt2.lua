#!/usr/local/bin/lua

-- day19/part2_attempt2.lua

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
print('#start_str = ' .. #start_str)

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

-- mem[s] = shortest_dist_from_s_to_e (if known)
mem = {}
num_mem = 0
longest_mem = 0

function new_mem(s, d)
  mem[s] = d
  num_mem = num_mem + 1
  if num_mem % 1000 == 0 or #s > longest_mem then
    io.write(string.format('\rnum_mem=%7d longest=%4d', num_mem, longest_mem))
    io.flush()
  end
  longest_mem = math.max(longest_mem, #s)
  return d
end

-- Use memoization to find the shortest distance from s to e.
function dist_to_e(s, from)
  --[[
  print('dist_to_e(#s = ' .. #s .. ')')
  if #s < 32 then
    print('  from = ' .. from)
    print('  s    = ' .. s)
  end
  --]]
  if mem[s] then return mem[s] end
  local d = math.huge
  for a, new_part in adj(s) do
    if a == 'e' then
      return new_mem(s, 1)
    end
    if new_part ~= 'e' then
      d = math.min(d, dist_to_e(a, s) + 1)
    end
  end
  return new_mem(s, d)
end

print(dist_to_e(start_str))
