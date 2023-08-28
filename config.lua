print('^3Steal from cars^7 - Steal from cars Script by Elusive - QBCore Conversion by ^4Nicky of EliteRP^7')
------------------------
--       CONFIG       --
------------------------

Config = {}

Config.Debug = false                    -- Add prints to console

Config.MinCops = 1                      -- Minimum Cops required to search cars

Config.Dispatch = 'cd_dispatch'         -- cd_dispatch, ps-dispatch or none (default QB alert)
Config.DayChance = 60                   -- Chance to alert cops during the day (out of 100)
Config.NightChance = 20                 -- Chance to alert cops during the night (out of 100)
Config.AlertCooldown = 10               -- Time in minutes between alert sends (to prevent too many dispatch alerts)

Config.NearbyPed = true                 -- Require a ped nearby to alert cops? (if true, replaces the Day/Night Chances of alerting)
Config.PedDistance = 30.0               -- Radius to check for nearby ped.

Config.EmptyChance = 20                 -- % Chance that the car is empty when searched

Config.SearchItem = 'rubber_gloves'     -- Item required to search cars (use item while in vehicle to start search)

Config.RewardsLow = {                   -- 60% chance
  --|      Item Name               |  Min Amount  |   Max Amount
  { name = 'water_bottle',            min = 2,        max = 4 },
  { name = 'kurkakola',               min = 1,        max = 2 },
  { name = 'sandwich',                min = 2,        max = 4 },
  { name = 'snikkel_candy',           min = 3,        max = 5 },
}

Config.RewardsMid = {                   -- 30% chance
  --|      Item Name               |  Min Amount  |   Max Amount
  { name = 'joint',                   min = 2,        max = 4 },
  { name = 'stolen_10kgoldchain',     min = 1,        max = 2 },
  { name = 'stolen_goldchain',        min = 1,        max = 3 },
  { name = 'blank_usb',               min = 1,        max = 3 },
}

Config.RewardsHigh = {                  -- 10% Chance
  --|      Item Name               |  Min Amount  |   Max Amount
  { name = 'cryptostick',             min = 1,        max = 3 },
  { name = 'stolen_goldbar',          min = 2,        max = 3 },
  { name = 'weapon_combatpistol',     min = 1,        max = 1 },
}