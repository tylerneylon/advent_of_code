#!/usr/local/bin/lua

-- day08/part1.lua

if arg[1] == nil then
  print('Usage: ./part1.lua <filename>')
  os.exit(1)
end

dbg = false

code_len = 0
mem_len  = 0

function pr(...)
  if dbg then
    print(string.format(...))
  end
end

function add_line(line)
  pr('line: ' .. line)
  pr('  adding ' .. #line .. ' to code_len')
  code_len = code_len + #line
  line = line:sub(2, -2)  -- Drop starting, ending quotes.
  line = line:gsub([[\\]], [[-]])
  line = line:gsub([[\"]], [["]])
  line = line:gsub([[\x..]], [[_]])
  pr('  unescaped line: ' .. line)
  pr('  adding ' .. #line .. ' to mem_len')
  mem_len = mem_len + #line
end

for line in io.lines(arg[1]) do
  add_line(line)
end

print('code_len: ' .. code_len)
print('mem_len: ' .. mem_len)
print('delta: ' .. (code_len - mem_len))
