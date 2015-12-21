#!/usr/local/bin/lua

-- day15/part1.lua

if arg[1] == nil then
  print('Usage: ./part1.lua <filename>')
  os.exit(1)
end

function next_weighting(w, n, total)

  -- Set up the initial weighting w if appropriate.
  if w == nil then
    w = {}
    for i = 1, n do
      w[i] = 0
    end
    w[n] = total
    return w
  end

  -- Set j to the first index with sum(w[1] .. w[j]) = total.
  local sum = 0
  local j = 0
  while sum < total do
    j = j + 1
    sum = sum + w[j]
  end

  if j == 1 then return nil end  -- This is the end condition.

  -- Increment the right-most weight we can.
  w[j - 1] = w[j - 1] + 1

  -- Set the tail to {0, 0, .. , <rest_of_total>}.
  w[n]     = w[j] - 1
  for i = j, n - 1 do w[i] = 0 end

  return w
end

function w_as_str(w)
  local s = '{'
  for i, val in ipairs(w) do
    if i > 1 then s = s .. ', ' end
    s = s .. val
  end
  return s .. '}'
end

-- ingred[i] = {name, capacity, durability, flavor, texture, calories}
ingreds = {}

function weighted_prop(w, prop_name)
  local sum = 0
  for i = 1, #w do
    sum = sum + ingreds[i][prop_name] * w[i]
  end
  return math.max(sum, 0)
end

function score_of_w(w)
  local props = {'capacity', 'durability', 'flavor', 'texture'}
  local sums = {}
  for _, prop_name in pairs(props) do
    sums[#sums + 1] = weighted_prop(w, prop_name)
  end
  return sums[1] * sums[2] * sums[3] * sums[4]
end

-- Read in the file.
for line in io.lines(arg[1]) do
  local name = line:match('^(%w+)')
  print(name)
  local ingred = {}
  for prop_name, val in line:gmatch('(%w+) (-?%d+)') do
    ingred[prop_name] = tonumber(val)
    print('  ', prop_name, val)
  end
  ingred.name = name
  ingreds[#ingreds + 1] = ingred
end

best_score = 0

-- Consider all possible weightings.
w = nil
while true do
  w = next_weighting(w, #ingreds, 100)
  if w == nil then break end
  local score = score_of_w(w)
  best_score = math.max(score, best_score)
  -- print(w_as_str(w))
end

print('Best score = ' .. best_score)
