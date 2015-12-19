#!/usr/local/bin/lua

-- day12/part2.lua

json = require 'json'

if arg[1] == nil then
  print('Usage: ./part2.lua <filename>')
  os.exit(1)
end

function get_count(obj)
  local sum = 0
  if type(obj) == 'number' then return obj end
  if type(obj) == 'string' then return 0 end

  local k, v     = next(obj)
  local is_array = (type(k) == 'number')  -- This is heuristic.

  for _, v in pairs(obj) do
    sum = sum + get_count(v)
    if v == 'red' and not is_array then return 0 end
  end

  return sum
end

-- Turn this on to help debug.
if false then
  gc = get_count
  ind = ''
  get_count = function (obj)
    print(ind .. 'get_count ' .. json.stringify(obj))
    ind = '  ' .. ind
    local r = gc(obj)
    ind = ind:sub(3)
    print(ind .. 'returned ' .. r)
    return r
  end
end

f = io.open(arg[1])
text = f:read('*a')
f:close()

obj = json.parse(text)
print(get_count(obj))
