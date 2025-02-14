--ME
    local c = Config
    local lang = Languages[Config.language]
    local peds = {}

    -- Localization
    local GetGameTimer = GetGameTimer


    local function draw3dText(coords, text)
        local camCoords = GetGameplayCamCoord()
        local dist = #(coords - camCoords)
        
        -- Experimental math to scale the text down
        local scale = 200 / (GetGameplayCamFov() * dist)

        -- Format the text
        SetTextColour(c.color.r, c.color.g, c.color.b, c.color.a)
        SetTextScale(0.0, c.scale * scale)
        SetTextFont(c.font)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextDropShadow()
        SetTextCentre(true)

        -- Diplay the text
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        SetDrawOrigin(coords, 0)
        EndTextCommandDisplayText(0.0, 0.0)
        ClearDrawOrigin()

    end

    local function displayText(ped, text)
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local targetPos = GetEntityCoords(ped)
        local dist = #(playerPos - targetPos)
        local los = HasEntityClearLosToEntity(playerPed, ped, 17)

        if dist <= c.dist and los then
            local exists = peds[ped] ~= nil

            peds[ped] = {
                time = GetGameTimer() + c.time,
                text = text
            }

            if not exists then
                local display = true

                while display do
                    Wait(0)
                    local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 1.0)
                    draw3dText(pos, peds[ped].text)
                    display = GetGameTimer() <= peds[ped].time
                end

                peds[ped] = nil
            end

        end
    end

    local function onShareDisplay(text, target)
        local player = GetPlayerFromServerId(target)
        if player ~= -1 or target == GetPlayerServerId(PlayerId()) then
            local ped = GetPlayerPed(player)
            displayText(ped, text)
        end
    end

    -- Register the event
    RegisterNetEvent('3dme:shareDisplay', onShareDisplay)

    -- Add the chat suggestion
    TriggerEvent('chat:addSuggestion', '/' .. lang.commandName, lang.commandDescription, lang.commandSuggestion)
