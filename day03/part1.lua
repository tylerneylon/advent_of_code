#!/usr/local/bin/lua

-- day03/part1.lua

if arg[1] == nil then
  print('Usage: ./part1.lua <filename>')
  os.exit(1)
end

pos = {0, 0}
mov = {['<'] = {-1, 0}, ['>'] = {1, 0}, ['v'] = {0, -1}, ['^'] = {0, 1}}

text = io.open(arg[1]):read('*a')
houses = {}  -- This is used as a set of keys; all values are true.
for i = 1, #text do
  local dir = text:sub(i, i)
  if mov[dir] then
    pos[1] = pos[1] + mov[dir][1]
    pos[2] = pos[2] + mov[dir][2]
  end
  houses[string.format('%d,%d', pos[1], pos[2])] = true
end

n = 0
for k in pairs(houses) do n = n + 1 end
print(n)
