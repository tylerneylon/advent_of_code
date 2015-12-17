#!/usr/local/bin/lua

-- day07/part1.lua

-- Notes:
-- 1. This script requires Lua 5.3 as it uses bitwise operators.
-- 2. Part 1 of the problem is solved by running this script on input1.
--    Part 2 is solved by running this script on input2.

if arg[1] == nil then
  print('Usage: ./part1.lua <filename>')
  os.exit(1)
end

-- This maps ids to their numeric values.
-- Use set_val to set values, though, which checks for overflow and underflow.
vals = {}

-- This is a sequence of gates. Each gate has the format
-- {inputs, action, output, inp_needed}. When inp_needed reaches 0, we have
-- enough info to compute it.
gates = {}

function pr(...)
  print(string.format(...))
end

function set_val(id, val)
  assert(type(val) == 'number')
  assert(val >= 0)
  assert(val <= 65535)
  -- pr('Setting id %s to %d', id, val)
  vals[id] = val
end

function get_inp(id_or_val)
  local v = tonumber(id_or_val)
  if v then return v end
  return vals[id_or_val]  -- If we get here, it wasn't a number.
end

function process_gate(key, g)

  --[[
  pr('process_gate({output=%s})', g.output)
  for k, v in pairs(g) do
    print(k, v)
  end
  --]]

  local inp1 = get_inp(g.inputs[1])
  if inp1 == nil then return end

  if g.action == 'NOT' then
    set_val(g.output, ~inp1 & 0xFFFF)
    gates[key] = nil
    return
  end

  if g.action == 'DIRECT' then
    set_val(g.output, inp1)
    gates[key] = nil
    return
  end

  -- Otherwise it must have two inputs.
  local inp2 = get_inp(g.inputs[2])
  if inp2 == nil then return end

  if g.action == 'AND' then
    set_val(g.output, inp1 & inp2)
  elseif g.action == 'OR' then
    set_val(g.output, inp1 | inp2)
  elseif g.action == 'LSHIFT' then
    set_val(g.output, inp1 << inp2)
  elseif g.action == 'RSHIFT' then
    set_val(g.output, inp1 >> inp2)
  else
    assert(false, 'Error: unknown action: ' .. g.action)
  end
  gates[key] = nil
end

for line in io.lines(arg[1]) do

  local did_match = false

  -- Check for direct inputs.
  local inp, id = line:match('^(%w+) %-> (%a+)$')
  if inp then
    gates[#gates + 1] = {inputs = {inp}, action = 'DIRECT', output = id}
    did_match = true
  end

  -- Check for NOT gates.
  local input, id = line:match('^NOT (%w+) %-> (%a+)$')
  if input then
    gates[#gates + 1] = {inputs = {input}, action = 'NOT', output = id}
    did_match = true
  end

  -- Check for all other gate types.
  local inp1, action, inp2, id = line:match('^(%w+) (%w+) (%w+) %-> (%a+)$')
  if inp1 then
    gates[#gates + 1] = {inputs = {inp1, inp2}, action = action, output = id}
    did_match = true
  end

  assert(did_match, 'Line failed to match: ' .. line)
end

pass_num = 1
while next(gates) do
  print('Starting pass ' .. pass_num)
  num_gates_hit = 0
  for index, gate in pairs(gates) do
    process_gate(index, gate)
    num_gates_hit = num_gates_hit + 1
  end
  pass_num = pass_num + 1
  print('  considered ' .. num_gates_hit .. ' gates')
end

print('Done!')

pr('Value at id a is ' .. vals.a)