--ME
--CARRY
    local carryingBackInProgress = false
    local carryAnimNamePlaying = ""
    local carryAnimDictPlaying = ""
    local carryControlFlagPlaying = 0

    RegisterCommand("carry",function(source, args)
        if not carryingBackInProgress then
            local player = PlayerPedId()	
            lib = 'missfinale_c2mcs_1'
            anim1 = 'fin_c2_mcs_1_camman'
            lib2 = 'nm'
            anim2 = 'firemans_carry'
            distans = 0.15
            distans2 = 0.27
            height = 0.63
            spin = 0.0		
            length = 100000
            controlFlagMe = 49
            controlFlagTarget = 33
            animFlagTarget = 1
            local closestPlayer = GetClosestPlayer(3)
            target = GetPlayerServerId(closestPlayer)
            if closestPlayer ~= -1 and closestPlayer ~= nil then
                carryingBackInProgress = true
                TriggerServerEvent('CarryPeople:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
            else
                drawNativeNotification("No one nearby to carry!")
            end
        else
            carryingBackInProgress = false
            ClearPedSecondaryTask(GetPlayerPed(-1))
            DetachEntity(GetPlayerPed(-1), true, false)
            local closestPlayer = GetClosestPlayer(3)
            target = GetPlayerServerId(closestPlayer)
            if target ~= 0 then 
                TriggerServerEvent("CarryPeople:stop",target)
            end
        end
    end,false)

    RegisterNetEvent('CarryPeople:syncTarget')
    AddEventHandler('CarryPeople:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
        local playerPed = GetPlayerPed(-1)
        local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
        carryingBackInProgress = true
        RequestAnimDict(animationLib)

        while not HasAnimDictLoaded(animationLib) do
            Citizen.Wait(10)
        end
        if spin == nil then spin = 180.0 end
        AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
        if controlFlag == nil then controlFlag = 0 end
        TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
        carryAnimNamePlaying = animation2
        carryAnimDictPlaying = animationLib
        carryControlFlagPlaying = controlFlag
    end)

    RegisterNetEvent('CarryPeople:syncMe')
    AddEventHandler('CarryPeople:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
        local playerPed = GetPlayerPed(-1)
        RequestAnimDict(animationLib)

        while not HasAnimDictLoaded(animationLib) do
            Citizen.Wait(10)
        end
        Wait(500)
        if controlFlag == nil then controlFlag = 0 end
        TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
        carryAnimNamePlaying = animation
        carryAnimDictPlaying = animationLib
        carryControlFlagPlaying = controlFlag
    end)

    RegisterNetEvent('CarryPeople:cl_stop')
    AddEventHandler('CarryPeople:cl_stop', function()
        carryingBackInProgress = false
        ClearPedSecondaryTask(GetPlayerPed(-1))
        DetachEntity(GetPlayerPed(-1), true, false)
    end)

    Citizen.CreateThread(function()
        while true do
            if carryingBackInProgress then 
                while not IsEntityPlayingAnim(GetPlayerPed(-1), carryAnimDictPlaying, carryAnimNamePlaying, 3) do
                    TaskPlayAnim(GetPlayerPed(-1), carryAnimDictPlaying, carryAnimNamePlaying, 8.0, -8.0, 100000, carryControlFlagPlaying, 0, false, false, false)
                    Citizen.Wait(0)
                end
            end
            Wait(0)
        end
    end)

    function GetPlayers()
        local players = {}

        for i = 0, 255 do
            if NetworkIsPlayerActive(i) then
                table.insert(players, i)
            end
        end

        return players
    end

    function GetClosestPlayer(radius)
        local players = GetPlayers()
        local closestDistance = -1
        local closestPlayer = -1
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)

        for index,value in ipairs(players) do
            local target = GetPlayerPed(value)
            if(target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
                if(closestDistance == -1 or closestDistance > distance) then
                    closestPlayer = value
                    closestDistance = distance
                end
            end
        end
        --print("closest player is dist: " .. tostring(closestDistance))
        if closestDistance <= radius then
            return closestPlayer
        else
            return nil
        end
    end

    function drawNativeNotification(text)
        SetTextComponentFormat('STRING')
        AddTextComponentString(text)
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end
--CARRY
--DAMAGERAGDOLL

    local BONES = {
        --[[Pelvis]][11816] = true,
        --[[SKEL_L_Thigh]][58271] = true,
        --[[SKEL_L_Calf]][63931] = true,
        --[[SKEL_L_Foot]][14201] = true,
        --[[SKEL_L_Toe0]][2108] = true,
        --[[IK_L_Foot]][65245] = true,
        --[[PH_L_Foot]][57717] = true,
        --[[MH_L_Knee]][46078] = true,
        --[[SKEL_R_Thigh]][51826] = true,
        --[[SKEL_R_Calf]][36864] = true,
        --[[SKEL_R_Clavicle]][10706] = true,
        --[[MH_L_Elbow]][22711] = true,
        --[[SKEL_R_Foot]][52301] = true,
        --[[SKEL_R_Toe0]][20781] = true,
        --[[IK_R_Foot]][35502] = true,
        --[[PH_R_Foot]][24806] = true,
        --[[MH_R_Knee]][16335] = true,
        --[[RB_L_ThighRoll]][23639] = true,
        --[[RB_R_ThighRoll]][6442] = true,
    }

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local ped = GetPlayerPed(-1)
                --if IsShockingEventInSphere(102, 235.497,2894.511,43.339,999999.0) then
                if HasEntityBeenDamagedByAnyPed(ped) then
                --if GetPedLastDamageBone(ped) = 
                        Disarm(ped)
                end
                ClearEntityLastDamageEntity(ped)
        end
    end)



    function Bool (num) return num == 1 or num == true end

    -- WEAPON DROP OFFSETS
    local function GetDisarmOffsetsForPed (ped)
        local v

        if IsPedWalking(ped) then v = { 0.6, 4.7, -0.1 }
        elseif IsPedSprinting(ped) then v = { 0.6, 5.7, -0.1 }
        elseif IsPedRunning(ped) then v = { 0.6, 4.7, -0.1 }
        else v = { 0.4, 4.7, -0.1 } end

        return v
    end

    function Disarm (ped)
        if IsEntityDead(ped) then return false end

        local boneCoords
        local hit, bone = GetPedLastDamageBone(ped)

        hit = Bool(hit)

        if hit then
            if BONES[bone] then
                

                boneCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, bone))
                SetPedToRagdoll(GetPlayerPed(-1), 5000, 5000, 0, 0, 0, 0)
                

                return true
            end
        end

        return false
    end

        
