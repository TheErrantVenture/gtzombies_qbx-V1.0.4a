QBCore = exports['qb-core']:GetCoreObject()

local zombies = {}
local zombieData = {}
local zombieHealth = {}
local currentZombieCount = 0
local bossZombies = {}
local bossZombieBlips = {}
local bossZombieData = {}
local lastBossDeathTime = {}
local flameAuraRunning = {}
local bossCorpses = {}

local soundManager = exports['xsound'] 

Citizen.CreateThread(function()
    for _, zone in ipairs(Config.BossZones) do
        if zone.type == "poly" then
            zone.polyzone = PolyZone:Create(zone.points, {
                name = zone.id,
                minZ = zone.minZ,
                maxZ = zone.maxZ,
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
                debugPoly = zone.debug or false
            })
        end
    end
end)

function isBossInSafeZone(coords)
    for _, zone in ipairs(Config.SafeZones) do
        if zone.type == "circle" then
            -- sólo las circulares usan zone.coords
            if #(coords - zone.coords) <= zone.radius then
                return true
            end

        elseif zone.type == "poly" and zone.polyzone then
            -- para las poligonales, usa el método de PolyZone
            if zone.polyzone:isPointInside(coords) then
                return true
            end
        end
    end
  
    return false
end  

function DrawBossHealthBar(coords, healthRatio)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if not onScreen then return end

    local barWidth   = 0.06
    local barHeight  = 0.01
    local backgroundAlpha = 180
    local barAlpha   = 230

    DrawRect(_x, _y, barWidth, barHeight, 0, 0, 0, backgroundAlpha)

    local barCurrentWidth = barWidth * healthRatio
    local barOffsetX = (barWidth - barCurrentWidth) / 2
    DrawRect(_x - barOffsetX, _y, barCurrentWidth, barHeight, 255, 255, 0, barAlpha)

    SetTextFont(4)
    SetTextScale(0.25, 0.25)
    SetTextProportional(1)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString("ZOMBIE BOSS")
    DrawText(_x, _y - 0.03)
end

function countBossesInZone(zoneId)
    local count = 0
    for _, ped in ipairs(bossZombies) do
        local data = bossZombieData[ped]
        if data and data.zoneId == zoneId and DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) then
            count = count + 1
        end
    end
    return count
end

-- Specials --------------------------------------------------------------------------------

function launchFlamingRock(ped)
    local propModel = ("prop_rock_1_c")
    local player = PlayerPedId()
    local playerCoords = GetEntityCoords(player)
    local pedCoords = GetEntityCoords(ped)

    RequestModel(propModel)
    while not HasModelLoaded(propModel) do Wait(0) end

    local rock = CreateObject(propModel, pedCoords.x, pedCoords.y, pedCoords.z + 1.0, true, true, true)
    SetEntityAsMissionEntity(rock, true, true)
    SetEntityCollision(rock, true, true)
    SetEntityLodDist(rock, 1000)

    -- Calcular dirección normalizada hacia el jugador
    local dir = playerCoords - pedCoords
    local magnitude = math.sqrt(dir.x * dir.x + dir.y * dir.y + dir.z * dir.z)
    local normalizedDir = vector3(dir.x / magnitude, dir.y / magnitude, dir.z / magnitude)

    -- Aplicar fuerza hacia el jugador (ajustado para trayectoria más baja)
    ApplyForceToEntity(rock, 1, normalizedDir.x * 40.0, normalizedDir.y * 40.0, 1.0, 0.0, 0.0, 0.0, 0, false, true, true, false, true)

    -- Efecto visual
    UseParticleFxAssetNextCall("core")
    StartParticleFxLoopedOnEntity("ent_ray_meth_fires", rock, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)

    -- Detección de impacto
    Citizen.CreateThread(function()
        local tick = 0
        while tick < 2000 and DoesEntityExist(rock) do
            Wait(10)
            tick = tick + 10

            if #(GetEntityCoords(rock) - GetEntityCoords(player)) < 5.0 then
                local rockCoords = GetEntityCoords(rock)
                for _, id in ipairs(GetActivePlayers()) do
                    local targetPed = GetPlayerPed(id)
                    if DoesEntityExist(targetPed) and not IsPedDeadOrDying(targetPed) then
                        local dist = #(GetEntityCoords(targetPed) - rockCoords)
                        if dist < 4.0 then
                            SetPedToRagdoll(targetPed, 1000, 1500, 0, false, false, false)
                            ApplyDamageToPed(targetPed, 30, false)
                            ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.5)
                            DeleteEntity(rock)
                            return
                        end
                    end
                end                
            end
        end

        if DoesEntityExist(rock) then
            DeleteEntity(rock)
        end
    end)
end

