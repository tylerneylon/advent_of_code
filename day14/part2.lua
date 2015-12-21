#!/usr/local/bin/lua

-- day14/part2.lua

if arg[1] == nil then
  print('Usage: ./part2.lua <filename>')
  os.exit(1)
end

end_time = 2503

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

-- Read in the file.
for line in io.lines(arg[1]) do
  local name, speed, go, rest = line:match('(%w+).-(%d+).-(%d+).-(%d+)')
  reindeer[name] = {speed = speed, go_time = go, rest_time = rest}
end

-- Tally the points for each second.
for t = 1, end_time do
  local winner = {dist = 0}
  for name in pairs(reindeer) do
    local d = how_far(reindeer[name], t)
    if d > winner.dist then
      winner.dist = d
      winner.names = {name}
    elseif d == winner.dist then
      table.insert(winner.names, name)
    end
  end
  for _, name in pairs(winner.names) do
    reindeer[name].score = (reindeer[name].score or 0) + 1
  end
end

total_winner = {score = 0}
for name, r in pairs(reindeer) do
  if (r.score or 0) > total_winner.score then
    total_winner.score = r.score
    total_winner.name  = name
    total_winner.other = nil
  elseif r.score == total_winner.score then
    total_winner.other = name
  end
end

print('Total winner: ' .. total_winner.name .. ' with ' .. total_winner.score ..
      ' points.')

if total_winner.other then
  print('Warning! Tie with at least ' .. total_winner.other)
end
