QBCore = exports['qb-core']:GetCoreObject()

local Corpses = {}
local lastLootTimes = {}
local BossCorpses = {}
local ZoneLootBlock = {}

RegisterNetEvent('zombies:giveLoot', function(zombieTypeKey)
    local src = source
    if not Config.EnableZombieLoot then return end

    local Player = exports.qbx_core:GetPlayer(src)--QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if Config.LootMode == "zombie" then
        local zTypeData = zombieTypeKey and Config.ZombieTypes[zombieTypeKey]
        if zTypeData and zTypeData.loot then
            for _, lootData in ipairs(zTypeData.loot) do
                if math.random(100) <= lootData.chance then
                    local amount = math.random(lootData.min, lootData.max)
                    if amount > 0 then
                        Player.Functions.AddItem(lootData.item, amount)
                    end
                end
            end
        end
    else
        for _, lootData in ipairs(Config.ZombieLootItems) do
            if math.random(100) <= lootData.chance then
                local amount = math.random(lootData.min, lootData.max)
                if amount > 0 then
                    Player.Functions.AddItem(lootData.item, amount)
                end
            end
        end
    end
end)

--QBCore.Functions.CreateCallback('zombies:hasCureItem', function(source, cb, itemName)
QBCore.Functions.CreateCallback('zombies:hasCureItem', function(source, cb, itemName)
    local Player = exports.qbx_core:Player(source)--QBCore.Functions.GetPlayer(source)
    if Player then
        local item = Player.Functions.GetItemByName(itemName)
        cb(item ~= nil and item.amount and item.amount > 0)
    else
        cb(false)
    end
end)

exports.qbx_core:CreateUseableItem('cureitem', function(source)--QBCore.Functions.CreateUseableItem('cureitem', function(source)
    local Player = exports.qbx_core:GetPlayer(source)--QBCore.Functions.GetPlayer(source)
    if Player then
        Player.Functions.RemoveItem('cureitem', 1)
        TriggerClientEvent("zombies:infectionCured", source)
        --print("[Zombies] Cureitem usado por jugador " .. tostring(source))
    end
end)

RegisterNetEvent('zombies:cureInfection', function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)--QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local item = Player.Functions.GetItemByName(Config.Infection.cureItem)
    if item and item.amount >= 1 then
        Player.Functions.RemoveItem(Config.Infection.cureItem, 1)
        TriggerClientEvent("zombies:infectionCured", src)
    else
        TriggerClientEvent('exports.qbx_core:Notify', src, 'Need the cure item', 'error')
    end
end)

RegisterNetEvent('zombies:registerCorpse', function(corpseID, coords, zTypeKey)
    if not Config.EnableZombieLoot then return end
    Corpses[corpseID] = {
        coords = coords,
        zTypeKey = zTypeKey,
        looted = false
    }
end)

RegisterNetEvent('zombies:tryLootCorpse', function(corpseID)
    local src = source
    local Player = exports.qbx_core:Player(src)--QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if not Config.EnableZombieLoot or not corpseID or not Corpses[corpseID] then return end
    local corpseData = Corpses[corpseID]
    if corpseData.looted then return end

    -- No se puede obtener ped desde el server en QBCore, validación omitida

    local zTypeData = Config.ZombieTypes[corpseData.zTypeKey]
    if Config.LootMode == "zombie" and zTypeData and zTypeData.loot then
        for _, lootData in ipairs(zTypeData.loot) do
            if math.random(100) <= lootData.chance then
                local amount = math.random(lootData.min, lootData.max)
                if amount > 0 then
                    Player.Functions.AddItem(lootData.item, amount)
                end
            end
        end
    else
        for _, lootData in ipairs(Config.ZombieLootItems) do
            if math.random(100) <= lootData.chance then
                local amount = math.random(lootData.min, lootData.max)
                if amount > 0 then
                    Player.Functions.AddItem(lootData.item, amount)
                end
            end
        end
    end

    if Config.BossZones then
        for _, zone in pairs(Config.BossZones) do
            if zone.id == corpseData.zTypeKey and zone.loot then
                for _, lootData in ipairs(zone.loot) do
                    if math.random(100) <= lootData.chance then
                        local amount = math.random(lootData.min, lootData.max)
                        if amount > 0 then
                            Player.Functions.AddItem(lootData.item, amount)
                        end
                    end
                end
            end
        end
    end

    Corpses[corpseID].looted = true
    --print("[Zombies] Jugador "..src.." looteó el cadáver ID "..corpseID)
end)

RegisterNetEvent('zombies:allyRevivePlayer', function(targetId)
    -- Si tienes un sistema de revive en QBCore, cámbialo aquí
    TriggerClientEvent('hospital:client:Revive', targetId)
end)

RegisterNetEvent('zombies:registerBossCorpse', function(corpseID, coords, zoneId)
    if not corpseID then return end
    BossCorpses[corpseID] = {
        coords  = coords,
        zoneId  = zoneId,
        looted  = false
    }
end)

RegisterNetEvent('zombies:tryLootBoss', function(corpseID)
    local src   = source
    local P     = exports.qbx_core:Player(src);--QBCore.Functions.GetPlayer(src); if not P then return end
    local corpse= BossCorpses[corpseID];           if not corpse then return end

    local zoneId= corpse.zoneId
    local now   = GetGameTimer()

    if ZoneLootBlock[zoneId] and now < ZoneLootBlock[zoneId] then
        local secs = math.ceil((ZoneLootBlock[zoneId]-now)/1000)
        TriggerClientEvent('exports.qbx_core:Notify', src,--QBCore:Notify
            ('Espere %s s para volver a lootear.' ):format(secs), 'error')
        return
    end

    if corpse.looted then return end

    local ped = GetPlayerPed(src)
    local dist = #(GetEntityCoords(ped) -
                   vector3(corpse.coords.x, corpse.coords.y, corpse.coords.z))
    if dist > Config.BossLoot.distance + 1.0 then return end

    local zoneCfg
    for _,z in pairs(Config.BossZones) do if z.id==zoneId then zoneCfg=z break end end
    if zoneCfg and zoneCfg.loot then
        for _,l in ipairs(zoneCfg.loot) do
            if math.random(100) <= l.chance then
                P.Functions.AddItem(l.item, math.random(l.min,l.max))
            end
        end
    end

    corpse.looted        = true
    ZoneLootBlock[zoneId]= now + (Config.BossLoot.globalCooldown*1000)
    TriggerClientEvent('zombies:bossLooted', -1, corpseID)

end)
