QBCore = exports['qb-core']:GetCoreObject()

local zombies = {}
local zombieHealth = {}
local zombieData = {}
local currentZombieCount = 0
local zombieBlips = {}
local ZombieCorpses = {}
local lastNoisePos = nil
local lastNoiseTime = 0
local lastNoiseRadius = Config.HearingRadius
local playerInfected = false
local infectionEndTime = 0
local allyConfig = Config.Allies
local activeAllies = {}
local lastSupportCall = 0
local zombieGroup = Config.ZombieRelationshipGroup
local CurrentReviver = nil
local lastPropLoot = {}

local soundManager = exports['xsound']

local attackAnimations = {
    {dict = "anim@ingame@melee@unarmed@streamed_core_zombie", anim = "short_90_punch"},
    {dict = "anim@ingame@melee@unarmed@streamed_variations_zombie", anim = "heavy_punch_b_var_2"}
}

local VehicleAttackDistance = Config.VehicleAttackDistance
local VehicleEnterDistance = Config.VehiclePullOutDistance
local PushForce = Config.PushForce
local DistanceTarget = Config.DistanceTarget

Citizen.CreateThread(function()
    for _, zone in ipairs(Config.RedZones) do
        if zone.type == "poly" then
            zone.polyzone = PolyZone:Create(zone.points, {
                name   = zone.id,
                minZ   = zone.minZ,
                maxZ   = zone.maxZ,
                useZ = true,
                debugPoly = zone.debug or false
            })
        end
    end
  
    for _, zone in ipairs(Config.SafeZones) do
        if zone.type == "poly" then
            zone.polyzone = PolyZone:Create(zone.points, {
                name   = zone.id,
                minZ   = zone.minZ,
                maxZ   = zone.maxZ,
                useZ = true,
                debugPoly = zone.debug or false
            })
        end
    end
end)

Citizen.CreateThread(function()
    local allyHash = GetHashKey(allyConfig.relationshipGroup)
    local zombieHash = GetHashKey(zombieGroup)

    -- Crea los grupos de relación si no existen
    if not DoesRelationshipGroupExist(allyHash) then
        AddRelationshipGroup(allyConfig.relationshipGroup)
    end

    if not DoesRelationshipGroupExist(zombieHash) then
        AddRelationshipGroup(zombieGroup)
    end

    -- Odio mutuo (5)
    SetRelationshipBetweenGroups(5, allyHash, zombieHash)
    SetRelationshipBetweenGroups(5, zombieHash, allyHash)

    -- Aliados y jugadores = neutral (0)
    SetRelationshipBetweenGroups(0, allyHash, GetHashKey("PLAYER"))
    SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), allyHash)
    Wait(500)
end)

function spawnAlliesInVehicle(numAllies)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    -- Spawn coords aleatorios
    local spawnX = playerCoords.x + math.random(-allyConfig.spawnRadius, allyConfig.spawnRadius)
    local spawnY = playerCoords.y + math.random(-allyConfig.spawnRadius, allyConfig.spawnRadius)
    local spawnZ = playerCoords.z

    -- Crear el vehículo (opcional)
    local vehicleHash = GetHashKey(allyConfig.vehicleModel)
    RequestModel(vehicleHash)
    while not HasModelLoaded(vehicleHash) do
        Citizen.Wait(0)
    end

    local allyVehicle = CreateVehicle(vehicleHash, spawnX, spawnY, spawnZ, 0.0, true, true)
    SetVehicleOnGroundProperly(allyVehicle)
    SetEntityAsMissionEntity(allyVehicle, true, false)
    SetVehicleDoorsLocked(allyVehicle, 2)

    for seat = -1, math.min(numAllies - 1, allyConfig.maxAlliesInVehicle - 1) do
        -- 1) Elegimos modelo aleatorio:
        local randomModelName = allyConfig.pedModels[math.random(#allyConfig.pedModels)]
        local pedHash = GetHashKey(randomModelName)

        RequestModel(pedHash)
        while not HasModelLoaded(pedHash) do
            Citizen.Wait(0)
        end

        -- 2) Creamos el ally con ese modelo
        local allyPed = CreatePedInsideVehicle(allyVehicle, 4, pedHash, seat, true, true)
        local playerGroup = GetPlayerGroup(PlayerId())
        SetPedAsGroupMember(allyPed, playerGroup)
        SetPedNeverLeavesGroup(allyPed, true)

        table.insert(activeAllies, allyPed)

        -- 3) Ajustes de combate (igual que antes)
        SetPedCombatAttributes(allyPed, 46, true)
        SetPedCombatAbility(allyPed, 2)
        SetPedCombatMovement(allyPed, 2)
        SetPedCombatRange(allyPed, 2)
        SetPedCanSwitchWeapon(allyPed, true)
        SetPedAccuracy(allyPed, 75)
        local randomWeaponName = allyConfig.weapons[math.random(#allyConfig.weapons)]
        local weaponHash = GetHashKey(randomWeaponName)   
        GiveWeaponToPed(allyPed, weaponHash, 9999, false, true)
        SetCurrentPedWeapon(allyPed, weaponHash, true)
        SetPedRelationshipGroupHash(allyPed, GetHashKey(allyConfig.relationshipGroup))
        SetCanAttackFriendly(allyPed, false, false)

        local blip = AddBlipForEntity(allyPed)
        SetBlipSprite(blip, 487)
        SetBlipColour(blip, 3)
        SetBlipScale(blip, 0.9)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("MERC")
        EndTextCommandSetBlipName(blip)

        -- Marca al ally como "Misión"
        SetEntityAsMissionEntity(allyPed, true, false)

        -- Salir del vehículo y comportamiento
        Citizen.CreateThread(function()
            Citizen.Wait(1000)
            TaskLeaveVehicle(allyPed, allyVehicle, 0)
            while IsPedInAnyVehicle(allyPed, false) do
                Citizen.Wait(500)
            end

            -- IA: seguir al jugador y atacar zombis
            while DoesEntityExist(allyPed) do
                Citizen.Wait(1500)
                if IsPedDeadOrDying(allyPed, true) then break end

                local playerPed = PlayerPedId()
                local pCoords = GetEntityCoords(PlayerPedId())
                local allyCoords = GetEntityCoords(allyPed)
                local distPlayer = #(pCoords - allyCoords)
                local followDist = allyConfig.followDistance

                -- Detectamos “muerte real” del jugador
                local playerDead = IsEntityDead(playerPed)

                if playerDead then
                    -- Si permitimos reanimar y nadie está haciéndolo, iniciamos CPR
                    if allyConfig.AllowAlliesRevive and CurrentReviver == nil then
                        CurrentReviver = allyPed
                        ClearPedTasks(allyPed)
                        SetBlockingOfNonTemporaryEvents(allyPed, true)
                        Citizen.CreateThread(function()
                            -- 1) Moverse al jugador
                            TaskGoToEntity(allyPed, playerPed, 60000, 2.0, 2.0, 1073741824, 0)
                            while #(GetEntityCoords(allyPed) - GetEntityCoords(playerPed)) > 2.0 do
                                Citizen.Wait(200)
                                if not DoesEntityExist(allyPed) or IsEntityDead(allyPed) then
                                    CurrentReviver = nil
                                    return
                                end
                            end
                            -- 2) Animación de CPR
                            local dict, anim = "mini@cpr@char_a@cpr_str", "cpr_pumpchest"
                            RequestAnimDict(dict); while not HasAnimDictLoaded(dict) do Citizen.Wait(0) end
                            TaskPlayAnim(allyPed, dict, anim, 8.0, -8.0, 12000, 1, 0, false, false, false)
                            Citizen.Wait(12000)
                            -- 3) Revive completo con ESX AmbulanceJob
                            TriggerServerEvent('zombies:allyRevivePlayer', GetPlayerServerId(PlayerId()))

                            -- Limpiar tareas y desbloquear
                            ClearPedTasksImmediately(allyPed)
                            SetBlockingOfNonTemporaryEvents(allyPed, false)
                            exports.qbx_core:Notify("You've been healed")--QBCore.Functions.Notify("You been healed")
                            CurrentReviver = nil
                        end)
                    else
                        -- Si no reaniman, al menos acércate al cuerpo
                        local dist = #(GetEntityCoords(allyPed) - GetEntityCoords(playerPed))
                        if dist > 2.0 then
                            TaskGoToEntity(allyPed, playerPed, -1, 2.0, 2.0, 1073741824, 0)
                        else
                            TaskStandStill(allyPed, 1500)
                        end
                    end

                else
                    -- IA normal: buscar y atacar zombies o seguir al jugador
                    local foundZombie = findNearestZombie(allyPed, allyConfig.attackRange)
                    if foundZombie then
                        TaskCombatPed(allyPed, foundZombie, 0, 16)
                    else
                        local distPlayer = #(GetEntityCoords(playerPed) - GetEntityCoords(allyPed))
                        if distPlayer > allyConfig.followDistance then
                            TaskGoToEntity(allyPed, playerPed, -1, 2.0, 2.0, 1073741824, 0)
                        else
                            TaskStandStill(allyPed, 1500)
                        end
                    end
                end

            end

            if DoesBlipExist(blip) then
                RemoveBlip(blip)
            end
        end)
    end
