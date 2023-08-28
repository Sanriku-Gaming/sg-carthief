local QBCore = exports['qb-core']:GetCoreObject()
local secretKey = math.random(1111111111, 9999999999)
if Config.Debug then print("Generated secret key: " .. secretKey) end

QBCore.Functions.CreateUseableItem(Config.SearchItem, function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if Config.Debug then print('Player: ', Player.PlayerData.source, 'Item: ', item.name) end

    if Player.Functions.GetItemByName(item.name) then
      TriggerClientEvent("sg-carthief:client:searchCar", source, secretKey)
    else
      TriggerClientEvent('QBCore:Notify', source, 'You do not have any rubber gloves', 'error', 3000)
    end
end)

QBCore.Functions.CreateCallback('sg-carthief:server:checkPlayerOwned', function(_, cb, plate)
  local playerOwned = false

  local result = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE plate = ?', {plate})
  if Config.Debug then print('Plate: ', plate, 'Result: ', result[1]) end
  if result[1] ~= nil then
      playerOwned = true
  end
  cb(playerOwned)
end)

QBCore.Functions.CreateCallback('sg-carthief:server:getCops', function(source, cb)
	local cops = 0
    for k, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
          cops = cops + 1
        end
    end
    cb(cops)
end)

RegisterNetEvent('sg-carthief:server:searchedCar', function(key)
  local src = source
  local Player = QBCore.Functions.GetPlayer(source)
  local tier = math.random(1, 100)
  local pool = nil

  if not Player then print('^3[WARNING]:^7 Player not found for Source: ^1'..src..'^7') return end
  if key ~= secretKey then
    local external = GetInvokingResource()
    print('^3[WARNING]:^7 Attempted exploit abuse of searchedCar event.\nInvoking Resource: '..external..' - Source: '..src..' - Player: '..Player.PlayerData.charinfo.firstname.. ' '..Player.PlayerData.charinfo.lastname)
    return
  end
  if tier < 10 then
    pool = Config.RewardsHigh
    if Config.Debug then print('High Tier Reward') end
  elseif tier > 10 and tier < 40 then
    pool = Config.RewardsMid
    if Config.Debug then print('Mid Tier Reward') end
  else
    pool = Config.RewardsLow
    if Config.Debug then print('Low Tier Reward') end
  end
  Wait(500)

  -- Generate a random reward and give it to the player
  local rewardIndex = math.random(1, #pool)
  local reward = pool[rewardIndex].name
  local amount = math.random(pool[rewardIndex].min, pool[rewardIndex].max)
  if Config.Debug then print('rewardIndex: '..rewardIndex, 'Reward: '..reward, 'Amount: '..amount) end
  if math.random(100) <= Config.EmptyChance then
    if Config.Debug then print('Empty Search') end
    TriggerClientEvent('QBCore:Notify', src, 'Looks like this car was empty', 'error', 5000)
  else
    if Config.Debug then print('Item Found Search') end
    TriggerClientEvent('QBCore:Notify', src, 'What did we find here?', 'success', 5000)
    Wait(1000)
    if Player.Functions.AddItem(reward, amount) then
      TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[tostring(reward)], 'add', 1)
    end
  end

  -- Chance to remove Config.SearchItem
  if math.random(10) <= 3 then
    if Config.Debug then print('Gloves Broke') end
    TriggerClientEvent('QBCore:Notify', src, 'Your gloves snapped while searching', 'error', 5000)
    Wait(1000)
    Player.Functions.RemoveItem(Config.SearchItem, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.SearchItem], 'remove', 1)
  end
end)
