#!/usr/local/bin/lua

-- day23/part2.lua

if arg[1] == nil then
  print('Usage: ./part2.lua <filename>')
  os.exit(1)
end

-- code[i] = {instruction, param1, param2}
code = {}

for line in io.lines(arg[1]) do
  local inst = line:match('%w+')
  if inst == 'hlf' or inst == 'tpl' or inst == 'inc' then
    code[#code + 1] = {inst, line:match('%w$')}
  elseif inst == 'jmp' then
    code[#code + 1] = {inst, tonumber(line:match(' (.?%d+)$'))}
  else
    local r, offset = line:match('(%w), (.?%d+)')
    code[#code + 1] = {inst, r, tonumber(offset)}
  end
  -- io.write('Latest line is: ')
  -- for _, v in ipairs(code[#code]) do io.write(v .. ' ') end
  -- print('')
end

i = 1               -- instruction pointer
r = {a = 1, b = 0}  -- registers

while 1 <= i and i <= #code do
  local c = code[i]
  -- io.write('i=' .. i)
  -- io.write(' a=' .. r.a)
  -- io.write(' b=' .. r.b)
  -- print(' instr=', unpack(c))
  i = i + 1
  if c[1] == 'hlf' then
    r[c[2]] = math.floor(r[c[2]] / 2)
  elseif c[1] == 'tpl' then
    r[c[2]] = r[c[2]] * 3
  elseif c[1] == 'inc' then
    r[c[2]] = r[c[2]] + 1
  elseif c[1] == 'jmp' then
    i = i - 1 + c[2]
  elseif c[1] == 'jie' then
    if r[c[2]] % 2 == 0 then
      i = i - 1 + c[3]
    end
  elseif c[1] == 'jio' then
    if r[c[2]] == 1 then
      i = i - 1 + c[3]
    end
  end
end

print('Final value of register b = ' .. r.b)

