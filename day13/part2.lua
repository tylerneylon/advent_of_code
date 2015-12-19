#!/usr/local/bin/lua

-- day13/part2.lua

if arg[1] == nil then
  print('Usage: ./part2.lua <filename>')
  os.exit(1)
end

-- This is meant to be used in a for loop, as in:
-- for perm in perms(n) do <stuff> end
function perms(n)
  local function iter(state, val)
    if not val then
      val = {}
      for i = 1, n do
        val[i] = i
      end
      return val
    end

    if n < 2 then return nil end

    -- j will be the rightmost index with val[j] < val[j + 1].
    local j = n - 1
    while val[j] > val[j + 1] do
      j = j - 1
      if j == 0 then return nil end  -- Done if val is {n, n - 1, ..., 1}.
    end

    -- k will be the rightmost index with val[k] > val[j].
    local k = n
    while val[k] < val[j] do
      k = k - 1
    end

    val[j], val[k] = val[k], val[j]

    -- Reverse val[j + 1] .. val[n].
    for i = 1, math.huge do
      local a, b = j + i, n - i + 1
      if a >= b then break end
      val[a], val[b] = val[b], val[a]
    end

    return val
  end
  return iter
end

-- happy[from][to] = delta of person `from` sitting next to person `to`.
happy = {}
happy.you = {}

-- Read in the file.
for line in io.lines(arg[1]) do
  local from, sign, num, to = line:match('(%w+) would (%w+) (%d+) .-([A-Z]%w*)')
  local delta = tonumber(num)
  if sign == 'lose' then delta = -delta end
  if happy[from] == nil then happy[from] = {} end
  happy[from][to] = delta
end

-- Make a list of all people.
people = {}
for person in pairs(happy) do
  people[#people + 1] = person
end
people[#people + 1] = 'you'
n = #people

best_happiness = -math.huge

for p in perms(n) do
  local order = {}
  for i = 1, n do
    order[i] = people[p[i]]
  end

  local h = 0
  for i = 1, n do
    local before = (i - 2) % n + 1
    local after  = (i % n) + 1
    h = h + (happy[people[p[i]]][people[p[before]]] or 0)
    h = h + (happy[people[p[i]]][people[p[after]]] or 0)
  end
  best_happiness = math.max(best_happiness, h)
end

print(best_happiness)
