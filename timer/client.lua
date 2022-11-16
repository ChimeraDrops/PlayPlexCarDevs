local timerStaged = false
local timerStarted = false
local timerStartedTimestamp = 0
local speedMaxThreshhold = 60
local speedMaxThreshhold2 = 100
local speedMaxThreshhold3 = 140

RegisterCommand("2", function(source, args, raw)
	if args[1] == nil or type(args[1]) ~= "number" then
		speedMaxThreshhold = 60
	else
		if tonumber(args[1]) >= 10 then
			speedMaxThreshhold = tonumber(args[1])
		else
			speedMaxThreshhold = 60
		end
	end
	if args[2] == nil or type(args[2]) ~= "number" then
		speedMaxThreshold2 = 100
	else
		if tonumber(args[2]) >= 10 then
			speedMaxThreshhold2 = tonumber(args[2])
		else
			speedMaxThreshhold2 = 100
		end
	end
    if args[3] == nil or type(args[3]) ~= "number" then
        speedMaxThreshold3 = 140
    else
		if tonumber(args[3]) >= 10 then
			speedMaxThreshhold3 = tonumber(args[3])
		else
			speedMaxThreshhold3 = 140
		end
	end
	timerStaged = true
end, false)

RegisterCommand("1", function(source, args, raw)
	timerStaged = false
	timerStarted = false
	timerStartedTimestamp = 0
	speedMaxThreshhold = 60
	speedMaxThreshhold2 = 100
    speedMaxThreshhold3 = 140
end, false)

RegisterCommand("3", function(source, args, raw)
    Citizen.CreateThread(function()
        while true do

            if timerStaged then
                if IsControlJustPressed(1, 71) then
                    timerStaged = false
                    timerStarted = true
                    timerStartedTimestamp = GetGameTimer()
                else
                    if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                        timerStaged = false
                        timerStarted = false
                        TriggerEvent("chatMessage", tostring("^1[Acceleration Time]: Canceled Timer Staged"))
                    end
                end
            end

            if timerStarted then
                local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                if speedMaxThreshhold >= 1000 and speedMaxThreshhold2 >= 1000 and speedMaxThreshhold3 >= 1000 then
                    timerStarted = false
                end
                if math.floor(GetEntitySpeed(vehicle) * 2.23694) >= speedMaxThreshhold then				
                    TriggerEvent("chatMessage", tostring("^1[Acceleration Time]: ^30 - " .. speedMaxThreshhold .. " MPH ^0| " .. (GetGameTimer() - timerStartedTimestamp) / 1000 .. " seconds."))
                    speedMaxThreshhold = 1000
                end
                if math.floor(GetEntitySpeed(vehicle) * 2.23694) >= speedMaxThreshhold2 then				
                    TriggerEvent("chatMessage", tostring("^1[Acceleration Time]: ^30 - " .. speedMaxThreshhold2 .. " MPH ^0| " .. (GetGameTimer() - timerStartedTimestamp) / 1000 .. " seconds."))
                    speedMaxThreshhold2 = 1000
                end
                if math.floor(GetEntitySpeed(vehicle) * 2.23694) >= speedMaxThreshhold3 then				
                    TriggerEvent("chatMessage", tostring("^1[Acceleration Time]: ^30 - " .. speedMaxThreshhold3 .. " MPH ^0| " .. (GetGameTimer() - timerStartedTimestamp) / 1000 .. " seconds."))
                    speedMaxThreshhold3 = 1000
                end

                if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                    TriggerEvent("chatMessage", tostring("^1[Acceleration Time]: Canceled Timer"))
                end
            end

            Citizen.Wait(0)
        end
    end)
end)