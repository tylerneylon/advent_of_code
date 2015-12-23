#!/usr/local/bin/lua

-- day19/part1.lua

if arg[1] == nil then
  print('Usage: ./part1.lua <filename>')
  os.exit(1)
end

-- moves[i] = {from, to}
moves = {}
start_str = nil

-- Read in the file.
mode = 'moves'  -- or 'start_str'
for line in io.lines(arg[1]) do
  if line == '' then
    mode = 'start_str'
  elseif mode == 'moves' then
    local from, to = line:match('(%w+) => (%w+)')
    moves[#moves + 1] = {from, to}
  else
    start_str = line
  end
end

-- This is a key set; out_strs[out_str] = true.
out_strs = {}

-- Calculate all output strings.
num_out = 0
for i, move in ipairs(moves) do
  local from, to = move[1], move[2]
  local j = 1
  while true do
    local first, last = start_str:find(from, j, true)  -- true = plaintext
    if first == nil then break end
    local out = start_str:sub(1, first - 1) .. to .. start_str:sub(last + 1)
    if out_strs[out] == nil then
      num_out = num_out + 1
    end
    out_strs[out] = true
    j = first + 1
  end
end
print(num_out)
