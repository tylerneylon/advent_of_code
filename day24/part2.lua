#!/usr/local/bin/lua

-- day24/part2.lua

if arg[1] == nil then
  print('Usage: ./part2.lua <filename>')
  os.exit(1)
end

weights = {}

for line in io.lines(arg[1]) do
  table.insert(weights, tonumber(line))
end

sum = 0
for _, w in pairs(weights) do
  sum = sum + w
end

assert(sum % 4 == 0)

s = sum / 4

print('s=' .. s)

-- Functions.

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

function subset_sum(set)
  local sum = 0
  for i = 1, #set do
    sum = sum + set[i] * weights[i]
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

function copy(t)
  local new_t = {}
  for k, v in pairs(t) do
    new_t[k] = v
  end
  return new_t
end

function weight_set_as_str(set)
  local s = '{'
  for i, val in ipairs(set) do
    if val == 1 then
      if #s > 1 then s = s .. ', ' end
      s = s .. weights[i]
    end
  end
  return s .. '}'
end

-- TEMP

print('Would theoretically need to consider ' .. 2 ^ #weights .. ' subsets.')
i = 0

-- Phase 1: Look for small subsets that sum to s.
good = {size = math.huge}
set = {}
while next_subset(set, #weights) do
  if i % 1000 == 0 then io.write('\r' .. i) io.flush() end
  i = i + 1
  if subset_sum(set) == s then
    if subset_size(set) < good.size then
      good.size = subset_size(set)
      good.sets = {copy(set)}
      good.last_i = i
    elseif subset_size(set) == good.size then
      table.insert(good.sets, copy(set))
      good.last_i = i
    end
  end
end
print('')

print('Found ' .. #good.sets .. ' minimal good sets of size ' ..
      good.size)
print('One such set is ' .. weight_set_as_str(good.sets[1]))
print('Last i = ' .. good.last_i)

-- Phase 2: Verify that good sets offer an even split of the remaining weights.
print('')
print('Verifying split exists for these sets.')
verified_sets = {}
best_product = math.huge
for i, gset in ipairs(good.sets) do
  -- print('Verifying split exists for good front set ' .. i)

  w_left = {}
  for j, w in pairs(weights) do
    if gset[j] == 0 then table.insert(w_left, w) end
  end
  assert(#w_left + subset_size(gset) == #weights)

  local set = {}
  local is_ok = false
  while next_subset(set, #w_left) do
    local sum = 0
    for j, w in pairs(w_left) do
      sum = sum + set[j] * w
    end
    if sum == s then
      is_ok = true
      break
    end
  end
  -- print('  result: ' .. (is_ok and 'good' or 'bad'))
  if is_ok then
    table.insert(verified_sets, gset)
    local p = 1
    for j, w in pairs(weights) do
      if gset[j] == 1 then
        p = p * w
      end
    end
    best_product = math.min(p, best_product)
  end
end
print(#verified_sets .. ' sets were verified as good.')
print('')

print('best_product = ' .. best_product)
