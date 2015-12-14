#!/usr/local/bin/lua

-- day01/part1.lua

if arg[1] == nil then
  print('Usage: ./part1.lua <filename>')
  os.exit(1)
end

text = io.open(arg[1]):read('*a')
_, up   = text:gsub('%(', '')
_, down = text:gsub('%)', '')
print(up - down)
