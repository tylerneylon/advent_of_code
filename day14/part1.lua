#!/usr/local/bin/lua

-- day14/part1.lua

if arg[1] == nil then
  print('Usage: ./part1.lua <filename>')
  os.exit(1)
end

-- Input r is a reindeer table, described below when we define the `reindeer`
-- global.
function how_far(r, time)
  local unit_time = r.go_time + r.rest_time
  local num_units = math.floor(time / unit_time)
  local d = num_units * r.speed * r.go_time
  local sec_left = time - unit_time * num_units
  local go_sec_left = math.min(sec_left, r.go_time)
  d = d + r.speed * go_sec_left
  return d
end

-- reindeer[name] = {speed, go_time, rest_time}
reindeer = {}

winner = {dist = 0}

-- Read in the file.
for line in io.lines(arg[1]) do
  local name, speed, go, rest = line:match('(%w+).-(%d+).-(%d+).-(%d+)')
  reindeer[name] = {speed = speed, go_time = go, rest_time = rest}
  local d = how_far(reindeer[name], 2503)
  if d > winner.dist then
    winner.dist = d
    winner.name = name
  end
end

print(winner.name .. ' went ' .. winner.dist .. 'km')
