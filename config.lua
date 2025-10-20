Config = {}

-- Crafting Spots
Config.CraftingSpots = {
    {
        coords = vector3(-550.0, 1950.0, 310.0),
        radius = 2.0,
        requiredTool = 'hammer',
        recipes = {
            {
                inputs = {
                    {item = 'iron_ingot', amount = 2},
                    {item = 'wood', amount = 5},
                },
                output = {item = 'pickaxe', amount = 1},
                time = 20000,
                requiredLevel = 2,
            },
            {
                inputs = {
                    {item = 'gold_bar', amount = 1},
                    {item = 'leather', amount = 3},
                },
                output = {item = 'gold_ring', amount = 1},
                time = 25000,
                requiredLevel = 3,
            },
        },
        skill = 'crafting'
    },
}

-- General Settings
Config.Notify = function(msg) RSGCore.Functions.Notify(msg, 'primary') end