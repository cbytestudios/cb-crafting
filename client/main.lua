local RSGCore = exports['rsg-core']:GetCoreObject()
local craftingActive = false
local playerSkills = {}

AddEventHandler('playerSpawned', function()
    RSGCore.Functions.TriggerCallback('cb-skills:loadSkills', function(skills)
        playerSkills = skills
    end)
end)

RegisterNetEvent('cb-skills:setSkill')
AddEventHandler('cb-skills:setSkill', function(skill, data)
    playerSkills[skill] = data
end)

CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for _, spot in ipairs(Config.CraftingSpots) do
            local dist = #(playerCoords - spot.coords)
            if dist < spot.radius and not craftingActive then
                DisplayPrompt(spot, 'crafting')
            end
        end
    end
end)

function DisplayPrompt(spot, actionType)
    local promptText = '[E] Start Crafting'
    RSGCore.Functions.DrawText3D(spot.coords, promptText)
    if IsControlJustPressed(0, 0xCEFD9220) then
        StartCrafting(spot)
    end
end

function StartCrafting(spot)
    local selectedRecipe = nil
    local level = playerSkills[spot.skill].level or 1
    for _, recipe in ipairs(spot.recipes) do
        if level >= recipe.requiredLevel then
            local hasAll = true
            for _, input in ipairs(recipe.inputs) do
                if not HasItem(input.item, input.amount) then
                    hasAll = false
                    break
                end
            end
            if hasAll then
                selectedRecipe = recipe
                break
            end
        end
    end
    
    if not selectedRecipe then
        Config.Notify('No craftable recipes available')
        return
    end
    
    craftingActive = true
    local playerPed = PlayerPedId()
    local animDict = 'amb_work@world_human_hammer@table@male_a@trans'
    local animClip = 'trans_kneel_hammer'
    TaskPlayAnim(playerPed, animDict, animClip, 8.0, -8.0, -1, 1, 0, false, false, false)
    
    local bonus = Config.Skills[spot.skill].levelBonuses[level] or Config.Skills[spot.skill].levelBonuses[1]
    local progressTime = selectedRecipe.time - bonus.timeReducer
    
    RSGCore.Functions.Progressbar('crafting', 'Crafting...', progressTime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        StopAnimTask(playerPed, animDict, animClip, 1.0)
        TriggerServerEvent('crafting:craft', spot, selectedRecipe, level)
        craftingActive = false
    end, function()
        StopAnimTask(playerPed, animDict, animClip, 1.0)
        craftingActive = false
    end)
end

function HasItem(item, amount)
    amount = amount or 1
    local hasItem = nil
    RSGCore.Functions.TriggerCallback('crafting:hasItem', function(result)
        hasItem = result
    end, item, amount)
    while hasItem == nil do
        Citizen.Wait(0)
    end
    return hasItem
end

RSGCore.Functions.DrawText3D = function(coords, text)
    -- Implement or use lib
end