end

function findNearestZombie(allyPed, range)
    local allyCoords = GetEntityCoords(allyPed)
    local nearest = nil
    local nearestDist = range or 50.0

    for _, zombie in ipairs(zombies) do
        if DoesEntityExist(zombie) and not IsPedDeadOrDying(zombie, true) then
            local zCoords = GetEntityCoords(zombie)
            local dist = #(allyCoords - zCoords)
            if dist < nearestDist then
                nearestDist = dist
                nearest = zombie
            end
        end
    end

    return nearest
end

RegisterCommand("zup", function(source, args, raw)
    local currentTime = GetGameTimer() -- Devuelve el tiempo en ms desde que empezó la sesión
    -- Comprobar si ha pasado el cooldown
    if currentTime - lastSupportCall < allyConfig.SupportCooldown then
        local remaining = (allyConfig.SupportCooldown - (currentTime - lastSupportCall)) / 1000
        export.qbx_core:Notify(("Need to wait %d seconds before call for support"):format(math.ceil(remaining)))
        return
    end

    -- Si pasó el cooldown, actualizamos el lastSupportCall y ejecutamos la función
    lastSupportCall = currentTime

    local num = tonumber(args[1]) or 2
    spawnAlliesInVehicle(num)
    exports.qbx_core:Notify("Allies are here to help you")
end, false)

