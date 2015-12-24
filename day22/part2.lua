#!/usr/local/bin/lua

-- day22/part2.lua

-- Parameters.

player_start_hp = 50   -- 50
boss_start_hp   = 55   -- 55
start_mana      = 500  -- 500


-- Set up spells.
spells = {
  {name = 'poison',
   letter = 'P',
   cost = 173,
   effect = {lasts = 6, action = function (p, b, pr, t)
     if t >= 0 then b.hp = b.hp - 3 end
     pr('Poison: boss down to ' .. b.hp .. '; its timer is now at ' .. t)
   end}},
  {name = 'magic missile',
   letter = 'M',
   cost = 53,
   instant = function (p, b, pr)
     b.hp = b.hp - 4
     pr('Magic missile: boss down to ' .. b.hp)
   end},
  {name = 'drain',
   letter = 'D',
   cost = 73,
   instant = function (p, b, pr)
     b.hp = b.hp - 2
     p.hp = p.hp + 2
     pr('Drain: boss down to ' .. b.hp .. ', player up to ' .. p.hp)
   end},
  {name = 'shield',
   letter = 'S',
   cost = 113,
   effect = {lasts = 6, action = function (p, b, pr, t)
     if t > 0 then p.armor = 7 end
     pr('Shield: player armor now ' .. p.armor .. '; its timer is now at ' .. t)
   end}},
  {name = 'recharge',
   letter = 'R',
   cost = 229,
   effect = {lasts = 5, action = function (p, b, pr, t)
     p.mana = p.mana + 101
     pr('Recharge: player mana now ' .. p.mana .. '; its timer is now at ' .. t)
   end}}
}

function remove_val(t, val)
  for k, v in ipairs(t) do
    if v == val then
      table.remove(t, k)
      return
    end
  end
end

function choose_spell(seed, num_spells)
  local spell_i = seed % num_spells + 1
  local seed = math.floor(seed / num_spells)
  return spell_i, seed
end

function dont_print() end

function did_player_win(next_spell, pr)
  local p = {hp = player_start_hp, mana = start_mana, armor = 0}
  local b = {hp = boss_start_hp}
  local effects = {}  -- effect[spell_index] = {left, action}
  local num_effects = 0
  local mana_cost = 0
  local p_moves = ''
  for i = 1, math.huge do

    local whose_turn = 'Player'
    if i % 2 == 0 then whose_turn = 'Boss' end
    if i > 1 then pr('') end
    pr('-- ' .. whose_turn .. ' turn --')
    pr('- Player has ' .. p.hp .. ' hit points, ' .. p.mana .. ' mana')
    pr('- Boss has ' .. b.hp .. ' hit points')

    -- Player loses a point on their turn.
    if whose_turn == 'Player' then
      p.hp = p.hp - 1
      if p.hp <= 0 then
        pr('Player perishes, drowned by the futility that is existence.')
        return false, mana_cost, i
      end
    end

    -- Handle all effects.
    p.armor = 0
    for j, effect in pairs(effects) do
      effect.action(p, b, pr, effect.left - 1)
      effect.left = effect.left - 1
      if effect.left == 0 then
        effects[j] = nil
        num_effects = num_effects - 1
      end
      if b.hp <= 0 then
        pr('Boss dies')
        pr('Player moves: ' .. p_moves)
        return true, mana_cost, i
      end
    end

    -- Handle player/boss action.
    local avail_spells = {}
    for j = 1, #spells do avail_spells[j] = j end
    for j in pairs(effects) do remove_val(avail_spells, j) end
    for j, s in pairs(spells) do
      if s.cost > p.mana then
        remove_val(avail_spells, j)
      end
    end
    if #avail_spells == 0 then
      pr('Player has no spells left!')
      return false, mana_cost, i -- Player loses.
    end
    if whose_turn == 'Player' then
      local spell_i = next_spell(avail_spells)
      local spell = spells[spell_i]

      -- Check legality.
      if effects[spell_i] or spell.cost > p.mana then
        pr('Player tried to enact an illegal spell: ' .. spell.name)
        return false, mana_cost, i
      end

      pr('Player casts ' .. spell.name .. ', cost ' .. spell.cost ..
         '; player has ' .. (p.mana - spell.cost) .. ' mana left.')
      mana_cost = mana_cost + spell.cost
      if spell.instant then
        spell.instant(p, b, pr)
        if b.hp <= 0 then
          pr('Boss dies')
          pr('Player moves: ' .. p_moves)
          return true, mana_cost, i
        end
      else
        effects[spell_i] = {left   = spell.effect.lasts,
                            action = spell.effect.action}
      end
      p_moves = p_moves .. spell.letter
      p.mana = p.mana - spell.cost
    else
      -- Boss's turn.
      local damage = 8 - p.armor
      p.hp = p.hp - damage
      pr('Boss attacks for ' .. damage .. ' damage, player has ' .. p.hp)
      if p.hp <= 0 then
        pr('Player dies')
        return false, mana_cost, i
      end
    end
  end
