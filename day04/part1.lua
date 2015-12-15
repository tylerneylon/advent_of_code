#!/usr/local/bin/lua

-- day04/part1.lua

md5 = require 'md5'

if arg[1] == nil then
  print('Usage: ./part1.lua <pre-hash-prefix>')
  os.exit(1)
end

--[[ This was slow.
function md5(s)
  local pipe = io.popen('md5 -s ' .. s)
  local out  = pipe:read('*a')
  pipe:close()
  _, _, hash = out:find('= (%w+)\n')
  return hash
end
--]]

prefix = arg[1]
n = 1
while true do
  h = md5.sumhexa(prefix .. n)
  if h:sub(1, 5) == '00000' then
    print('\n' .. n)
    break
  end
  n = n + 1
  if n % 1000 == 0 then
    io.write('\rWorking: ' .. n)
    io.flush()
  end
end