function activateFlameAura(ped)
    if flameAuraRunning[ped] then return end
    flameAuraRunning[ped] = true

    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded("core") do Wait(0) end

    RequestAnimDict("random@peyote@bird")
    while not HasAnimDictLoaded("random@peyote@bird") do Wait(0) end

    local effects = {}
    local clipsetToRestore = bossZombieData[ped] and bossZombieData[ped].clipset or "move_injured_generic"

    Citizen.CreateThread(function()

        if not DoesEntityExist(ped) or IsPedDeadOrDying(ped,true) then
            flameAuraRunning[ped] = nil
            return
        end

        ResetPedMovementClipset(ped, 0.5)
        Wait(100)
        TaskPlayAnim(ped, "random@peyote@bird", "wakeup", 8.0, -8.0, 2000, 49, 0, false, false, false)
        Wait(2000)

        local pcoords = GetEntityCoords(ped)
        for i = 1, 5 do
            local off = vector3(math.random(-10,10)/10, math.random(-10,10)/10, 0.0)
            UseParticleFxAssetNextCall("core")
            local fx = StartParticleFxLoopedOnEntity("ent_ray_meth_fires", ped, off.x, off.y, off.z, 0.0, 0.0, 0.0, 1.2, false, false, false)
            table.insert(effects, fx)
        end

        launchFlamingRock(ped)

        Wait(6000)

        for _,fx in ipairs(effects) do StopParticleFxLooped(fx,0) end
        RequestAnimSet(clipsetToRestore) while not HasAnimSetLoaded(clipsetToRestore) do Wait(0) end
        SetPedMovementClipset(ped, clipsetToRestore, 1.0)

        flameAuraRunning[ped] = nil
    end)
end

