local RSGCore = exports['rsg-core']:GetCoreObject()
local craftingActive = false
local playerSkills = {}

AddEventHandler('playerSpawned', function()
    if Config.UseSkills then
        RSGCore.Functions.TriggerCallback('cb-skills:loadSkills', function(skills)
            playerSkills = skills
        end)
    end
    SetupTargets()
end)

if Config.UseSkills then
    RegisterNetEvent('cb-skills:setSkill')
    AddEventHandler('cb-skills:setSkill', function(skill, data)
        playerSkills[skill] = data
        Config.Notify(skill .. ' Level: ' .. data.level .. ' | XP: ' .. data.xp)
    end)
end

function SetupTargets()
    for _, spot in ipairs(Config.CraftingSpots) do
        exports.ox_target:addBoxZone({
            coords = spot.coords,
            size = spot.size,
            rotation = spot.rotation,
            debug = false,
            options = {
                {
                    name = 'craft',
                    label = 'Craft',
                    onSelect = function()
                        if HasItem(spot.requiredTool) then
                            StartCrafting(spot)
                        else
                            Config.Notify('You need a ' .. spot.requiredTool .. ' to craft here.')
                        end
                    end
                }
            }
        })
    end
end

function StartCrafting(spot)
    local level = 1
    if Config.UseSkills then
        level = (playerSkills[spot.skill] or exports['cb-skills']:GetSkillData(PlayerId(), spot.skill)).level
    end
    local selectedRecipe = nil
    local recipeOptions = {}
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
                table.insert(recipeOptions, {
                    title = recipe.output.item,
                    onSelect = function()
                        selectedRecipe = recipe
                        CraftItem(spot, selectedRecipe, level)
                    end
                })
            end
        end
    end
    
    if #recipeOptions == 0 then
        Config.Notify('No craftable recipes available')
        return
    end
    
    exports.ox_lib:showContext({
        id = 'crafting_menu',
        title = 'Choose Recipe',
        options = recipeOptions
    })
end

function CraftItem(spot, recipe, level)
    craftingActive = true
    local playerPed = PlayerPedId()
    local animDict = 'amb_work@world_human_hammer@table@male_a@trans'
    local animClip = 'trans_kneel_hammer'
    TaskPlayAnim(playerPed, animDict, animClip, 8.0, -8.0, -1, 1, 0, false, false, false)
    
    local bonus = Config.Skills[spot.skill].levelBonuses[level] or Config.Skills[spot.skill].levelBonuses[1]
    local progressTime = recipe.time - bonus.timeReducer
    
    RSGCore.Functions.Progressbar('crafting', 'Crafting...', progressTime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        StopAnimTask(playerPed, animDict, animClip, 1.0)
        TriggerServerEvent('crafting:craft', spot, recipe, level)
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