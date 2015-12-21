#!/usr/local/bin/lua

-- day17/part2.lua

if arg[1] == nil then
  print('Usage: ./part2.lua <filename>')
  os.exit(1)
end

-- holders[i] = capacity of ith container
holders = {}

-- Read in the file.
for line in io.lines(arg[1]) do
  holders[#holders + 1] = tonumber(line:match('%d+'))
end

-- This returns true if it is able to provide the next subset in place; that is,
-- it alters the value of s.
function next_subset(s, n, start)
  start = start or 1

  if #s == 0 then
    for i = 1, n do s[i] = 0 end
    return true
  end

  if start < n and next_subset(s, n, start + 1) then
    return true
  end

  if s[start] == 0 then
    s[start] = 1
    for i = start + 1, n do s[i] = 0 end
    return true
  end

  return false
end

function subset_as_str(set)
  local s = '{'
  for i, val in ipairs(set) do
    if i > 1 then s = s .. ', ' end
    s = s .. val
  end
  return s .. '}'
end

function subset_sum(set)
  local sum = 0
  for i = 1, #set do
    sum = sum + set[i] * holders[i]
  end
  return sum
end

function subset_size(set)
  local size = 0
  for i = 1, #set do
    size = size + set[i]
  end
  return size
end

-- 1. Find the min number of holders needed.
min_holders = math.huge
s = {}
while next_subset(s, 20) do
  if subset_sum(s) == 150 then
    min_holders = math.min(min_holders, subset_size(s))
  end
end

-- 2. Find the number of combos that use the min possible #holders.
num_combos = 0
s = {}
while next_subset(s, 20) do
  if subset_size(s) == min_holders and subset_sum(s) == 150 then
    num_combos = num_combos + 1
  end
end

print(num_combos)
