#!/usr/local/bin/lua

-- day16/part1.lua

if arg[1] == nil then
  print('Usage: ./part1.lua <filename>')
  os.exit(1)
end

-- sues[i] = {<known_properties>}
sues= {}

-- Read in the file.
for line in io.lines(arg[1]) do
  local sue = {}
  for prop_name, val in line:gmatch('(%w+): (%d+)') do
    sue[prop_name] = tonumber(val)
  end
  sues[#sues + 1] = sue
end

-- The ticker tape says:
the_sue = {
  children    = 3,
  cats        = 7,
  samoyeds    = 2,
  pomeranians = 3,
  akitas      = 0,
  vizslas     = 0,
  goldfish    = 5,
  trees       = 3,
  cars        = 2,
  perfumes    = 1
}

function are_props_ok(prop_name, the_val, a_val)
  if prop_name == 'trees' or prop_name == 'cats' then
    return the_val < a_val
  elseif prop_name == 'pomeranians' or prop_name == 'goldfish' then
    return the_val > a_val
  else
    return the_val == a_val
  end
end

for i = 1, #sues do
  local is_match = true
  for prop_name, val in pairs(the_sue) do
    if sues[i][prop_name] and
       not are_props_ok(prop_name, the_sue[prop_name], sues[i][prop_name]) then
      is_match = false
      break
    end
  end
  if is_match then
    print('Match: ' .. i)
  end
end
