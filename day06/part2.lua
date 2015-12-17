#!/usr/local/bin/lua

-- day06/part2.lua

if arg[1] == nil then
  print('Usage: ./part2.lua <filename>')
  os.exit(1)
end

-- Keys are "x,y" strings.
-- The value nil is synonymous with 0.
lights = {}

function toggle(old_value)
  if old_value then return nil end
  return true
end

function update(action, x1, y1, x2, y2)
  for x = x1, x2 do for y = y1, y2 do
    local key = string.format('%d,%d', x, y)
    local old_val = lights[key] or 0
    if action == 'turn on' then
      lights[key] = old_val + 1
    elseif action == 'turn off' then
      lights[key] = math.max(old_val - 1, 0)
    elseif action == 'toggle' then
      lights[key] = old_val + 2
    else
      assert(false, 'Unexpected action string: "' .. action .. '"')
    end
  end end
end

line_num = 1
pattern = '([%w ]+) (%d+),(%d+) through (%d+),(%d+)'
for line in io.lines(arg[1]) do
  if line_num % 10 == 0 then
    io.write('\rLine: ' .. line_num)
    io.flush()
  end
  local _, _, action, x1, y1, x2, y2 = line:find(pattern)
  assert(action, 'Error parsing the line: ' .. line)  -- Just in case.
  update(action, x1, y1, x2, y2)
  line_num = line_num + 1
end

-- Count the number of lights on.
n = 0
for _, val in pairs(lights) do
  n = n + val
end

print('\n' .. n)
