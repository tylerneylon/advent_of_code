#!/usr/local/bin/lua

-- day11/part1.lua

if arg[1] == nil then
  print('Usage: ./part1.lua <init_number>')
  os.exit(1)
end

first_byte = string.byte('a')
last_byte  = string.byte('z')

-- This expects n to be a sequence table, and returns a sequence table.
function next_str(str)
  local i = #str
  while i > 0 do
    str[i] = str[i] + 1
    if str[i] > last_byte then
      str[i] = first_byte
      i = i - 1
    else
      return str
    end
  end
  return str
end

function str_of_seq(seq)
  return string.char(unpack(seq))
end

bad1 = ('i'):byte()
bad2 = ('l'):byte()
bad3 = ('o'):byte()

-- This expects the input to be a sequence of byte values (numbers).
function is_valid(str)
  local did_find_triple = false
  for i = 1, #str - 2 do
    if str[i + 1] == str[i] + 1 and
       str[i + 2] == str[i + 1] + 1 then
      did_find_triple = true
      break
    end
  end
  if not did_find_triple then return false end

  for i = 1, #str do
    if str[i] == bad1 or str[i] == bad2 or str[i] == bad3 then
      return false
    end
  end

  local s = str_of_seq(str)
  local double1, double2 = s:match('(.)%1.-(.)%2')
  return double1 ~= double2
end

s = {arg[1]:byte(1, -1)}

while true do
  s = next_str(s)
  if is_valid(s) then
    print(str_of_seq(s))
    os.exit(0)
  end
end
