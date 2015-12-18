#!/usr/local/bin/lua

-- day08/part2.lua

if arg[1] == nil then
  print('Usage: ./part2.lua <filename>')
  os.exit(1)
end

dbg = false

code_len = 0
esc_len  = 0

function pr(...)
  if dbg then
    print(string.format(...))
  end
end

function add_line(line)
  pr('line: ' .. line)
  pr('  adding ' .. #line .. ' to code_len')
  code_len = code_len + #line
  line = line:gsub([[\]], [[\\]])
  line = line:gsub([["]], [[\"]])
  pr('  escaped line: ' .. line)
  pr('  adding ' .. (#line + 2) .. ' to esc_len')
  esc_len = esc_len + #line + 2
end

for line in io.lines(arg[1]) do
  add_line(line)
end

print('code_len: ' .. code_len)
print('esc_len: ' .. esc_len)
print('delta: ' .. (esc_len - code_len))
