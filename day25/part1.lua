#!/usr/local/bin/lua

-- day25/part1.lua

v = 18168397

function next(x)
  return (x * 252533) % 33554393
end

x = 20151125
for i = 1, v - 1 do
  x = next(x)
end

print(x)
