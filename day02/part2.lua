#!/usr/local/bin/lua

-- day02/part2.lua

-- This expects d = {w, h, l}; d stands for dimensions.
function ribbon_needed(d)
  assert(#d == 3 and type(d[1]) == 'number')
  table.sort(d)
  return 2 * (d[1] + d[2]) + d[1] * d[2] * d[3]
end

if arg[1] == nil then
  print('Usage: ./part1.lua <filename>')
  os.exit(1)
end

f = io.open(arg[1])
n = 0
for line in f:lines() do
  -- line does not include the ending newline character.
  local dims = {}
  for d in line:gmatch('%d+') do
    dims[#dims + 1] = tonumber(d)
  end
  -- print(string.format('Dims=%s, needed=%d', line, ribbon_needed(dims)))
  n = n + ribbon_needed(dims)
end
print(n)
