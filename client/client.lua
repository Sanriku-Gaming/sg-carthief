local QBCore = exports['qb-core']:GetCoreObject()

local searched_vehicles = {}
local AlertSend = false

-- Cop Notification
local function CallCops(plate, nearby)
	local chance = nil
	local day = false
	local hours = GetClockHours()
	local partial = partialPlate(plate)
	local coords = GetEntityCoords(PlayerPedId())

	-- Alert Chance
	if Config.NearbyPed and nearby then
		chance = 100
	elseif Config.NearbyPed and not nearby then
		chance = 0
	else
		if hours > 6 and hours < 23 then day = true end -- Between 6 and 23
		if day then chance = Config.DayChance else chance = Day.NightChance end
	end

	if Config.Debug then print('Plate: '..plate, 'Partial: '..partial, 'Chance: '..chance, 'Alert Sent?', not AlertSend) end
  if not AlertSend then
    if math.random(1, 100) <= chance then
			if Config.Dispatch == 'cd_dispatch' then
				local data = exports['cd_dispatch']:GetPlayerInfo()
				TriggerServerEvent('cd_dispatch:AddNotification', {
					job_table = {'police'},
					coords = data.coords,
					title = 'Vehicle Break In',
					message = 'A '..data.sex..' was reportedly breaking into a vehicle near '..data.street_1..', with partial plate '..partial..' reported.',
					flash = 0,
					unique_id = tostring(math.random(0000000,9999999)),
					blip = {
						sprite = 225,
						scale = 1.1,
						colour = 3,
						flashes = false,
						text = '911 - Dispatch',
						time = (5*60*1000),
						sound = 1,
						}
					}
				)
			elseif Config.Dispatch == 'ps-dispatch' then
				exports["ps-dispatch"]:CustomAlert({
					coords = coords,
					message = "Vehicle Break In",
					dispatchCode = "10-19 Vehicle Break In",
					description = 'An individual was reportedly breaking into a vehicle with partial plate '..partial..'.',
					radius = 0,
					sprite = 225,
					color = 3,
					scale = 1.1,
					length = 3,
				})
			else
				TriggerServerEvent('police:server:policeAlert', 'An individual was reportedly breaking into a vehicle with partial plate '..partial..'.')
			end
			QBCore.Functions.Notify('Looks like a local saw you stealing and called the cops!', 'primary', 5000)
    end

    AlertSend = true
    SetTimeout(Config.AlertCooldown * 1000 * 60, function()
			AlertSend = false
		end)
	end
end

function partialPlate(plate)
	local startIndex = math.random(1, 6) -- choose a random starting index between 1 and 6
	local partial = ""
	for i = 1, 8 do
		if i >= startIndex and i <= startIndex+2 then
			partial = partial .. string.sub(plate, i, i) -- keep the chosen characters as is
		else
			partial = partial .. "*" -- replace the non-chosen characters with asterisks
		end
	end
	return partial
end

local function playAnim(animDict, animName, duration, flag, lock)
  RequestAnimDict(animDict)
  while not HasAnimDictLoaded(animDict) do Wait(0) end
  TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, flag, 1, lock, lock, lock)
  RemoveAnimDict(animDict)
end

RegisterNetEvent('sg-carthief:client:searchCar', function(key)
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		QBCore.Functions.TriggerCallback('sg-carthief:server:getCops', function(cops)
			Wait(1000)
			if cops >= Config.MinCops then
				local playerPed = PlayerPedId()
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				local vehicleClass = GetVehicleClass(vehicle)
				local plate = GetVehicleNumberPlateText(vehicle)

				local hasSearched = false
				for i, searchedPlate in pairs(searched_vehicles) do
					if searchedPlate == plate then
						hasSearched = true
						break
					end
				end

				if not hasSearched then
					if vehicleClass >= 0 and vehicleClass <= 12 then
						QBCore.Functions.TriggerCallback('sg-carthief:server:checkPlayerOwned', function(playerOwned)
							Wait(1000)
							if not playerOwned then
								searched_vehicles[#searched_vehicles+1] = plate

								playAnim('veh@handler@base', 'hotwire', -1, 0, false)


								-- Set off the car alarm
								SetVehicleAlarm(vehicle, true)
								SetVehicleAlarmTimeLeft(vehicle, 40000)

								-- Start the minigame
								exports['ps-ui']:Circle(function(success)
									local source = GetPlayerServerId(PlayerId())
									playAnim('veh@handler@base', 'hotwire', -1, 0, false)
									if success then
										TriggerServerEvent('sg-carthief:server:searchedCar', source, key)
									else
										QBCore.Functions.Notify('You failed to search the vehicle.', 'error', 5000)
									end
									ClearPedTasks(playerPed)
								end, 3, 15) -- NumberOfCircles, MS
								if Config.NearbyPed then
									local PlayerPeds = {}
									if next(PlayerPeds) == nil then
										for _, activePlayer in ipairs(GetActivePlayers()) do
											local ped = GetPlayerPed(activePlayer)
											PlayerPeds[#PlayerPeds + 1] = ped
										end
									end
									local coords = GetEntityCoords(PlayerPedId())
									local closestPed, distance = QBCore.Functions.GetClosestPed(coords, PlayerPeds)
									if Config.Debug then print(closestPed, distance) end
									if closestPed ~= nil and distance <= Config.PedDistance then
										CallCops(plate, true)
									else
										CallCops(plate, false)
									end
								else
									CallCops(plate, false)
								end
							else
								QBCore.Functions.Notify('You cannot search this vehicle.', 'error', 5000)
							end
						end, plate)
					else
						QBCore.Functions.Notify('You cannot search this type of vehicle', 'error', 5000)
					end
				else
					QBCore.Functions.Notify('You have already searched this vehicle.', 'error', 5000)
				end
			else
				QBCore.Functions.Notify('Not enough Cops around.', 'error', 5000)
			end
		end)
	else
		QBCore.Functions.Notify('You are not in a vehicle.', 'error', 5000)
	end
end)