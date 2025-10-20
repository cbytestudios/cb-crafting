# cb-crafting
Crafting system made for RSG Framework
# cb-crafting

## Overview
The `cb-crafting` resource provides a crafting system for the RSG Framework, designed for RedM servers. It allows players to craft items at designated workstations using multiple input items, with progression tied to the `crafting` skill in the `cb-skills` resource. The system checks for required items and minimum skill levels before crafting, and awards XP upon completion. Data is persisted via the `cb-skills` database and RSG-Core metadata, with saves on logout and periodic intervals.

## Features
- Configurable crafting spots with multiple recipes, each requiring specific items and skill levels.
- Integration with `cb-skills` for `crafting` skill progression.
- Optimized inventory checks using `rsg-inventory`.
- Progress bar and animations for immersive crafting experience.

## Dependencies
- `rsg-core`: Required for core framework functionality, player management, and notifications.
- `cb-skills`: Required for skill progression and persistence.
- `oxmysql`: Required for database operations (via `cb-skills`).
- `rsg-inventory`: Required for inventory management and item checks.

## Installation
1. **Add Resource to Server**:
   - Place the `cb-crafting` folder in your server's `resources` directory.
   - Add `ensure cb-crafting` to your `server.cfg`, ensuring `cb-skills` starts first.

2. **Configuration**:
   - Edit `config.lua` to customize crafting spots, recipes, required tools, and skill requirements.
   - Recipes include input items, output items, crafting time, and minimum skill level.

3. **Items for rsg-inventory**:
   - Add the following items to your `rsg-inventory` items table:
     ```json
     [
         {"name": "hammer", "label": "Hammer", "weight": 1.5, "type": "item", "description": "A tool for crafting."},
         {"name": "wood", "label": "Wood", "weight": 0.5, "type": "item", "description": "Wood planks for crafting."},
         {"name": "leather", "label": "Leather", "weight": 0.3, "type": "item", "description": "Leather for crafting."},
         {"name": "iron_ingot", "label": "Iron Ingot", "weight": 1.0, "type": "item", "description": "Smelted iron ingot."},
         {"name": "gold_bar", "label": "Gold Bar", "weight": 1.2, "type": "item", "description": "Smelted gold bar."},
         {"name": "pickaxe", "label": "Pickaxe", "weight": 2.0, "type": "item", "description": "A crafted pickaxe for mining."},
         {"name": "gold_ring", "label": "Gold Ring", "weight": 0.1, "type": "item", "description": "A crafted gold ring."}
     ]
     ```
   - Ensure these items are added to the `items` table or inventory configuration as per your `rsg-inventory` setup.

4. **Database**:
   - No additional database setup is required, as it relies on `cb-skills` for skill persistence.

## Usage
- **Crafting**:
  - Players approach a crafting spot and press [E] to start crafting.
  - The system selects the first available recipe where the player has the required items and crafting skill level.
  - Crafting consumes input items, plays an animation, and awards the output item and `crafting` skill XP.

## Server Configuration
Add to `server.cfg`:
```cfg
ensure cb-crafting
```

## Notes
- Coordinates and animations in `config.lua` are placeholders and should be tested in-game.
- The `HasItem` function uses `rsg-inventory` callbacks for accurate inventory checks.
- The `DrawText3D` function may require a custom implementation or a third-party library.
- For a better user experience, consider adding a menu system for recipe selection.

## Support
For issues or feature requests, contact the developer through the project's repository or community forums.
