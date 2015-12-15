#!/usr/local/bin/lua

-- day04/part2.lua

md5 = require 'md5'

if arg[1] == nil then
  print('Usage: ./part2.lua <pre-hash-prefix>')
  os.exit(1)
end

prefix = arg[1]
n = 1
while true do
  h = md5.sumhexa(prefix .. n)
  if h:sub(1, 6) == '000000' then
    print('\n' .. n)
    break
  end
  n = n + 1
  if n % 10000 == 0 then
    io.write('\rWorking: ' .. n)
    io.flush()
  end
end
