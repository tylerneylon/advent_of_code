#!/usr/local/bin/lua

-- day21/part1.lua

-- Set up the weapons, armor, and rings sequence tables.
cat_name = ''
fields = {'cost', 'damage', 'armor'}
for line in io.lines('items') do
  if line ~= '' then
    local category = line:match('(%w+):')
    if category then
      cat_name = category:lower()
      _G[cat_name] = {}
    else
      local i = 1
      for val in line:gmatch('(%+?%d+)') do
        if val:sub(1, 1) ~= '+' then
          if i == 1 then table.insert(_G[cat_name], {}) end
          _G[cat_name][#_G[cat_name]][fields[i]] = tonumber(val)
          i = i + 1
        end
      end
    end
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

--[[
print('weapons:')
for k, v in pairs(weapons) do
  io.write(k ..'  ')
  print_table(v)
end

print('armor:')
for k, v in pairs(armor) do
  io.write(k ..'  ')
  print_table(v)
end

print('rings:')
for k, v in pairs(rings) do
  io.write(k ..'  ')
  print_table(v)
end
--]]

boss   = {hp = 12, damage = 7, armor = 2}
player = {hp =  8, damage = 5, armor = 5}

boss   = {hp = 100, damage = 8, armor = 2}

function will_player_win(player)
  local fighters = {player, boss}
  for turn = 1, math.huge do
    -- Attacker/defender indexes.
    local att_i = (turn - 1) % 2 + 1
    local def_i = 3 - att_i
    local attacker, defender = fighters[att_i], fighters[def_i]
    local d = attacker.damage - defender.armor
    if d < 1 then d = 1 end
    defender.hp = defender.hp - d
    print((def_i == 1 and 'player' or 'boss') .. ' now has ' .. defender.hp ..
          ' hit point(s).')
    if defender.hp <= 0 then
      return att_i == 1
    end
  end
end

function will_player_win2(player)
  local damage_to_boss   = player.damage -   boss.armor
  local damage_to_player =   boss.damage - player.armor
  local num_turns_to_kill_boss   = math.ceil(boss.hp / damage_to_boss)
  local num_turns_to_kill_player = math.ceil(player.hp / damage_to_player)
  return num_turns_to_kill_boss <= num_turns_to_kill_player
end

function add_prop(pl, prop, val)
  pl[prop] = (pl[prop] or 0) + val
end

function setup_player(w, a, r1, r2)
  local p = {hp = 100}
  add_prop(p, 'damage', weapons[w].damage)
  add_prop(p, 'armor', weapons[w].armor)
  if armor[a] then
    add_prop(p, 'damage', armor[a].damage)
    add_prop(p, 'armor', armor[a].armor)
  end
  if rings[r1] then
    add_prop(p, 'damage', rings[r1].damage)
    add_prop(p, 'armor', rings[r1].armor)
  end
  if rings[r2] then
    add_prop(p, 'damage', rings[r2].damage)
    add_prop(p, 'armor', rings[r2].armor)
  end
  return p
end

function cost(w, a, r1, r2)
  local c = 0
  c = c + weapons[w].cost
  if armor[a] then
    c = c + armor[a].cost
  end
  if rings[r1] then
    c = c + rings[r1].cost
  end
  if rings[r2] then
    c = c + rings[r2].cost
  end
  return c
end

best_cost = math.huge

-- If a, r1, or r2 <= 0, this indicate the absence of that item.

for w = 1, #weapons do
  for a = 0, #armor do
    for r1 = 0, #rings do
      for r2 = -1, r1 - 1 do
        local p = setup_player(w, a, r1, r2)
        local c = cost(w, a, r1, r2)
        if will_player_win2(p) and c < best_cost then
          best_cost = c
        end
      end
    end
  end
end

print(best_cost)