function activateShockwave(ped)
    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded("core") do Wait(0) end

    RequestAnimDict("rcmbarry")
    while not HasAnimDictLoaded("rcmbarry") do Wait(0) end

    local throwForce = 50.0
    local upForce = 12.0
    local vehicleThrowForce = 50.0  -- fuerza horizontal
    local vehicleUpForce = 12.0      -- fuerza hacia arriba
    local shockRadius = 20.0
    local animationDuration = 3000
    local clipsetToRestore = bossZombieData[ped] and bossZombieData[ped].clipset or "move_injured_generic"

    Citizen.CreateThread(function()
        if not DoesEntityExist(ped) or IsPedDeadOrDying(ped, true) then return end

        -- Quitar clipset
        ResetPedMovementClipset(ped, 0.5)
        Wait(100)

        -- Reproducir animación
        TaskPlayAnim(ped, "rcmbarry", "bar_1_attack_idle_aln", 8.0, -8.0, animationDuration, 49, 0, false, false, false)

        -- Efecto visual
        local coords = GetEntityCoords(ped)
        UseParticleFxAssetNextCall("core")
        StartParticleFxNonLoopedAtCoord("bul_leaves", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 10.0, false, false, false)

        -- Empuje a jugadores
        local bossPos = GetEntityCoords(ped)
        for _, id in ipairs(GetActivePlayers()) do
            local target = GetPlayerPed(id)
            if DoesEntityExist(target) and not IsPedDeadOrDying(target) then
                local targetCoords = GetEntityCoords(target)
                local dist = #(bossPos - targetCoords)
                if dist < shockRadius then
                    local dir = targetCoords - bossPos
                    local magnitude = math.sqrt(dir.x^2 + dir.y^2)
                    if magnitude > 0 then
                        dir = vector3(dir.x / magnitude, dir.y / magnitude, 0.0)
                    end

                    SetPedToRagdoll(target, 1000, 1500, 0, false, false, false)
                    ApplyForceToEntity(target, 1, dir.x * throwForce, dir.y * throwForce, upForce, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
                    ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.5)
                end
            end
        end

        local vehicles = GetGamePool("CVehicle")
        for _, veh in ipairs(vehicles) do
            if DoesEntityExist(veh) and not IsEntityDead(veh) then
                local vehCoords = GetEntityCoords(veh)
                local dist = #(bossPos - vehCoords)
                if dist < shockRadius then
                    local dir = vehCoords - bossPos
                    local magnitude = math.sqrt(dir.x^2 + dir.y^2)
                    if magnitude > 0 then
                        dir = vector3(dir.x / magnitude, dir.y / magnitude, 0.0)
                    end
                    -- Fuerza reducida para empuje lateral y vertical
                    ApplyForceToEntity(veh, 1, dir.x * vehicleThrowForce, dir.y * vehicleThrowForce, vehicleUpForce, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
                end
            end
        end

        Wait(animationDuration)

        RequestAnimSet(clipsetToRestore)
        while not HasAnimSetLoaded(clipsetToRestore) do Wait(0) end
        SetPedMovementClipset(ped, clipsetToRestore, 1.0)
    end)
end

function ApplyTimecycleModifierSmoothly(modifier)
    Citizen.CreateThread(function()
        SetTimecycleModifier(modifier)
        local strength = 0.0
        while strength < 1.0 do
            strength = strength + 0.05
            SetTimecycleModifierStrength(strength)
            Citizen.Wait(100)
        end
    end)
end

function RemoveTimecycleModifierSmoothly()
    Citizen.CreateThread(function()
        local strength = 1.0
        while strength > 0.0 do
            strength = strength - 0.05
            SetTimecycleModifierStrength(strength)
            Citizen.Wait(100)
        end
        ClearTimecycleModifier()
    end)
end

function activateToxicCloud(ped)
    local coords = GetEntityCoords(ped)
    local radius = 12.0
    local duration = 8000
    local tick = 5000
    local damagePerTick = 5

    UseParticleFxAssetNextCall("core")
    local cloudFx = StartParticleFxLoopedAtCoord(
        "exp_grd_grenade_smoke",
        coords.x, coords.y, coords.z - 1.0,
        0.0, 0.0, 0.0,
        2.0, false, false, false, false
    )
    SetParticleFxLoopedAlpha(cloudFx, 0.6)
    SetParticleFxLoopedColour(cloudFx, 0.6, 0.8, 0.6)

    local affectedPlayers = {}
    local coughTimers = {}

    Citizen.CreateThread(function()
        local elapsed = 0
        while elapsed < duration and DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) do
            for _, id in ipairs(GetActivePlayers()) do
                local target = GetPlayerPed(id)
                if DoesEntityExist(target) and not IsPedDeadOrDying(target) then
                    local targetCoords = GetEntityCoords(target)
                    local dist = #(targetCoords - coords)

                    if dist < radius then
                        local ticksIn = math.floor(elapsed / tick)
                        local dmg = damagePerTick + ticksIn * 2
                        ApplyDamageToPed(target, dmg, false)

                        if not affectedPlayers[id] then
                            affectedPlayers[id] = true
                            if id == PlayerId() then
                                ApplyTimecycleModifierSmoothly("Barry1_Stoned")
                                TriggerScreenblurFadeIn(500)

                                RequestAnimSet("move_m@injured")
                                while not HasAnimSetLoaded("move_m@injured") do Wait(0) end
                                SetPedMovementClipset(PlayerPedId(), "move_m@injured", 1.0)

                                -- Hilo para animación de toser continua
                                RequestAnimDict("timetable@gardener@smoking_joint")
                                while not HasAnimDictLoaded("timetable@gardener@smoking_joint") do Wait(0) end

                                coughTimers[id] = true
                                Citizen.CreateThread(function()
                                    while coughTimers[id] and DoesEntityExist(PlayerPedId()) do
                                        TaskPlayAnim(PlayerPedId(), "timetable@gardener@smoking_joint", "idle_cough", 8.0, -8.0, 2000, 49, 0, false, false, false)
                                        Wait(5000) -- tiempo entre tosidos
                                    end
                                end)
                            end
                        end

                        if id == PlayerId() and math.random(100) <= 10 and not IsPedRagdoll(PlayerPedId()) then
                            SetPedToRagdoll(PlayerPedId(), 1000, 1500, 0, false, false, false)
                        end
                    else
                        if affectedPlayers[id] then
                            affectedPlayers[id] = nil
                            if id == PlayerId() then
                                RemoveTimecycleModifierSmoothly()
                                TriggerScreenblurFadeOut(500)
                                ResetPedMovementClipset(PlayerPedId(), 0.75)

                                -- Detener animación de toser
                                coughTimers[id] = false
                            end
                        end
                    end
                end
            end

            Wait(tick)
            elapsed = elapsed + tick
        end

        StopParticleFxLooped(cloudFx, 0)

        for _, id in ipairs(GetActivePlayers()) do
            if affectedPlayers[id] and id == PlayerId() then
                RemoveTimecycleModifierSmoothly()
                TriggerScreenblurFadeOut(500)
                ResetPedMovementClipset(PlayerPedId(), 0.75)
                coughTimers[id] = false
            end
        end
    end)
end

function activateSummonMinions(ped)
    local maxMinions = Config.MaxZombieMinions or 10

    Citizen.CreateThread(function()
        while DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) do
            local activeMinions = 0
            for _, z in pairs(zombies) do
                if DoesEntityExist(z) and not IsPedDeadOrDying(z, true) then
                    activeMinions = activeMinions + 1
                end
            end

            if activeMinions < maxMinions then
                local toSpawn = math.min(3, maxMinions - activeMinions)
                for i = 1, toSpawn do   
                    local coords = GetEntityCoords(ped)
                    local offset = coords + vector3(math.random(-5, 5), math.random(-5, 5), 0)
                    spawnZombieMinion(offset)
                    Wait(500) -- delay opcional
                end
            end

            Wait(15000) -- cada 15s intenta invocar
        end
    end)
end