end

function make_seed_iterator(seed)
  return function (avail_spells)
    --print('Starting seed_iterator; seed = ' .. seed)
    local spell_i = seed % (#avail_spells) + 1
    --print('  got spell_i = ' .. spell_i)
    seed = math.floor(seed / #avail_spells)
    --print('  set seed = ' .. seed)
    return avail_spells[spell_i]
  end
end

function make_move_iterator(move_str)
  local i = 1
  local letter_to_spell_index = {}
  for j, spell in pairs(spells) do
    letter_to_spell_index[spell.letter] = j
  end
  return function (avail_spells)
    if i > #move_str then
      return avail_spells[1]
    end
    local spell_i = letter_to_spell_index[move_str:sub(i, i)]
    i = i + 1
    return spell_i
  end
end

moves = ''

function rand_move(avail_spells)
  local spell_i = avail_spells[math.random(1, #avail_spells)]
  moves = moves .. spells[spell_i].letter
  return spell_i
end

--[[
print(did_player_win(make_move_iterator('RPMSPMMMM'), print))
os.exit(0)
--]]

local least_cost = math.huge
for i = 1, math.huge do
  moves = ''
  local did_win, mana_cost = did_player_win(rand_move, dont_print)
  if did_win and mana_cost < least_cost then
    least_cost = mana_cost
    print(string.format('Move str %s wins with cost %d', moves, mana_cost))
  end
end

if false then
  local moves = 'PSRPMMPMMPMMMMM'
  -- local moves = 'MRPSMRPMSPMMP'
  local s_letters = 'PMDSR'
  local least_cost = math.huge
  for i = 1, math.huge do
    local m = moves
    for j = 1, #m do
      if math.random(1, 10) <= 9 then
        local repl = s_letters[math.random(1, #s_letters)]
        local m = m:sub(1, i - 1) .. s_letters:sub(j, j) .. m:sub(i + 1)
      end
    end
    local next_move = make_move_iterator(m)
    local did_win, mana_cost = did_player_win(next_move, dont_print)
    if did_win and mana_cost < least_cost then
      least_cost = mana_cost
      print(string.format('Move str %s wins with cost %d', m, mana_cost))
    end
  end
end

if false then
  ---[[
  --local moves = 'DRPSMPRMPMPPP'
  --local moves = 'DRPSMRPMSPMMP'
  local moves = 'MRPSMRPMSPMMP'
  local s_letters = 'PMDSR'
  local least_cost = math.huge
  for i = 1, #moves do
    for j = 1, #s_letters do
      local m = moves:sub(1, i - 1) .. s_letters:sub(j, j) .. moves:sub(i + 1)
      local next_move = make_move_iterator(m)
      local did_win, mana_cost = did_player_win(next_move, dont_print)
      if did_win and mana_cost < least_cost then
        least_cost = mana_cost
        print(string.format('Move str %s wins with cost %d', m, mana_cost))
      end

    end
  end
  --]]

  -- print(did_player_win(make_move_iterator('DRPSMRPMSPMMP'), print))
end





-- I thought seed 18 would win with mana cost 900.
-- It was reported that this answer is too low.
--
-- I tried changing the length of poison to 5, which resulted in a mana cost of
-- 1249, but that was reported as too high.

--[[
dbg_run = true

if not dbg_run then

  least_cost = math.huge
  for seed = 1, 1000000 do
    local next_move = make_seed_iterator(seed)
    local did_win, mana_cost = did_player_win(next_move, dont_print)
    if did_win and mana_cost < least_cost then
      least_cost = mana_cost
      print(string.format('Seed %6d won with cost %d', seed, mana_cost))
    end
  end

else

  print(did_player_win(make_seed_iterator(415), print))

end
--]]
