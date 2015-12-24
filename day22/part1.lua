#!/usr/local/bin/lua

-- day22/part1.lua

-- Parameters.

player_start_hp = 50   -- 50
boss_start_hp   = 55   -- 55
start_mana      = 500  -- 500


-- Set up spells.
spells = {
  {name = 'poison',
   cost = 173,
   effect = {lasts = 6, action = function (p, b, pr, t)
     if t > 0 then b.hp = b.hp - 3 end
     pr('Poison: boss down to ' .. b.hp .. '; its timer is now at ' .. t)
   end}},
  {name = 'magic missile',
   cost = 53,
   instant = function (p, b, pr)
     b.hp = b.hp - 4
     pr('Magic missile: boss down to ' .. b.hp)
   end},
  {name = 'drain',
   cost = 73,
   instant = function (p, b, pr)
     b.hp = b.hp - 2
     p.hp = p.hp + 2
     pr('Drain: boss down to ' .. b.hp .. ', player up to ' .. p.hp)
   end},
  {name = 'shield',
   cost = 113,
   effect = {lasts = 6, action = function (p, b, pr, t)
     if t > 0 then p.armor = 7 end
     pr('Shield: player armor now ' .. p.armor .. '; its timer is now at ' .. t)
   end}},
  {name = 'recharge',
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
  for i = 1, math.huge do

    local whose_turn = 'Player'
    if i % 2 == 0 then whose_turn = 'Boss' end
    if i > 1 then pr('') end
    pr('-- ' .. whose_turn .. ' turn --')
    pr('- Player has ' .. p.hp .. ' hit points, ' .. p.mana .. ' mana')
    pr('- Boss has ' .. b.hp .. ' hit points')

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
      pr('Player casts ' .. spell.name .. ', cost ' .. spell.cost ..
         '; player has ' .. (p.mana - spell.cost) .. ' mana left.')
      if spell.instant then
        spell.instant(p, b, pr)
        if b.hp <= 0 then
          pr('Boss dies')
          return true, mana_cost, i
        end
      else
        effects[spell_i] = {left   = spell.effect.lasts,
                            action = spell.effect.action}
      end
      p.mana = p.mana - spell.cost
      mana_cost = mana_cost + spell.cost
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

-- I thought seed 18 would win with mana cost 900.
-- It was reported that this answer is too low.
--
-- I tried changing the length of poison to 5, which resulted in a mana cost of
-- 1249, but that was reported as too high.

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