--DAMAGERAGDOLL
--RAGDOLL
    local ragdoll = false
    ESX = nil
    local shownHelp = false

    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if IsControlJustPressed(2, 82) and not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                ragdoll = not ragdoll
                if not ragdoll then
                    shownHelp = false
                end
            end
            if Config.stunShouldRagdoll and IsPedBeingStunned(GetPlayerPed(-1)) then
                ragdoll = true
            end

            -- Don't ragdoll if player is dead
            if IsPlayerDead(PlayerId()) and ragdoll == true then
                ragdoll = false
                shownHelp = false
            end
            if ragdoll == true and not shownHelp then
                ESX.ShowHelpNotification("Press ~INPUT_VEH_PREV_RADIO~ to stand up")
                shownHelp = true
            end
        end
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if ragdoll then
                SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
            end
        end
    end)

    RegisterNetEvent('dh_ragdoll:toggle')
    AddEventHandler('dh_ragdoll:toggle', function()
        ragdoll = not ragdoll
        if not ragdoll then
            shownHelp = false
        end
    end)

    RegisterNetEvent('dh_ragdoll:set')
    AddEventHandler('dh_ragdoll:set', function(value)
        ragdoll = value
        if not ragdoll then
            shownHelp = false
        end
    end)

    RegisterCommand("rag", function (src, args, raw)
        TriggerEvent("dh_ragdoll:toggle")
    end, false)
--RAGDOLL
--DICE
    local isRolling = false
    local resultText = nil
    local resultPed = nil

    local function playDiceAnimation()
        local ped = PlayerPedId()
        RequestAnimDict("anim@mp_player_intcelebrationmale@wank")
        while not HasAnimDictLoaded("anim@mp_player_intcelebrationmale@wank") do
            Wait(0)
        end

        TaskPlayAnim(ped, "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, -8.0, 3000, 49, 0, false, false, false)
        RemoveAnimDict("anim@mp_player_intcelebrationmale@wank")
    end

    local function draw3DText(coords, text)
        local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
        local scale = 0.35

        if onScreen then
            SetTextScale(scale, scale)
            SetTextFont(0)
            SetTextProportional(1)
            SetTextEntry("STRING")
            SetTextCentre(1)
            AddTextComponentString(text)
            DrawText(x, y)

            local factor = string.len(text) / 370
            DrawRect(x, y + 0.015, 0.015 + factor, 0.03, 0, 0, 0, 150)
        end
    end


    Citizen.CreateThread(function()
        while true do
            if isRolling and resultText and resultPed then
                local pedCoords = GetEntityCoords(resultPed)
                draw3DText(pedCoords + vector3(0.0, 0.0, 1.0), resultText)
            end
            Wait(0) 
        end
    end)

    RegisterNetEvent('esx_dice:roll')
    AddEventHandler('esx_dice:roll', function(playerId, result)
        local ped = GetPlayerPed(GetPlayerFromServerId(playerId))

        
        resultText = "🎲 " .. result
        resultPed = ped
        isRolling = true

        
        Citizen.SetTimeout(3000, function()
            isRolling = false
            resultText = nil
            resultPed = nil
        end)
    end)

    RegisterCommand('dice', function()
        playDiceAnimation()
        TriggerServerEvent('esx_dice:rollDice')
    end)
--DICE
