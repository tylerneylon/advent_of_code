#!/usr/local/bin/lua

-- day03/part2.lua

if arg[1] == nil then
  print('Usage: ./part2.lua <filename>')
  os.exit(1)
end

pos = {[0] = {0, 0}, [1] = {0, 0}}
mov = {['<']  = {-1, 0}, ['>'] = {1, 0}, ['v'] = {0, -1}, ['^'] = {0, 1}}

text = io.open(arg[1]):read('*a')
houses = {['0,0'] = true}  -- This is a set of keys; all values are true.
for i = 1, #text do
  local j = (i - 1) % 2  -- j = 0 means santa, j = 1 means robo-santa
  local dir = text:sub(i, i)
  if mov[dir] then
    pos[j][1] = pos[j][1] + mov[dir][1]
    pos[j][2] = pos[j][2] + mov[dir][2]
  end
  houses[string.format('%d,%d', pos[j][1], pos[j][2])] = true
end

n = 0
for k in pairs(houses) do n = n + 1 end
print(n)