function playZombieAttack(zombie)
    local attack = attackAnimations[math.random(#attackAnimations)]
    RequestAnimDict(attack.dict)
    while not HasAnimDictLoaded(attack.dict) do
        Wait(0)
    end
    TaskPlayAnim(zombie, attack.dict, attack.anim, 8.0, -8.0, -1, 1, 0, false, false, false)
end

function IsNight()
    local hour = GetClockHours()
    return (hour >= 20 or hour < 6)
end

function GetVisionDistance()
    if IsNight() then
        return Config.NightVisionDistance
    else
        return Config.DayVisionDistance
    end
end

function makeNoise(coords, radius)
    lastNoisePos = coords
    lastNoiseTime = GetGameTimer()
    lastNoiseRadius = radius
end

function GetNoisePositionIfRecent()
    if lastNoisePos and (GetGameTimer() - lastNoiseTime) < Config.NoiseMemoryTime then
        return lastNoisePos, lastNoiseRadius
    end
    return nil, 0
end

function canZombieSeePlayer(zombie, playerPed, distance)
    if distance > GetVisionDistance() then
        return false
    end
    return HasEntityClearLosToEntity(zombie, playerPed, 17)
end

function damageVehicle(vehicle)
    local currentEngineHealth = GetVehicleEngineHealth(vehicle)
    local newHealth = currentEngineHealth - Config.VehicleDamageOnAttack
    if newHealth < 0 then newHealth = 0 end
    SetVehicleEngineHealth(vehicle, newHealth)

    ApplyForceToEntity(vehicle, 1, 0.0, -PushForce, 0.2, 0.0, 0.0, 0.0, false, true, true, false, true, true)

    local xOffset = (math.random() - 0.5) * 0.5
    local yOffset = (math.random() - 0.5) * 0.5
    local zOffset = 0.0
    SetVehicleDamage(vehicle, xOffset, yOffset, zOffset, 50.0, 0.1, true)
end

function pullPlayerOutOfVehicle(zombie, playerPed, vehicle, zombieType)
    -- Reproducir una animación de "tirón" en el zombie para simular que está sacando al jugador
    local pullAnim = { dict = "anim@heists@prison_heistig1_p1_guard_checks_bus", anim = "loop", flag = 49 }
    RequestAnimDict(pullAnim.dict)
    while not HasAnimDictLoaded(pullAnim.dict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(zombie, pullAnim.dict, pullAnim.anim, 8.0, -8.0, 2000, pullAnim.flag, 0, false, false, false)
    
    -- Espera breve para dar tiempo a que se vea el efecto del zombie tirando al jugador
    Citizen.Wait(500)
    
    -- Forzar la salida del vehículo del jugador
    if vehicle and vehicle ~= 0 then
        SetEntityAsMissionEntity(vehicle, true, true)
        TaskLeaveVehicle(playerPed, vehicle, 4160)
    end
    
    Citizen.Wait(100)
    
    -- Activar el ragdoll en el jugador durante 1000ms para simular su caída natural
    SetPedToRagdoll(playerPed, 1000, 1000, 0, true, true, false)
    
    -- Opcional: reproducir la animación de ataque del zombie y aplicar daño al jugador
    playZombieAttack(zombie)
    local health = GetEntityHealth(playerPed)
    SetEntityHealth(playerPed, health - zombieType.damage)
end

function searchArea(zombie, coords, duration)
    TaskGoToCoordAnyMeans(zombie, coords.x, coords.y, coords.z, 1.0, 0, 0, 786603, 0)
    local endTime = GetGameTimer() + duration
    while GetGameTimer() < endTime and DoesEntityExist(zombie) and not IsPedDeadOrDying(zombie, true) do
        Wait(500)
    end

    if DoesEntityExist(zombie) and not IsPedDeadOrDying(zombie, true) then
        local animDict = "anim@ingame@move_m@zombie@strafe"
        local animName = "idle"

        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end
        TaskPlayAnim(zombie, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)

        Wait(5000)
        ClearPedTasks(zombie)
        TaskWanderStandard(zombie, 10.0, 10)
    end
end

function isInZone(coords, zoneCoords, radius)
    return #(coords - zoneCoords) <= radius
end

function playerInRedZone()
    local coords = GetEntityCoords(PlayerPedId())
    for _, zone in ipairs(Config.RedZones) do
        if zone.type == "circle" and #(coords - zone.coords) <= zone.radius then
            return true
        elseif zone.type == "poly" and zone.polyzone and zone.polyzone:isPointInside(coords) then
            return true
        end
    end

    return false
end


function getCurrentRedZone()
    local coords = GetEntityCoords(PlayerPedId())
    for _, zone in ipairs(Config.RedZones) do
        if zone.type == "circle" then
            if #(coords - zone.coords) <= zone.radius then
                return zone
            end
        elseif zone.type == "poly" and zone.polyzone then
            if zone.polyzone:isPointInside(coords) then
                return zone
            end
        end
    end

    return nil
end

function zombieInSafeZone(zombieCoords)
    for _, zone in ipairs(Config.SafeZones) do
        if zone.type == "circle" then
            if #(zombieCoords - zone.coords) <= zone.radius then
                return true
            end
        elseif zone.type == "poly" and zone.polyzone then
            if zone.polyzone:isPointInside(zombieCoords) then
                return true
            end
        end
    end

    return false
end

local zombieStates = {}

function updateZombieMovementStyle(zombie, zombieType, playerPed, distanceToPlayer)
    local playerSpeed = GetEntitySpeed(playerPed)
    local isPlayerSprinting = playerSpeed > 2.0 -- umbral para "sprint"

    if not zombieStates[zombie] then
        -- Guardar estado inicial
        zombieStates[zombie] = {isRunning = false, originalClipset = nil}
    end

    if zombieStates[zombie].originalClipset == nil then
        -- Guardar un clipset original (el que ya tiene puesto)
        zombieStates[zombie].originalClipset = zombieType.clipsets[1] 
    end

    if isPlayerSprinting and distanceToPlayer > 2.0 then
        -- Quitar clipset y correr
        if not zombieStates[zombie].isRunning then
            -- Cambiar a modo correr
            ResetPedMovementClipset(zombie, 1.0)
            Wait(500)
            -- Asignar tarea con TaskGoToEntity con mayor velocidad
            TaskGoToEntity(zombie, playerPed, -1, 0.0, zombieType.speed, 1073741824, 0)
            zombieStates[zombie].isRunning = true
        else
            -- Ya está corriendo, asegurarse de que sigue persiguiendo
            TaskGoToEntity(zombie, playerPed, -1, 0.0, zombieType.speed, 1073741824, 0)
        end
    else
        -- Volver a clipset normal
        if zombieStates[zombie].isRunning then
            local clipset = zombieStates[zombie].originalClipset
            RequestAnimSet(clipset)
            while not HasAnimSetLoaded(clipset) do
                Wait(0)
            end
            SetPedMovementClipset(zombie, clipset, 1.0)
            Wait(500)
            TaskGoToEntity(zombie, playerPed, -1, 0.0, 1.0, 1073741824, 0)
            zombieStates[zombie].isRunning = false
        else
            -- Ya está en modo normal, asegurar que persigue con velocidad normal
            TaskGoToEntity(zombie, playerPed, -1, 0.0, 1.0, 1073741824, 0)
        end
    end
end

function GetNearbyVehicles(coords, radius)
    local vehicles = {}
    local handle, veh = FindFirstVehicle()
    local success

    if veh and veh ~= 0 then
        repeat
            local vehCoords = GetEntityCoords(veh)
            local dist = #(vehCoords - coords)
            if dist <= radius then
                table.insert(vehicles, veh)
            end
            success, veh = FindNextVehicle(handle)
        until not success
        EndFindVehicle(handle)
    end

    return vehicles
end

function handleSpecialZombie(zombie, zombieType, playerPed, distance, zombieCoords, playerCoords, data)
    if zombieType.special == "super_jump" then
        if not data.nextJump or GetGameTimer() > data.nextJump then
            TaskJump(zombie, true)
            ApplyForceToEntity(zombie, 1, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
            data.nextJump = GetGameTimer() + (zombieType.jump_interval or 5000)
        end
    elseif zombieType.special == "electric" then
        if not data.nextElectric or GetGameTimer() > data.nextElectric then
            if not HasNamedPtfxAssetLoaded("core") then
                RequestNamedPtfxAsset("core")
                while not HasNamedPtfxAssetLoaded("core") do
                    Citizen.Wait(1)
                end
            end
            local positions = {
                {x = 0.0, y = 0.0, z = 0.0},
                {x = 0.5, y = 0.0, z = 0.5},
                {x = -0.5, y = 0.0, z = 0.5},
                {x = 0.0, y = 0.5, z = 0.5},
                {x = 0.0, y = -0.5, z = 0.5}
            }
            for _, pos in ipairs(positions) do
                UseParticleFxAssetNextCall("core")
                local particleFx = StartParticleFxLoopedOnEntity("ent_dst_elec_fire_sp", zombie, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 1.0, false, false, false)
                Citizen.SetTimeout(zombieType.electric_duration or 1000, function()
                    StopParticleFxLooped(particleFx, false)
                end)
            end
            data.nextElectric = GetGameTimer() + (zombieType.electric_interval or 5000)
        end
    
        if distance < 2.0 and (not data.nextTaser or GetGameTimer() > data.nextTaser) then
            SetPedToRagdoll(playerPed, 1000, 1000, 0, true, true, false)
            -- Aplicar el daño eléctrico adicional
            local currentHealth = GetEntityHealth(playerPed)
            SetEntityHealth(playerPed, currentHealth - (zombieType.electricDamage or 0))
            data.nextTaser = GetGameTimer() + 5000
        end    
    elseif zombieType.special == "smoke" then
        if not data.nextSmoke or GetGameTimer() > data.nextSmoke then
            if not HasNamedPtfxAssetLoaded("core") then
                RequestNamedPtfxAsset("core")
                while not HasNamedPtfxAssetLoaded("core") do
                    Citizen.Wait(1)
                end
            end
            UseParticleFxAssetNextCall("core")
            local smokeFx = StartParticleFxLoopedOnEntity("exp_grd_grenade_smoke", zombie, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
            Citizen.SetTimeout(zombieType.smoke_duration or 3000, function()
                StopParticleFxLooped(smokeFx, false)
            end)
            data.nextSmoke = GetGameTimer() + (zombieType.smoke_interval or 5000)
        end
    elseif zombieType.special == "explosive" then
        if distance < (zombieType.explosion_radius or 3.0) then
            AddExplosion(zombieCoords.x, zombieCoords.y, zombieCoords.z, 5, zombieType.explodeDamage or 2.0, true, false, 1.0)
            SetEntityHealth(zombie, 0)
        end
    elseif zombieType.special == "psycho" then
        if not data.nextTeleport or GetGameTimer() > data.nextTeleport then
            local offsetX = math.random(-10, 10)
            local offsetY = math.random(-10, 10)
            local targetCoords = vector3(playerCoords.x + offsetX, playerCoords.y + offsetY, playerCoords.z)
            SetEntityCoords(zombie, targetCoords.x, targetCoords.y, targetCoords.z)
            data.nextTeleport = GetGameTimer() + (zombieType.teleport_interval or 5000)
        end

        if not data.nextPush or GetGameTimer() > data.nextPush then
            SetPedToRagdoll(playerPed, 2000, 2000, 0, true, true, false)
            ApplyForceToEntity(playerPed, 1, 20.0, 0, 10.0, 0, 0, 0, 0, true, true, true, true, true)
            
            local vehicles = GetNearbyVehicles(zombieCoords, 10.0) -- Asegúrate de tener o definir esta función
            for _, veh in ipairs(vehicles) do
                if DoesEntityExist(veh) and not IsPedAPlayer(veh) then
                    ApplyForceToEntity(veh, 1, 40.0, 0, 20.0, 0, 0, 0, 0, true, true, true, true, true)
                end
            end
            data.nextPush = GetGameTimer() + (zombieType.force_application_interval or 5000)
        end
    end
end

RegisterCommand("cure", function(source, args, rawCommand)
    if not playerInfected then
        exports.qbx_core:Notify("Not infected")
        return
    end

    local playerPed = PlayerPedId()
    local cureItem = Config.Infection.cureItem
    exports.qbx_core:TriggerCallback('zombies:hasCureItem', function(hasItem)
        if hasItem then
            local dict = 'mp_suicide'
            local clip = 'pill'
            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(0)
            end

            local propModel = GetHashKey("xm3_prop_xm3_pill_01a")
            RequestModel(propModel)
            while not HasModelLoaded(propModel) do
                Citizen.Wait(0)
            end
            local prop = CreateObject(propModel, 0.0, 0.0, 0.0, true, true, false)
            local boneIndex = GetPedBoneIndex(playerPed, 57005)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.05, -0.02, -0.03, 150.0, 340.0, 170.0, true, true, false, true, 1, true)
            
            TaskPlayAnim(playerPed, dict, clip, 8.0, -8.0, 2500, 49, 0, false, false, false)
            --print(">> Iniciando animación de cura...")
            Citizen.Wait(2500)
            
            ClearPedTasks(playerPed)
            DeleteObject(prop)
            
            -- Enviar el evento al servidor para que remueva el ítem y cure la infección
            TriggerServerEvent("zombies:cureInfection")
            --print(">> Cureitem consumido, se ha enviado el evento para curar la infección.")
        else
            exports.qbx_core:Notify("Need the cure item")
        end
    end, cureItem)
end, false)

RegisterNetEvent("zombies:playerInfected")
AddEventHandler("zombies:playerInfected", function()
    --print(">> Evento zombies:playerInfected recibido - playerInfected:", playerInfected)
    if not playerInfected then
        playerInfected = true
        --print(">> Player infectado, iniciando efecto y animación de tos. (Ahora playerInfected:", playerInfected, ")")
        infectionEndTime = GetGameTimer() + Config.Infection.duration

        -- Aplicar efecto visual con transición
        Citizen.CreateThread(function()
            SetTimecycleModifier(Config.Infection.visualEffect)
            local strength = 0.0
            while strength < 1.0 do
                strength = strength + Config.Infection.visualTransitionStep
                SetTimecycleModifierStrength(strength)
                Citizen.Wait(Config.Infection.visualTransitionDelay)
            end
        end)

        -- Iniciar animación de tos periódica mientras esté infectado
        Citizen.CreateThread(function()
            while playerInfected do
                local playerPed = PlayerPedId()
                RequestAnimDict(Config.Infection.coughAnimation.dict)
                while not HasAnimDictLoaded(Config.Infection.coughAnimation.dict) do
                    Citizen.Wait(0)
                end
                TaskPlayAnim(playerPed, Config.Infection.coughAnimation.dict, Config.Infection.coughAnimation.anim, 8.0, -8.0, Config.Infection.coughAnimation.duration, Config.Infection.coughAnimation.flag, 0, false, false, false)
                Citizen.Wait(Config.Infection.coughAnimation.interval)
                if GetGameTimer() > infectionEndTime then
                    playerInfected = false
                end
            end

            -- Remover efecto visual con transición al curarse
            Citizen.CreateThread(function()
                --print(">> Finalizando efecto visual de infección")
                local strength = 1.0
                while strength > 0.0 do
                    strength = strength - Config.Infection.visualTransitionStep
                    SetTimecycleModifierStrength(strength)
                    Citizen.Wait(Config.Infection.visualTransitionDelay)
                end
                ClearTimecycleModifier()
                --print(">> Efecto visual removido")
            end)
        end)

        -- (Nueva parte) Hilo para ejecutar ragdoll periódicamente
        Citizen.CreateThread(function()
            while playerInfected do
                local playerPed = PlayerPedId()
                -- Asegurarse de que el jugador no esté en vehículo u otra situación que impida el ragdoll
                if not IsPedInAnyVehicle(playerPed, false) then
                    SetPedToRagdoll(playerPed, 1000, 1000, 0, true, true, false)
                end
                -- Esperar el intervalo deseado (por ejemplo, 15 segundos)
                Citizen.Wait(15000)
            end
        end)

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local targetClipset = "move_m@injured"  -- Clipset que simula un andar herido
            RequestAnimSet(targetClipset)
            while not HasAnimSetLoaded(targetClipset) do
                Citizen.Wait(0)
            end
            -- El tercer parámetro es la velocidad de mezcla; un valor menor hace que la transición sea más lenta
            local blendSpeed = 0.5  -- Ajusta este valor según la rapidez que desees en la transición
            SetPedMovementClipset(playerPed, targetClipset, blendSpeed)
        end)
        
        Citizen.CreateThread(function()
            while playerInfected do
                -- Deshabilitar controles de disparo y apuntado
                DisableControlAction(0, 24, true) -- Deshabilita disparar (generalmente el botón izquierdo del mouse)
                DisableControlAction(0, 25, true) -- Deshabilita apuntar (generalmente botón derecho del mouse)
                -- Si deseas deshabilitar otras acciones, puedes agregarlas aquí
                Citizen.Wait(1000)  -- Se ejecuta cada frame
            end
        end)

        Citizen.CreateThread(function()
            while playerInfected do
                local playerPed = PlayerPedId()
                local currentHealth = GetEntityHealth(playerPed)
                local newHealth = currentHealth - Config.Infection.DamagePerInterval
                -- Evita que la salud baje de 0
                if newHealth < 0 then newHealth = 0 end
                SetEntityHealth(playerPed, newHealth)
                -- Espera el intervalo definido en la configuración
                Citizen.Wait(Config.Infection.DamageInterval)
            end
        end)
    end
end)

RegisterNetEvent("zombies:infectionCured")
AddEventHandler("zombies:infectionCured", function()
    --print(">> Evento zombies:infectionCured recibido en el cliente: se debe detener la infección.")
    if playerInfected then
        playerInfected = false

        -- Remover el efecto visual con transición suave
        Citizen.CreateThread(function()
            local strength = 1.0
            while strength > 0.0 do
                strength = strength - Config.Infection.visualTransitionStep
                SetTimecycleModifierStrength(strength)
                Citizen.Wait(Config.Infection.visualTransitionDelay)
            end
            ClearTimecycleModifier()
            --print(">> Efecto visual removido, la infección se ha curado.")
        end)

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local blendSpeed = 1.0  -- Puedes ajustar el blend para una transición suave de vuelta a la normalidad
            ResetPedMovementClipset(playerPed, blendSpeed)
        end)        
    end
end)

function zombieEatPlayer(zombie)
    local dict = "amb@world_human_gardener_plant@female@idle_a"
    local anim = "idle_c_female"

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

    -- Posición actual del zombie (para re-colocarlo en el suelo si hace falta).
    local coords = GetEntityCoords(zombie)
    local heading = GetEntityHeading(zombie)

    TaskPlayAnimAdvanced(
        zombie,
        dict,
        anim,
        coords.x, coords.y, coords.z,
        0.0, 0.0, heading,  -- Rotación en ejes X,Y + heading para el Z
        8.0, -8.0,
        -1,                 -- Duración (-1 = hasta que la cortes)
        1,                  -- Flag 1 = loop
        0.0,                -- PlaybackRate
        0, 0                -- lockX, lockY (si no quieres que se mueva)
    )
end

function playZombieSpawnAnim(zombie)
    local dict = "anim@scripted@surv@ig2_zombie_spawn@runner@"   -- Diccionario de animaciones de ejemplo
    local anim = "action_02"

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end

    -- Reproducimos la animación durante 3 segundos.
    TaskPlayAnim(zombie, dict, anim, 8.0, -8.0, 3000, 1, 0, false, false, false)
    Wait(3000)

    -- Liberamos al zombie para que continúe con lo demás
    ClearPedTasks(zombie)
end

function DrawZombieHealthBar(coords, healthRatio, level)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if not onScreen then
        return
    end

    -- Si la barra está activada, dibujamos la barra
    if Config.ShowZombieHealthBar then
        ------------------------------------------------
        -- Barra (fondo y parte roja)
        ------------------------------------------------
        local barWidth  = 0.04
        local barHeight = 0.008
        local backgroundAlpha = 150
        local barAlpha = 200

        DrawRect(_x, _y, barWidth, barHeight, 0, 0, 0, backgroundAlpha)

        local barCurrentWidth = barWidth * healthRatio
        local barOffsetX = (barWidth - barCurrentWidth) / 2
        DrawRect(_x - barOffsetX, _y, barCurrentWidth, barHeight, 200, 0, 0, barAlpha)

        ------------------------------------------------
        -- Nivel, si está activado
        ------------------------------------------------
        if Config.ShowZombieLevel then
            -- “Tag” rojo a la izquierda de la barra
            local tagWidth  = 0.015
            local tagHeight = 0.02
            local tagX = _x - (barWidth / 2) - (tagWidth / 2) - 0.003
            local tagY = _y

            DrawRect(tagX, tagY, tagWidth, tagHeight, 200, 0, 0, 0)

            -- Texto del nivel centrado en ese rect
            SetTextFont(4)
            SetTextScale(0.40, 0.40)
            SetTextProportional(1)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString("Lv: "..tostring(level))

            local textOffsetY = 0.017
            DrawText(tagX, tagY - textOffsetY)
        end

    else
        ------------------------------------------------
        -- Si la barra está DESACTIVADA, dibujamos SOLO el nivel en el centro
        ------------------------------------------------
        if Config.ShowZombieLevel then
            local tagWidth  = 0.03  -- Un poco más ancho si quieres
            local tagHeight = 0.03
            -- Simplemente centrado en _x,_y
            DrawRect(_x, _y, tagWidth, tagHeight, 200, 0, 0, 0)

            SetTextFont(4)
            SetTextScale(0.45, 0.45)
            SetTextProportional(1)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString("Lv: "..tostring(level))

            local textOffsetY = 0.01
            DrawText(_x, _y - textOffsetY)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- cada frame

        -- Recorremos zombies
        for _, zombie in ipairs(zombies) do
            if DoesEntityExist(zombie) and not IsPedDeadOrDying(zombie, true) then
                local playerPed = PlayerPedId()
                local zCoords = GetEntityCoords(zombie)
                local dist = #(GetEntityCoords(playerPed) - zCoords)
                
                if dist < 30.0 then
                    local currentHealth = GetEntityHealth(zombie)
                    local maxHealth = zombieData[zombie] and zombieData[zombie].maxHealth or 200
                    local level = zombieData[zombie] and zombieData[zombie].level or 1
                    local isBoss = zombieData[zombie] and zombieData[zombie].isBoss
                    
                    local healthRatio = 0
                    if maxHealth > 0 and currentHealth > 0 then
                        healthRatio = currentHealth / maxHealth
                    end

                    local barPos = vector3(zCoords.x, zCoords.y, zCoords.z + 1.0)
                    DrawZombieHealthBar(barPos, healthRatio, level)
                end
            end
        end
    end
end)

function spawnZombie()
    -- Primero comprobamos si el jugador está en una redzone
    local zone = getCurrentRedZone()
    if not zone then
        -- Si no está en ninguna redzone, no spawneamos
        return
    end

    -- Límite de zombies activos
    if currentZombieCount >= Config.MaxZombiesPerPlayer then
        return
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    -- Elegimos coords aleatorias cerca del jugador
    local spawnX = playerCoords.x + math.random(-Config.SpawnRadius, Config.SpawnRadius)
    local spawnY = playerCoords.y + math.random(-Config.SpawnRadius, Config.SpawnRadius)
    local spawnZ = playerCoords.z + 50.0  -- Empezar arriba para encontrar suelo

    -- Buscar altura de suelo
    local foundGround, groundZ = GetGroundZFor_3dCoord(spawnX, spawnY, spawnZ, false)
    local tries = 0
    while (not foundGround) and (tries < 100) do
        spawnZ = spawnZ - 1.0
        foundGround, groundZ = GetGroundZFor_3dCoord(spawnX, spawnY, spawnZ, false)
        tries = tries + 1
        Wait(200)
    end
    
    if not foundGround then
        return
    end

    spawnZ = groundZ

    -- Ahora elegimos el tipo de zombi según Config.SpawnZoneMode
    local chosenTypeKey = nil

    if Config.SpawnZoneMode == "zombie" then
        -- MODO "zombie": usar la lista de tipos especificados en zone.zTypes
        if not zone.zTypes or #zone.zTypes == 0 then
            return  -- la zona no tiene tipos definidos, no spawneamos
        end
        chosenTypeKey = zone.zTypes[math.random(#zone.zTypes)]
    
    else
        -- MODO "global": tu lógica de densidad (mezcla total)
        local maxAllowed = Config.MaxDensity
        local highestTypes = {}
        for k, zType in pairs(Config.ZombieTypes) do
            if zType.density == maxAllowed then
                table.insert(highestTypes, k)
            end
        end

        if #highestTypes > 0 then
            chosenTypeKey = highestTypes[math.random(#highestTypes)]
        else
            local totalDensity = 0
            for k, zType in pairs(Config.ZombieTypes) do
                totalDensity = totalDensity + (zType.density or 1)
            end
            local rnd = math.random() * totalDensity
            local cumulative = 0
            for k, zType in pairs(Config.ZombieTypes) do
                cumulative = cumulative + (zType.density or 1)
                if rnd <= cumulative then
                    chosenTypeKey = k
                    break
                end
            end
        end
    end

    if not chosenTypeKey then
        return
    end

    -- Obtenemos la info final del tipo
    local zombieType = Config.ZombieTypes[chosenTypeKey]

    -- (NUEVO) Elegir nivel del zombi
    local randomLevel = math.random(Config.MinZombieLevel, Config.MaxZombieLevel)
    local levelData = Config.ZombieLevels[randomLevel]

    -- Elegir modelo aleatorio
    local model = zombieType.models[math.random(#zombieType.models)]
    RequestModel(model)
    while not HasModelLoaded(model) do 
        Wait(0)
    end

    -- Crear el zombi
    local zombie = CreatePed(4, model, spawnX, spawnY, spawnZ, 0.0, true, true)
    SetPedRelationshipGroupHash(zombie, GetHashKey(Config.ZombieRelationshipGroup))
    SetPedFleeAttributes(zombie, 0, false)
    SetBlockingOfNonTemporaryEvents(zombie, true)
    SetPedConfigFlag(zombie, 42, true)
    SetPedCombatAttributes(zombie, 46, true)
    DisablePedPainAudio(zombie, true)
    StopCurrentPlayingAmbientSpeech(zombie)
    StopPedSpeaking(zombie, true)

    playZombieSpawnAnim(zombie)

    TaskWanderStandard(zombie, 10.0, 10)
    SetPedAsEnemy(zombie, true)
    SetPedCombatAttributes(zombie, 46, false)
    SetPedFleeAttributes(zombie, 0, 0)
    SetPedCombatAbility(zombie, 0)
    SetPedCombatMovement(zombie, 0)
    SetPedCombatRange(zombie, 0)
    SetPedTargetLossResponse(zombie, 0)
    SetPedAlertness(zombie, 0)
    SetPedAccuracy(zombie, 0)

    -- Ajustar stats finales
    local baseHealth  = 200
    local baseArmor   = zombieType.armor or 0
    local baseDamage  = zombieType.damage or 10
    local baseSpeed   = zombieType.speed or 1.0

    local finalHealth = baseHealth + (levelData.extraHealth or 0)
    local finalArmor  = baseArmor  + (levelData.extraArmor  or 0)
    local finalDamage = baseDamage + (levelData.extraDamage or 0)
    local finalSpeed  = baseSpeed  + (levelData.extraSpeed  or 0)

    SetPedArmour(zombie, finalArmor)
    SetEntityMaxHealth(zombie, finalHealth)
    SetEntityHealth(zombie, finalHealth)

    zombieType.damage = finalDamage
    zombieType.speed  = finalSpeed

    -- Animación de movimiento
    local clipset = zombieType.clipsets[math.random(#zombieType.clipsets)]
    RequestAnimSet(clipset)
    while not HasAnimSetLoaded(clipset) do
        Wait(0)
    end
    SetPedMovementClipset(zombie, clipset, 1.0)

    table.insert(zombies, zombie)
    currentZombieCount = currentZombieCount + 1

    zombieHealth[zombie] = finalHealth
    zombieData[zombie] = {
        maxHealth = finalHealth,
        level     = randomLevel,
        zTypeKey  = chosenTypeKey
    }

    -- Sonido
    local soundFile = 'nui://' .. GetCurrentResourceName() .. '/sounds/' .. zombieType.sound
    local soundId = "zombie_sound_" .. tostring(zombie)
    local zCoords = GetEntityCoords(zombie)
    soundManager:PlayUrlPos(soundId, soundFile, 0.5, zCoords, true)
    soundManager:Distance(soundId, 20.0)

    -- Hilo IA
    Citizen.CreateThread(function()
        local lastKnownPlayerPos = nil
        local searching = false

        while DoesEntityExist(zombie) do
            Wait(Config.ZombieAttackInterval)
            if IsPedDeadOrDying(zombie, true) then 
                break
            end

            local zPos = GetEntityCoords(zombie)
            soundManager:Position(soundId, zPos)

            if zombieInSafeZone(zPos) then
                soundManager:Destroy(soundId)
                DeleteEntity(zombie)
                for i, z in ipairs(zombies) do
                    if z == zombie then
                        table.remove(zombies, i)
                        currentZombieCount = currentZombieCount - 1
                        break
                    end
                end
                break
            end

            local playerPed = PlayerPedId()
            local zombieCoords = zPos
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - zombieCoords)

            local currentHealth = GetEntityHealth(zombie) or 0
            if currentHealth < (zombieHealth[zombie] or 0) then
                zombieHealth[zombie] = currentHealth
                makeNoise(zPos, Config.AttackRadius)
            else
                zombieHealth[zombie] = currentHealth
            end            

            local seePlayer = canZombieSeePlayer(zombie, playerPed, distance)
            local noisePos, noiseRadius = GetNoisePositionIfRecent()
            local hearPlayer = false
            if noisePos and #(zombieCoords - noisePos) < noiseRadius then
                hearPlayer = true
            end

            if seePlayer then
                lastKnownPlayerPos = playerCoords

                if IsPedDeadOrDying(playerPed, true) and distance < Config.EatingDistance then
                    if not zombieData[zombie].isEating then
                        zombieData[zombie].isEating = true
                        ClearPedTasks(zombie)
                        zombieEatPlayer(zombie)
                        -- Después de 10s, detiene la "comida"
                        Citizen.CreateThread(function()
                            Citizen.Wait(10000)
                            if DoesEntityExist(zombie) then
                                ClearPedTasks(zombie)
                                TaskWanderStandard(zombie, 10.0, 10)
                                zombieData[zombie].isEating = false
                            end
                        end)
                    end
                else
                    updateZombieMovementStyle(zombie, zombieType, playerPed, distance)

                    if IsPedInAnyVehicle(playerPed, false) then
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        local distToVehicle = #(zombieCoords - GetEntityCoords(vehicle))
                        
                        if distToVehicle < DistanceTarget then
                            TaskGoToEntity(zombie, vehicle, -1, 0.0, 1.0, 1073741824, 0)

                            if distToVehicle < VehicleAttackDistance then
                                playZombieAttack(zombie)
                                damageVehicle(vehicle)
                            end
                            
                            if Config.ZombiesCanPullOut then
                                local rand = math.random(100)
                                if rand <= Config.PullOutChance and distToVehicle < VehicleEnterDistance then
                                    pullPlayerOutOfVehicle(zombie, playerPed, vehicle, zombieType)
                
                                    Citizen.Wait(2000)
                                    if not IsPedInAnyVehicle(playerPed, false) then
                                        playZombieAttack(zombie)
                                        local health = GetEntityHealth(playerPed)
                                        SetEntityHealth(playerPed, health - zombieType.damage)
                                    else
                                        playZombieAttack(zombie)
                                        damageVehicle(vehicle)
                                    end
                                else
                                    if distToVehicle < VehicleAttackDistance then
                                        playZombieAttack(zombie)
                                        damageVehicle(vehicle)
                                        
                                        local rand = math.random(100)
                                        if rand <= zombieType.ragdollChance then
                                            local playerPed = PlayerPedId()
                                            if IsPedInAnyVehicle(playerPed, false) then
                                                ClearPedTasksImmediately(playerPed)
                                                local vehCoords = GetEntityCoords(vehicle)
                                                local offsetPos = GetOffsetFromEntityInWorldCoords(vehicle, 2.0, 0.0, 0.0)
                                                SetEntityCoords(playerPed, offsetPos.x, offsetPos.y, offsetPos.z)
                                                Wait(500)
                                            end
                                            if not IsPedInAnyVehicle(playerPed, false) then
                                                SetPedCanRagdoll(playerPed, true)
                                                SetPedToRagdoll(playerPed, 1000, 1000, 0, true, true, false)
                                            end
                                        end
                                    end
                                end
                            else
                                if distToVehicle < VehicleAttackDistance then
                                    playZombieAttack(zombie)
                                    damageVehicle(vehicle)
                                end
                            end
                        end
                    else
                        if distance <= 2.0 then
                            playZombieAttack(zombie)
    
                            local health = GetEntityHealth(playerPed)
                            SetEntityHealth(playerPed, health - zombieType.damage)
                            
                            Wait(1000)
                            updateZombieMovementStyle(zombie, zombieType, playerPed, distance)
                            
                            local rand = math.random(100)
                            if rand <= zombieType.ragdollChance then
                                SetPedCanRagdoll(playerPed, true)
                                SetPedToRagdoll(playerPed, 1000, 1000, 0, true, true, false)
                            end
                
                            if math.random(100) <= Config.Infection.chance then
                                infectionEndTime = GetGameTimer() + Config.Infection.duration
                                TriggerEvent("zombies:playerInfected")
                            end
                        elseif distance >= 2.0 then
                            if zombieType.special then
                                handleSpecialZombie(zombie, zombieType, playerPed, distance, zPos, playerCoords, zombieData[zombie])
                            end
                        end                                
                    end
                end
            elseif hearPlayer then
                lastKnownPlayerPos = noisePos
                TaskGoToCoordAnyMeans(zombie, noisePos.x, noisePos.y, noisePos.z, 1.0, 0, 0, 786603, 0)
                updateZombieMovementStyle(zombie, zombieType, playerPed, #(GetEntityCoords(playerPed) - zPos))
            elseif lastKnownPlayerPos and not searching then
                searching = true
                searchArea(zombie, lastKnownPlayerPos, Config.SearchTime)
                lastKnownPlayerPos = nil
                searching = false
                updateZombieMovementStyle(zombie, zombieType, playerPed, #(GetEntityCoords(playerPed) - zPos))
            elseif not IsPedInCombat(zombie, 0) then
                local target, distClose = getClosestTargetForZombie(zombie, 50.0)
                if target then
                    TaskCombatPed(zombie, target, 0, 16)
                else
                    TaskCombatHatedTargetsAroundPed(zombie, 50.0)
                end
            else
                updateZombieMovementStyle(zombie, zombieType, playerPed, #(GetEntityCoords(playerPed) - zPos))
            end

            -- Blips de zombie
            if Config.ShowZombieBlips then
                local playerCoords = GetEntityCoords(PlayerPedId())
                local distToPlayer = #(GetEntityCoords(zombie) - playerCoords)
                if distToPlayer <= Config.ZombieBlipRadius then
                    if not zombieBlips[zombie] then
                        local blip = AddBlipForEntity(zombie)
                        SetBlipSprite(blip, Config.ZombieBlip.Sprite)
                        SetBlipColour(blip, Config.ZombieBlip.Colour)
                        SetBlipScale(blip, Config.ZombieBlip.Scale)
                        SetBlipAsShortRange(blip, false)
                        BeginTextCommandSetBlipName("STRING")
                        -- (Opcional) Añadir el nivel en el nombre: 
                        -- AddTextComponentString(Config.ZombieBlip.Name .. " [Nivel "..randomLevel.."]")
                        AddTextComponentString(Config.ZombieBlip.Name)
                        EndTextCommandSetBlipName(blip)
                        zombieBlips[zombie] = blip
                    end
                else
                    if zombieBlips[zombie] then
                        RemoveBlip(zombieBlips[zombie])
                        zombieBlips[zombie] = nil
                    end
                end
            end            
        end
        
        if zombieBlips[zombie] then
            RemoveBlip(zombieBlips[zombie])
            zombieBlips[zombie] = nil
        end

        soundManager:Destroy(soundId)
        zombieHealth[zombie] = nil
    end)
end

Citizen.CreateThread(function()
    while true do
        Wait(5000)
        spawnZombie()
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for i = #zombies, 1, -1 do
            local zombie = zombies[i]
            if DoesEntityExist(zombie) and GetEntityHealth(zombie) <= 0 then
                -- Zombie muerto encontrado
                local deadZombie = zombie
                local zCoords = GetEntityCoords(deadZombie)
                local zTypeKey = zombieData[deadZombie].zTypeKey

                -- Genera un ID único para el cadáver:
                local corpseID = math.random(100000,999999)

                -- Guarda algo local si quieres, no siempre es necesario:
                ZombieCorpses[corpseID] = {
                    coords = zCoords,
                    zTypeKey = zTypeKey
                }

                TriggerServerEvent('zombies:registerCorpse', corpseID, { x=zCoords.x, y=zCoords.y, z=zCoords.z }, zTypeKey)

                -- Iniciar un hilo separado para manejar este zombie muerto
                Citizen.CreateThread(function()
                    local deathTime = GetGameTimer()
                    local looted = false

                    while DoesEntityExist(deadZombie) and (GetGameTimer() - deathTime) < Config.DespawnTime do
                        Wait(0)
                        local playerPed = PlayerPedId()
                        local playerCoords = GetEntityCoords(playerPed)
                        local zCoords = GetEntityCoords(deadZombie)
                        local distance = #(playerCoords - zCoords)

                        if Config.EnableZombieLoot and distance < 1.5 then
                            DrawMarker(20, zCoords.x, zCoords.y, zCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 150, false, true, 2, false, nil, nil, false)
                            
                            if IsControlJustReleased(0, Config.LootKey) then
                                TriggerServerEvent('zombies:tryLootCorpse', corpseID)
                                looted = true
                                break
                            end
                        end
                    end

                    -- Después de lootear o cumplirse el tiempo
                    if DoesEntityExist(deadZombie) then
                        DeleteEntity(deadZombie)
                    end
                end)

                -- Remover este zombie de la lista inmediatamente
                table.remove(zombies, i)

                if zombieBlips[zombie] then
                    RemoveBlip(zombieBlips[zombie])
                    zombieBlips[zombie] = nil
                end

                zombieHealth[zombie] = nil
                currentZombieCount = currentZombieCount - 1
            end
        end
    end
end)

Citizen.CreateThread(function()
    local playerPed = PlayerPedId()
    local lastVehicleSpeed = 0.0
    while true do
        Wait(1000)
        playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local isInVehicle = IsPedInAnyVehicle(playerPed, false)
        local speed = 0.0

        if isInVehicle then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            speed = GetEntitySpeed(vehicle)
        else
            speed = GetEntitySpeed(playerPed)
        end

        if not isInVehicle then
            if speed > 2.0 and not GetPedStealthMovement(playerPed) then
                makeNoise(coords, Config.FootstepsNoiseRadius)
            end
        end

        if isInVehicle and speed > Config.VehicleSpeedThreshold then
            makeNoise(coords, Config.VehicleHighSpeedNoise)
        end

        if isInVehicle then
            local speedDrop = lastVehicleSpeed - speed
            if speedDrop > Config.CollisionSpeedDrop then
                makeNoise(coords, Config.CollisionNoiseRadius)
            end
            lastVehicleSpeed = speed
        else
            lastVehicleSpeed = 0.0
        end

        if isInVehicle and IsControlPressed(0, 86) then
            makeNoise(coords, Config.ClaxonNoiseRadius)
        end
    end
end)

function getZoneCenter(zone)
    if zone.type == "circle" then
        return zone.coords
    else
        local sumX, sumY = 0,0
        for _, p in ipairs(zone.points) do
        sumX, sumY = sumX + p.x, sumY + p.y
        end
        local cx, cy = sumX/#zone.points, sumY/#zone.points
        local cz     = (zone.minZ + zone.maxZ)/2
        return vector3(cx, cy, cz)
    end
end

Citizen.CreateThread(function()
    -- RedZones
    if Config.ShowRedZoneBlips then
        for _, zone in ipairs(Config.RedZones) do
            local b = zone.blip or Config.RedZoneBlip

            if zone.type == "circle" then
                local r = AddBlipForRadius(zone.coords, zone.radius)
                SetBlipColour(r, b.colour)
                SetBlipAlpha(r, 128)
            end

            local c = getZoneCenter(zone)
            local m = AddBlipForCoord(c.x, c.y, c.z)
            SetBlipSprite(m, b.sprite)
            SetBlipColour(m, b.colour)
            SetBlipScale(m, b.scale)
            SetBlipAsShortRange(m, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(b.name)
            EndTextCommandSetBlipName(m)

            zone.blipId = m
        end
    end

    if Config.ShowSafeZoneBlips then
        for _, zone in ipairs(Config.SafeZones) do
            local b = zone.blip or Config.SafeZoneBlip

            if zone.type == "circle" then
                local r = AddBlipForRadius(zone.coords, zone.radius)
                SetBlipColour(r, b.colour)
                SetBlipAlpha(r, 128)
            end

            local c = getZoneCenter(zone)
            local m = AddBlipForCoord(c.x, c.y, c.z)
            SetBlipSprite(m, b.sprite)
            SetBlipColour(m, b.colour)
            SetBlipScale(m, b.scale)
            SetBlipAsShortRange(m, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(b.name)
            EndTextCommandSetBlipName(m)
            zone.blipId = m
        end
    end
end)

function getClosestTargetForZombie(zombie, maxRange)
    if not DoesEntityExist(zombie) then return nil end

    local zCoords = GetEntityCoords(zombie)
    local nearestPed = nil
    local nearestDist = maxRange or 50.0

    -- 1) Revisar al jugador local
    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) and not IsPedDeadOrDying(playerPed, true) then
        local dist = #(GetEntityCoords(playerPed) - zCoords)
        if dist < nearestDist then
            nearestDist = dist
            nearestPed  = playerPed
        end
    end

    -- 2) Revisar aliados en activeAllies
    for _, allyPed in ipairs(activeAllies) do
        if DoesEntityExist(allyPed) and not IsPedDeadOrDying(allyPed, true) then
            local dist = #(GetEntityCoords(allyPed) - zCoords)
            if dist < nearestDist then
                nearestDist = dist
                nearestPed  = allyPed
            end
        end
    end

    return nearestPed, nearestDist
end