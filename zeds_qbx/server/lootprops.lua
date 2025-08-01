QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("zombies:lootProp", function(propName)
    local src = source
    local Player = exports.qbx_core:Player(src)--QBCore.Functions.GetPlayer(src)
    local lootData = Config.PropLoot[propName]
    if not Player or not lootData then return end

    local totalItems = math.random(lootData.globalMin, lootData.globalMax)
    local itemsGiven = 0

    for _, itemData in ipairs(lootData.items) do
        if itemsGiven >= totalItems then break end

        local chance = math.random(100)
        if chance <= itemData.chance then
            local amount = math.random(itemData.min, itemData.max)
            if amount > 0 then
                local canCarry = exports.ox_inventory:CanCarryItem(src, itemData.item, amount)
                if canCarry then
                    Player.Functions.AddItem(itemData.item, amount)
                    itemsGiven = itemsGiven + 1
                end
            end
        end
    end
end)
