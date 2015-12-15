#!/usr/local/bin/lua

-- day05/part2.lua

if arg[1] == nil then
  print('Usage: ./part2.lua <filename>')
  os.exit(1)
end

function is_nice(s)
  -- Check for a non-overlapping pair.
  if not s:find('(..)(.-)%1') then return false end

  -- Check for an x?x pattern.
  if not s:find('(.).%1') then return false end

  return true
end

f = io.open(arg[1])
n = 0
for line in f:lines() do
  if is_nice(line) then
    n = n + 1
    -- print(line)
  end
end
print(n)


