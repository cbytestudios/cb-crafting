local RSGCore = exports['rsg-core']:GetCoreObject()

RSGCore.Functions.CreateCallback('crafting:hasItem', function(source, cb, item, count)
    local Player = RSGCore.Functions.GetPlayer(source)
    local itemData = Player.Functions.GetItemByName(item)
    if itemData and itemData.amount >= count then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('crafting:craft')
AddEventHandler('crafting:craft', function(spot, recipe, level)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    for _, input in ipairs(recipe.inputs) do
        Player.Functions.RemoveItem(input.item, input.amount)
    end
    
    local bonus = Config.Skills[spot.skill].levelBonuses[level] or Config.Skills[spot.skill].levelBonuses[1]
    local outputAmount = math.floor(recipe.output.amount * bonus.yieldMultiplier)
    Player.Functions.AddItem(recipe.output.item, outputAmount)
    
    if Config.UseSkills then
        exports['cb-skills']:AddSkillXP(src, spot.skill, Config.Skills[spot.skill].xpPerAction)
    end
end)