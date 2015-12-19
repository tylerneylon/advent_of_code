#!/usr/local/bin/lua

-- day12/part1.lua

if arg[1] == nil then
  print('Usage: ./part1.lua <filename>')
  os.exit(1)
end

sum = 0
for line in io.lines(arg[1]) do
  for num in line:gmatch('%-?%d+') do
    sum = sum + num
    --print(num)
  end
end

print('sum: ' .. sum)
