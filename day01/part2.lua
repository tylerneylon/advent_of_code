#!/usr/local/bin/lua

-- day01/part2.lua

if arg[1] == nil then
  print('Usage: ./part2.lua <filename>')
  os.exit(1)
end

up   = ('('):byte()
down = (')'):byte()
move_by = {[up] = 1, [down] = -1}

text  = io.open(arg[1]):read('*a')
bytes = {text:byte(1, -1)}
n     = 0

for i = 1, #bytes do
  if move_by[bytes[i]] then
    n = n + move_by[bytes[i]]
  else
    print(string.format('Error: bad character 0x%X at position %d',
                        bytes[i], i))
    os.exit(1)
  end
  if n == -1 then
    print(i)
    break
  end
end
