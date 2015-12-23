#!/usr/local/bin/lua

-- day20/part2.lua

if arg[1] == nil then
  print('Usage: ./part2.lua <num>')
  os.exit(1)
end

k = 50  -- max num houses per elf

m = tonumber(arg[1])

function var_sigma(n)
  local sqrt_n = math.sqrt(n)
  local s = 0
  for i = 1, math.huge do
    if i > sqrt_n then
      return s
    end
    if n % i == 0 then
      local j = n / i
      if j <= k then s = s + i end
      if i <= k and i ~= j then s = s + j end
    end
  end
end

for i = 1, math.huge do
  local j = var_sigma(i)
  if j >= m then
    print('var_sigma(' .. i .. ') = ' .. j .. ' ≥ ' .. m)
    os.exit(0)
  end
end
