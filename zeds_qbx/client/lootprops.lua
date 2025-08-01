QBCore = exports['qb-core']:GetCoreObject()

local props = {}
local propsUsabled = {}

CreateThread(function()
    while true do
        Wait(5000)

        props = {}
        local allProps = exports.qbx_core:GetObjects() or {}

        for _, obj in ipairs(allProps) do
            for modelName, _ in pairs(Config.PropLoot) do
                if GetEntityModel(obj) == GetHashKey(modelName) then
                    table.insert(props, obj)
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        local wait = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for i = 1, #props do
            local prop = props[i]
            if DoesEntityExist(prop) and not propsUsabled[prop] then
                local propCoords = GetEntityCoords(prop)
                local dist = #(playerCoords - propCoords)

                if dist < 2.0 and not IsPedInAnyVehicle(playerPed) then
                    wait = 0
                    DrawMarker(32, propCoords.x, propCoords.y, propCoords.z + 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.25, 0, 0, 255, 150, false, true, 2, false, nil, nil, false)

                    if IsControlJustReleased(0, Config.LootKey) then
                        local modelName = nil
                        for name, _ in pairs(Config.PropLoot) do
                            if GetEntityModel(prop) == GetHashKey(name) then
                                modelName = name
                                break
                            end
                        end

                        if modelName then
                            local cooldown = Config.PropLoot[modelName].cooldown or 300

                            propsUsabled[prop] = true
                            FreezeEntityPosition(playerPed, true)
                            ExecuteCommand("e mechanic2") -- O usa TaskPlayAnim si prefieres
                            Wait(2500)
                            ClearPedTasksImmediately(playerPed)
                            FreezeEntityPosition(playerPed, false)

                            TriggerServerEvent("zombies:lootProp", modelName)

                            CreateThread(function()
                                Wait(cooldown * 1000)
                                propsUsabled[prop] = false
                            end)
                        end
                    end
                end
            end
        end

        Wait(wait)
    end
end)
