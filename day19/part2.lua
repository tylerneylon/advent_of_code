#!/usr/local/bin/lua

-- day19/part2.lua

--[[

Note: This is not an awesome solution because it's more of a heuristic.
      I'm ok with heuristics, but I prefer coding puzzles in which I can have
      confidence that I've gotten the right answer before I submit it.

--]]

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

-- Sort moves according to their delta, and with e-moves last.
function comp(a, b)
  local delta_a = #a[2] - #a[1]
  local delta_b = #b[2] - #b[1]
  return delta_a > delta_b  -- Higher-delta moves go earlier in the list.
end
table.sort(moves, comp)

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

-- Do a greedy depth-first search.
-- I never let this run to completion on the full input because it was slow, but
-- it seemed to find the right answer quickly anyway.

best = math.huge

function to_e(s, d)
  for a, new_part in adj(s) do
    if a == 'e' then
      if d + 1 < best then
        print('Found path of length ' .. (d + 1))
        best = d + 1
      end
      return
    end
    if new_part ~= 'e' then
      to_e(a, d + 1)
    end
  end
end

to_e(start_str, 0)  -- 0 == initial distance from the start string.
