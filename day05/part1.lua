#!/usr/local/bin/lua

-- day05/part1.lua

if arg[1] == nil then
  print('Usage: ./part1.lua <filename>')
  os.exit(1)
end

function is_nice(s)
  -- Check for 3 vowels.
  local _, num_vowels = s:gsub('[aeiou]', '')
  if num_vowels < 3 then return false end

  -- Check for a double letter.
  if not s:find('(.)%1') then return false end

  -- Check for forbidden substrings.
  local baddies = {'ab', 'cd', 'pq', 'xy'}
  for _, baddy in pairs(baddies) do
    if s:find(baddy) then return false end
  end

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

