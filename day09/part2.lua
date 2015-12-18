#!/usr/local/bin/lua

-- day09/part2.lua

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

-- dist[from][to] = distance between those two cities
dist = {}

cities = {}
city_set = {}

function track_city(city)
  if dist[city] then return end
  dist[city] = {}
  city_set[city] = true
end

for line in io.lines(arg[1]) do
  local from, to, d = line:match('(%w+) to (%w+) = (%d+)')
  d = tonumber(d)
  track_city(from)
  track_city(to)
  dist[from][to] = d
  dist[to][from] = d
end

for city in pairs(city_set) do
  cities[#cities + 1] = city
end
n = #cities

longest_dist = 0

debug = false

function wr(s)
  if not debug then return end
  io.write(s)
end

for p in perms(n) do
  local last = nil
  local d = 0
  for i = 1, n do
    if i > 1 then wr(' -> ') end
    wr(cities[p[i]])
    if last then
      d = d + dist[last][cities[p[i]]]
    end
    last = cities[p[i]]
  end
  wr('   ' .. d .. '\n')
  longest_dist = math.max(longest_dist, d)
end

print(longest_dist)
