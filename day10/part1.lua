#!/usr/local/bin/lua

-- day10/part1.lua

if arg[1] == nil then
  print('Usage: ./part1.lua <init_number>')
  os.exit(1)
end

-- This expects n to be a sequence table, and returns a sequence table.
function next_num(num)
  local pieces = {}
  local i = 1
  local n = #num
  while i <= n do
    local d = num[i]
    local count = 1
    while i + count <= n and num[i + count] == d do
      count = count + 1
    end
    assert(count < 10)
    pieces[#pieces + 1] = tostring(count)
    pieces[#pieces + 1] = d
    i = i + count
  end
  return pieces
end

num_str = arg[1]
num = {}
for i = 1, #num_str do
  num[i] = num_str:sub(i, i)
end

for i = 1, 50 do
  num = next_num(num)
  print(i .. ': #digits = ' .. #num)
end
