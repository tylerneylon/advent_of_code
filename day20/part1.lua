#!/usr/local/bin/lua

-- day20/part1.lua

if arg[1] == nil then
  print('Usage: ./part1.lua <num>')
  os.exit(1)
end

m = tonumber(arg[1])

-- primes[i] = ith prime
primes = {2}

function get_prime(i)
  if primes[i] then return primes[i] end
  for q = primes[#primes] + 1, math.huge do
    local is_q_prime = true
    for j = 1, #primes do
      if q % primes[j] == 0 then
        is_q_prime = false
        break
      end
    end
    if is_q_prime then
      primes[#primes + 1] = q
      return q
    end
  end
end

-- p_decomp[n] = {p1 = a1, p2 = a2, ... } where n = p1^a1 * p2^a2 * ...
p_decomp = {}

function copy(t)
  local new_t = {}
  for k, v in pairs(t) do
    new_t[k] = v
  end
  return new_t
end

function prime_decomp(n)
  if p_decomp[n] then return p_decomp[n] end
  local sqrt_n = math.sqrt(n)
  local p_index = 1
  while true do
    p = get_prime(p_index)
    if p > sqrt_n then
      p_decomp[n] = {[n] = 1}
      return p_decomp[n]
    end
    if n % p == 0 then
      local d = copy(prime_decomp(n / p))
      d[p] = (d[p] or 0) + 1
      p_decomp[n] = d
      return d
    end
    p_index = p_index + 1
  end
end

function print_table(t)
  local s = '{'
  local i = 1
  for k, v in pairs(t) do
    if i > 1 then s = s .. ', ' end
    s = s .. k .. ' = ' .. v
    i = i + 1
  end
  s = s .. '}'
  print(s)
end

function sigma(n)
  if n == 1 then return 1 end
  local d = prime_decomp(n)
  local s = 1
  for p, a in pairs(d) do
    s = s * (p ^ (a + 1) - 1) / (p - 1)
  end
  return s
end

for i = 1, math.huge do
  if sigma(i) >= m then
    print('sigma(' .. i .. ') ≥ ' .. m)
    os.exit(0)
  end
end