function spawnZombieMinion(coords)
    local zone = getCurrentBossZone()
    if not zone then return end

    -- Elegimos un tipo de zombi aleatorio de Config.ZombieTypes
    local zombieKeys = {}
    for k in pairs(Config.ZombieTypes) do
        table.insert(zombieKeys, k)
    end
    local chosenTypeKey = zombieKeys[math.random(#zombieKeys)]
    local zombieType = Config.ZombieTypes[chosenTypeKey]
    if not zombieType then return end

    -- Nivel aleatorio
    local randomLevel = math.random(Config.MinZombieLevel, Config.MaxZombieLevel)
    local levelData = Config.ZombieLevels[randomLevel]

    -- Modelo aleatorio del tipo
    local model = zombieType.models[math.random(#zombieType.models)]
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    local ped = CreatePed(4, model, coords.x, coords.y, coords.z, 0.0, true, true)
    SetPedRelationshipGroupHash(ped, GetHashKey(Config.ZombieRelationshipGroup))
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedConfigFlag(ped, 42, true)
    SetPedFleeAttributes(ped, 0, false)
    SetPedCombatAttributes(ped, 46, true)
    SetPedAsEnemy(ped, true)
    SetEntityAsMissionEntity(ped, true, true)
    DisablePedPainAudio(ped, true)
    StopCurrentPlayingAmbientSpeech(ped)
    StopPedSpeaking(ped, true)

    -- Stats
    local baseHealth  = 200
    local baseArmor   = zombieType.armor or 0
    local baseDamage  = zombieType.damage or 10
    local baseSpeed   = zombieType.speed or 1.0

    local finalHealth = baseHealth + (levelData.extraHealth or 0)
    local finalArmor  = baseArmor  + (levelData.extraArmor  or 0)
    local finalDamage = baseDamage + (levelData.extraDamage or 0)
    local finalSpeed  = baseSpeed  + (levelData.extraSpeed  or 0)

    SetEntityMaxHealth(ped, finalHealth)
    SetEntityHealth(ped, finalHealth)
    SetPedArmour(ped, finalArmor)

    zombieType.damage = finalDamage
    zombieType.speed  = finalSpeed

    -- Clipset de movimiento
    local clipset = zombieType.clipsets[math.random(#zombieType.clipsets)]
    RequestAnimSet(clipset)
    while not HasAnimSetLoaded(clipset) do Wait(0) end
    SetPedMovementClipset(ped, clipset, 1.0)

    -- Animación de spawn
    playZombieSpawnAnim(ped)

    -- Insertar en la lógica de IA
    table.insert(zombies, ped)
    currentZombieCount = currentZombieCount + 1
    zombieHealth[ped] = finalHealth
    zombieData[ped] = {
        maxHealth = finalHealth,
        level     = randomLevel,
        zTypeKey  = chosenTypeKey,
        isMinion  = true
    }
    zombieData[ped].specialState = {}

    Citizen.CreateThread(function()
        if zombieType.special == "electric" then
            RequestNamedPtfxAsset("core")
            while not HasNamedPtfxAssetLoaded("core") do Wait(1) end
            local positions = {
                {x = 0.0, y = 0.0, z = 0.0},
                {x = 0.5, y = 0.0, z = 0.5},
                {x = -0.5, y = 0.0, z = 0.5},
                {x = 0.0, y = 0.5, z = 0.5},
                {x = 0.0, y = -0.5, z = 0.5}
            }
            for _, pos in ipairs(positions) do
                UseParticleFxAssetNextCall("core")
                local fx = StartParticleFxLoopedOnEntity("ent_dst_elec_fire_sp", ped, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 1.0, false, false, false)
                Citizen.SetTimeout(4000, function()
                    StopParticleFxLooped(fx, false)
                end)
            end
        elseif zombieType.special == "smoke" or zombieType.special == "toxic" then
            RequestNamedPtfxAsset("core")
            while not HasNamedPtfxAssetLoaded("core") do Wait(1) end
            UseParticleFxAssetNextCall("core")
            local fx = StartParticleFxLoopedOnEntity("exp_grd_grenade_smoke", ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.2, false, false, false)
            SetParticleFxLoopedAlpha(fx, 0.6)
            SetParticleFxLoopedColour(fx, 0.5, 0.8, 0.5)
            Citizen.SetTimeout(6000, function()
                StopParticleFxLooped(fx, false)
            end)
        end
    end)    

    -- Iniciar comportamiento
    Citizen.CreateThread(function()
        local lastKnownPlayerPos = nil
        local searching = false

        while DoesEntityExist(ped) do
            Wait(Config.ZombieAttackInterval)
            if IsPedDeadOrDying(ped, true) then break end

            local zCoords = GetEntityCoords(ped)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - zCoords)

            -- IA básica, puedes copiar más de spawnZombie si deseas replicar más lógica
            local seePlayer = canZombieSeePlayer(ped, playerPed, distance)
            if seePlayer then
                local target, dist = getClosestTargetForZombie(ped, 80.0)
                if target and HasEntityClearLosToEntity(ped, target, 17) then
                    local targetCoords = GetEntityCoords(target)
                    local distToTarget = #(targetCoords - zCoords)
                
                    if distToTarget < 2.0 then
                        playZombieAttack(ped)
                        SetEntityHealth(target, GetEntityHealth(target) - finalDamage)
                
                        -- efectos especiales
                        if zombieType.special == "electric" then
                            local currentTime = GetGameTimer()
                            local state = zombieData[ped].specialState
                            if not state.nextTaser or currentTime > state.nextTaser then
                                SetPedToRagdoll(target, 1000, 1000, 0, true, true, false)
                                SetEntityHealth(target, GetEntityHealth(target) - (zombieType.electricDamage or 10))
                                state.nextTaser = currentTime + (zombieType.electric_interval or 5000)
                            end
                        elseif zombieType.special == "smoke" or zombieType.special == "toxic" then
                            SetPedToRagdoll(target, 1000, 1000, 0, true, true, false)
                            SetEntityHealth(target, GetEntityHealth(target) - (zombieType.toxicDamage or 8))
                        end
                    else
                        TaskGoToEntity(ped, target, -1, 0.0, finalSpeed, 1073741824, 0)
                    end
                else
                    TaskWanderStandard(ped, 10.0, 10)
                end
            end                            
        end
    end)
end

function activateTelepathy(ped)
    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded("core") do Wait(0) end

    RequestAnimDict("rcmcollect_paperleadinout@")
    while not HasAnimDictLoaded("rcmcollect_paperleadinout@") do Wait(0) end

    Citizen.CreateThread(function()
        if not DoesEntityExist(ped) or IsPedDeadOrDying(ped, true) then return end

        -- Animación del jefe
        TaskPlayAnim(ped, "rcmcollect_paperleadinout@", "meditiate_idle", 8.0, -8.0, 4000, 49, 0, false, false, false)
        Wait(2000)

        -- Elevar al jefe
        FreezeEntityPosition(ped, true)
        local bossCoords = GetEntityCoords(ped)
        local bossTargetZ = bossCoords.z + 5.0

        Citizen.CreateThread(function()
            while DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) and GetEntityCoords(ped).z < bossTargetZ do
                local coords = GetEntityCoords(ped)
                SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z + 0.05, false, false, false)
                Wait(50)
            end
        end)

        -- Elevar jugadores y partículas
        local affectedPlayers = {}
        for _, id in ipairs(GetActivePlayers()) do
            local targetPed = GetPlayerPed(id)
            if DoesEntityExist(targetPed) and not IsPedDeadOrDying(targetPed) then
                local dist = #(GetEntityCoords(targetPed) - bossCoords)
                if dist < 20.0 then
                    FreezeEntityPosition(targetPed, true)
                    local startZ = GetEntityCoords(targetPed).z
                    local targetZ = startZ + 10.0

                    -- Partículas en el jugador
                    UseParticleFxAssetNextCall("core")
                    local fx = StartParticleFxLoopedOnEntity("ent_dst_elec_fire_sp", targetPed, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, false, false, false)

                    -- Elevación gradual
                    Citizen.CreateThread(function()
                        while DoesEntityExist(targetPed) and not IsPedDeadOrDying(targetPed) and GetEntityCoords(targetPed).z < targetZ do
                            local coords = GetEntityCoords(targetPed)
                            SetEntityCoordsNoOffset(targetPed, coords.x, coords.y, coords.z + 0.10, false, false, false)
                            Wait(50)
                        end
                    end)

                    table.insert(affectedPlayers, { ped = targetPed, fx = fx })
                end
            end
        end

        -- Elevar vehículos cercanos
        local elevatedVehicles = {}
        local vehicleFx = {}

        for _, veh in ipairs(GetGamePool("CVehicle")) do
            if DoesEntityExist(veh) and not IsEntityDead(veh) then
                local dist = #(GetEntityCoords(veh) - bossCoords)
                if dist < 20.0 then
                    FreezeEntityPosition(veh, true)
                    local startZ = GetEntityCoords(veh).z
                    local targetZ = startZ + 10.0

                    -- Partículas en el vehículo
                    UseParticleFxAssetNextCall("core")
                    local fx = StartParticleFxLoopedOnEntity("ent_dst_elec_fire_sp", veh, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, false, false, false)

                    -- Elevación gradual
                    Citizen.CreateThread(function()
                        while DoesEntityExist(veh) and GetEntityCoords(veh).z < targetZ do
                            local coords = GetEntityCoords(veh)
                            SetEntityCoordsNoOffset(veh, coords.x, coords.y, coords.z + 0.10, false, false, false)
                            Wait(50)
                        end
                    end)

                    table.insert(elevatedVehicles, veh)
                    table.insert(vehicleFx, fx)
                end
            end
        end

        -- Esperar flotando
        Wait(3000)

        -- Lanzamiento fuerte hacia atrás y limpiar efectos
        for _, info in pairs(affectedPlayers) do
            local targetPed = info.ped
            local fx = info.fx
            if DoesEntityExist(targetPed) then
                FreezeEntityPosition(targetPed, false)
                StopParticleFxLooped(fx, 0)
                SetPedToRagdoll(targetPed, 1000, 1500, 0, false, false, false)
                ApplyForceToEntity(targetPed, 1, 0.0, 0.0, -60.0, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
            end
        end

        -- Liberar vehículos y limpiar efectos
        for i, veh in ipairs(elevatedVehicles) do
            if DoesEntityExist(veh) then
                FreezeEntityPosition(veh, false)
            end
        end
        for _, fx in pairs(vehicleFx) do
            StopParticleFxLooped(fx, 0)
        end

        -- Liberar jefe
        FreezeEntityPosition(ped, false)
    end)
end

-----------------------------------------------------------------------------------------

function startBossAI(zombie, zone)
    Citizen.CreateThread(function()
        local data = bossZombieData[zombie]
        local lastKnownPlayerPos = nil
        local searching = false
        local bossDamage = zone.damage or 50
        local bossSpeed = zone.speed or 1.2
        local soundId = "boss_sound_" .. tostring(zombie)

        while DoesEntityExist(zombie) do
            Wait(Config.ZombieAttackInterval)
            if IsPedDeadOrDying(zombie, true) then break end

            local zCoords = GetEntityCoords(zombie)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - zCoords)

            if data and data.soundId then
                soundManager:Position(data.soundId, zCoords)
            end

            if isBossInSafeZone(zCoords) then
                if data and data.soundId then
                    soundManager:Destroy(data.soundId)
                end
                DeleteEntity(zombie)
                return
            end

            -- Lógica de visión y oído
            local seePlayer = canZombieSeePlayer(zombie, playerPed, distance)
            local noisePos, noiseRadius = GetNoisePositionIfRecent()
            local hearPlayer = false
            if noisePos and #(zCoords - noisePos) < noiseRadius then
                hearPlayer = true
            end

            if seePlayer then
                lastKnownPlayerPos = playerCoords

                if IsPedInAnyVehicle(playerPed, false) then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    local distToVehicle = #(zCoords - GetEntityCoords(vehicle))

                    if distToVehicle < Config.DistanceTarget then
                        TaskGoToEntity(zombie, vehicle, -1, 0.0, bossSpeed, 1073741824, 0)
                        if distToVehicle < Config.VehicleAttackDistance then
                            playZombieAttack(zombie)
                            damageVehicle(vehicle)
                        end
                        if Config.ZombiesCanPullOut and distToVehicle < Config.VehiclePullOutDistance then
                            pullPlayerOutOfVehicle(zombie, playerPed, vehicle, { damage = bossDamage })
                        end
                    end
                else
                    if distance <= 2.0 then
                        playZombieAttack(zombie)
                        SetEntityHealth(playerPed, GetEntityHealth(playerPed) - bossDamage)

                        if Config.BossInfectionEnabled and math.random(100) <= Config.Infection.chance then
                            TriggerEvent("zombies:playerInfected")
                        end
                    else
                        TaskGoToEntity(zombie, playerPed, -1, 0.0, bossSpeed, 1073741824, 0)
                    end
                end

            elseif hearPlayer then
                lastKnownPlayerPos = noisePos
                TaskGoToCoordAnyMeans(zombie, noisePos.x, noisePos.y, noisePos.z, bossSpeed, 0, 0, 786603, 0)

            elseif lastKnownPlayerPos and not searching then
                searching = true
                searchArea(zombie, lastKnownPlayerPos, Config.SearchTime)
                lastKnownPlayerPos = nil
                searching = false

            else
                local target = getClosestTargetForZombie(zombie, 80.0)
                if target then
                    TaskCombatPed(zombie, target, 0, 16)
                else
                    TaskWanderStandard(zombie, 10.0, 10)
                end
            end
        end

        if IsPedDeadOrDying(zombie, true) and not bossCorpses[NetworkGetNetworkIdFromEntity(zombie)] then
            local corpseID = NetworkGetNetworkIdFromEntity(zombie)
            local cCoords  = GetEntityCoords(zombie)
            TriggerServerEvent('zombies:registerBossCorpse', corpseID, cCoords, zone.id)
            bossCorpses[corpseID] = {ped = zombie, zoneId = zone.id, looted = false}
        end   

        if data and data.soundId then
            soundManager:Destroy(data.soundId)
        end

        local corpseID  = NetworkGetNetworkIdFromEntity(zombie)

        Citizen.SetTimeout(Config.BossCorpseLifetime * 1000, function()
            -- solo avisamos si sigue sin lootear
            if bossCorpses[corpseID] and not bossCorpses[corpseID].looted then
                TriggerServerEvent('zombies:bossCorpseTimeout', corpseID)
            end
        end)  

        if bossZombieBlips[zombie] then
            RemoveBlip(bossZombieBlips[zombie])
            bossZombieBlips[zombie] = nil
        end

        bossZombieData[zombie] = nil
        for i, v in ipairs(bossZombies) do
            if v == zombie then
                table.remove(bossZombies, i)
                break
            end
        end

        lastBossDeathTime[zone.id] = GetGameTimer()
    end)
end

function spawnBossZombie()
    local zone = getCurrentBossZone()
    if not zone then return end

    local now = GetGameTimer()
    local lastDeath = lastBossDeathTime[zone.id] or 0
    local cooldown = (Config.BossRespawnCooldown or 60000)
    
    if now - lastDeath < cooldown then
        local remaining = math.ceil((cooldown - (now - lastDeath)) / 1000)
        TriggerEvent("exports.qbx_core:Notify", ("Boss will spawn again in %s secs."):format(remaining), "error")
        return
    end

    local existing = countBossesInZone(zone.id)
    if existing >= (zone.maxBosses or 1) then return end -- 👈 limita por zona

    local model = zone.model
    local coords = getRandomPointInZone(zone)

    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    local ped = CreatePed(4, model, coords.x, coords.y, coords.z, 0.0, true, true)
    SetPedRelationshipGroupHash(ped, GetHashKey(Config.ZombieRelationshipGroup))
    SetPedFleeAttributes(ped, 0, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedConfigFlag(ped, 42, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedCombatAttributes(ped, 5, true)
    DisablePedPainAudio(ped, true)
    StopCurrentPlayingAmbientSpeech(ped)
    StopPedSpeaking(ped, true)

    playZombieSpawnAnim(ped)

    TaskWanderStandard(ped, 10.0, 10)
    SetPedAsEnemy(ped, true)
    SetPedCombatAttributes(ped, 46, false)
    SetPedFleeAttributes(ped, 0, 0)
    SetPedCombatAbility(ped, 0)
    SetPedCombatMovement(ped, 0)
    SetPedCombatRange(ped, 0)
    SetPedTargetLossResponse(ped, 0)
    SetPedAlertness(ped, 0)
    SetPedAccuracy(ped, 0)
    SetPedSuffersCriticalHits(ped, false)
    SetPedCanRagdoll(ped, false)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetPedRagdollOnCollision(ped, false)
    SetEntityProofs(ped, false, false, false, true, false, false, false, false)
    SetPedLegIkMode(ped, 0) -- Opcional, ayuda a evitar animaciones raras

    local soundFile = 'nui://'..GetCurrentResourceName()..'/sounds/'.. (zone.specialSound)

    local soundId   = "boss_sound_"..ped      -- único por jefe
    local coords    = GetEntityCoords(ped)

    soundManager:PlayUrlPos(soundId, soundFile, 0.6, coords, true)  -- loop
    soundManager:Distance(soundId, 35.0)

    -- Stats del jefe
    local health = zone.health or 2000
    local armor = zone.armor or 300
    SetEntityMaxHealth(ped, health)
    SetEntityHealth(ped, health)
    SetPedArmour(ped, armor)

    -- Clipset de movimiento (usar estilo zombie grande o pesado)
    local clipset = zone.clipset or "move_injured_generic"
    RequestAnimSet(clipset)
    while not HasAnimSetLoaded(clipset) do Wait(0) end
    SetPedMovementClipset(ped, clipset, 1.0)

    table.insert(bossZombies, ped)
    bossZombieData[ped] = {
        zoneId = zone.id,
        health = health,
        spawnTime = now,
        clipset = clipset,
        soundId = soundId
    }

    if Config.BossBlips then
        local blip = AddBlipForEntity(ped)
        SetBlipSprite(blip, zone.blip.bossSprite or 458)
        SetBlipColour(blip, zone.blip.bossColour or 3)
        SetBlipScale(blip, zone.blip.bossScale or 1.2)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(zone.blip.bossName or "Zombie Boss")
        EndTextCommandSetBlipName(blip)
        bossZombieBlips[ped] = blip
    end

    -- IA (puedes usar la misma lógica de persecución de client.lua)
    startBossAI(ped, zone)

    -- Specials
    if zone.special then
        startBossSpecialAbilityLoop(ped, zone.special, zone)
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local plyPed   = PlayerPedId()
        local plyCoord = GetEntityCoords(plyPed)

        for corpseID, data in pairs(bossCorpses) do
            if data.looted then goto continue end

            local ped   = data.ped
            if not DoesEntityExist(ped) then goto continue end
            local cPos  = GetEntityCoords(ped)
            local dist  = #(plyCoord - cPos)

            if dist <= Config.BossLoot.distance then
                -- DrawMarker
                DrawMarker(
                    Config.BossLoot.marker.type, cPos.x, cPos.y, cPos.z + 1.0,
                    0.0,0.0,0.0, 0.0,0.0,0.0,
                    Config.BossLoot.marker.scale.x, Config.BossLoot.marker.scale.y, Config.BossLoot.marker.scale.z,
                    Config.BossLoot.marker.colour.r, Config.BossLoot.marker.colour.g, Config.BossLoot.marker.colour.b,
                    Config.BossLoot.marker.colour.a, false,true,2,false,nil,nil,false
                )

                if IsControlJustPressed(0, Config.LootKey) then
                    TriggerServerEvent('zombies:tryLootBoss', corpseID)
                end
            end
            ::continue::
        end
    end
end)

function startBossSpecialAbilityLoop(ped, specialType, zone)
    local minInterval = (zone.abilityInterval and zone.abilityInterval.min) or 10000
    local maxInterval = (zone.abilityInterval and zone.abilityInterval.max) or 20000

    Citizen.CreateThread(function()
        Wait(5000) -- Pequeño delay inicial

        while DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) do
            local interval = math.random(minInterval, maxInterval)
            Wait(interval)

            if specialType == "flameAura" then
                activateFlameAura(ped)
            elseif specialType == "shockwave" then
                activateShockwave(ped)
            elseif specialType == "toxicCloud" then
                activateToxicCloud(ped)
            elseif specialType == "minions" then
                activateSummonMinions(ped)
            elseif specialType == "telepathy" then
                activateTelepathy(ped)
            end
        end
    end)
end

function getRandomPointInZone(zone)
    if zone.type == "circle" then
        local angle = math.random() * math.pi * 2
        local r = math.random() * zone.radius
        local x = zone.coords.x + math.cos(angle) * r
        local y = zone.coords.y + math.sin(angle) * r
        local z = zone.coords.z
        return vector3(x, y, z)
    elseif zone.type == "poly" then
        local sumX, sumY = 0, 0
        for _, v in ipairs(zone.points) do
            sumX = sumX + v.x
            sumY = sumY + v.y
        end
        local cx = sumX / #zone.points
        local cy = sumY / #zone.points
        local cz = zone.minZ + (zone.maxZ - zone.minZ) * 0.5
        return vector3(cx, cy, cz)
    end
end

function getCurrentBossZone()
    local coords = GetEntityCoords(PlayerPedId())
    for _, zone in ipairs(Config.BossZones) do
        if zone.type == "circle" then
            if #(coords - zone.coords) <= zone.radius then
                return zone
            end
        elseif zone.type == "poly" and zone.polyzone and zone.polyzone:isPointInside(coords) then
            return zone
        end
    end
    return nil
end

Citizen.CreateThread(function()
    while true do
        Wait(5000)
        local zone = getCurrentBossZone()
        if zone then
            spawnBossZombie()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerPed    = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for _, ped in ipairs(bossZombies) do
            if DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) then
                local coords = GetEntityCoords(ped)
                local dist   = #(playerCoords - coords)
                if dist <= 15.0 then
                    local health    = GetEntityHealth(ped)
                    local maxHealth = GetEntityMaxHealth(ped)
                    local ratio     = (maxHealth > 0 and health > 0) and (health / maxHealth) or 0.0
                    local barPos    = vector3(coords.x, coords.y, coords.z + 1.5)
                    DrawBossHealthBar(barPos, ratio)
                end
            end
        end
    end
end)

function getZoneCenter(zone)
    if zone.type == "circle" then
        return zone.coords
    else
        local c = getRandomPointInZone(zone)
        return vector3(c.x, c.y, c.z)
    end
end

RegisterNetEvent('zombies:bossLooted', function(corpseID)
    local info = bossCorpses[corpseID]; if not info then return end

    if DoesEntityExist(info.ped) then DeleteEntity(info.ped) end
    if bossZombieBlips[info.ped] then
        RemoveBlip(bossZombieBlips[info.ped]); bossZombieBlips[info.ped] = nil
    end
    soundManager:Destroy("boss_sound_"..info.ped)

    bossCorpses[corpseID] = nil
end)

RegisterNetEvent('zombies:bossCorpseRemoved', function(corpseID)
    local info = bossCorpses[corpseID]; if not info then return end

    if DoesEntityExist(info.ped) then DeleteEntity(info.ped) end
    if bossZombieBlips[info.ped] then
        RemoveBlip(bossZombieBlips[info.ped]); bossZombieBlips[info.ped] = nil
    end
    soundManager:Destroy("boss_sound_"..info.ped)

    bossCorpses[corpseID] = nil
end)

Citizen.CreateThread(function()
    if Config.ShowBossZoneBlips then
        for _, zone in ipairs(Config.BossZones) do
            local radiusBlip = AddBlipForRadius(zone.coords, zone.radius)
            SetBlipColour(radiusBlip, zone.blip.colour or 7)
            SetBlipAlpha(radiusBlip, 128)
    
            local center = getZoneCenter(zone)
            local blip = AddBlipForCoord(center.x, center.y, center.z)
            SetBlipSprite(blip, zone.blip.sprite or 310)
            SetBlipColour(blip, zone.blip.colour or 7)
            SetBlipScale(blip, zone.blip.scale or 1.0)
            SetBlipAsShortRange(blip, true)
    
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(zone.blip.name or "Boss Zone")
            EndTextCommandSetBlipName(blip)
        end
    end
end)