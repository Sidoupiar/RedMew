-- dependencies

-- this
local Config = {
    -- enable debug mode, shows extra messages
    debug = true,

    -- allow cheats. Example: by default the player will have X mining speed
    cheats = true,

    -- a list of features to register and enable
    -- to disable a feature, change the flag
    features = {
        StartingZone = {
            enabled = true,
            register = require 'map_gen.Diggy.Feature.StartingZone'.register,
            initialize = require 'map_gen.Diggy.Feature.StartingZone'.initialize,

            -- initial starting position size, values higher than 30 might break
            starting_size = 8,

            -- the daytime value used for cave lighting
            daytime = 0.5,
        },
        SetupPlayer = {
            enabled = true,
            register = require 'map_gen.Diggy.Feature.SetupPlayer'.register,
            initialize = require 'map_gen.Diggy.Feature.SetupPlayer'.initialize,
            starting_items = {
                {name = 'iron-axe', count = 1},
                {name = 'stone-wall', count = 10},
            },
            cheats = {
                manual_mining_speed_modifier = 1000,
            },
        },
        DiggyHole = {
            enabled = true,
            register = require 'map_gen.Diggy.Feature.DiggyHole'.register,
            initialize = require 'map_gen.Diggy.Feature.DiggyHole'.initialize,
        },
        DiggyCaveCollapse = {
            enabled = true,
            register = require 'map_gen.Diggy.Feature.DiggyCaveCollapse'.register,
            initialize = require 'map_gen.Diggy.Feature.DiggyCaveCollapse'.initialize,

            -- adds per tile what the current stress is
            enable_stress_grid = false,

            -- shows the mask on spawn
            enable_mask_debug = false,

            --the size of the mask used
            mask_size = 9,

            --how much the mask will effect tiles in the different rings of the mask
            mask_relative_ring_weights = {2,3,4},

            -- delay in seconds before the cave collapses
            collapse_delay_min = 1.5,
            collapse_delay_max = 3,

            -- the threshold that will be applied to all neighbors on a collapse via a mask
            collapse_threshold_total_strength = 15,

            support_beam_entities = {
                ['stone-wall'] = 1,
                ['sand-rock-big'] = 1,
                ['out-of-map'] = 1,
                ['stone-brick'] = 0.05,
                ['stone-path'] = 0.05,
                ['concrete'] = 0.1,
                ['hazard-concrete-left'] = 0.1,
                ['hazard-concrete-right'] = 0.1,
                ['refined-concrete'] = 0.1,
                ['refined-hazard-concrete-left'] = 0.15,
                ['refined-hazard-concrete-right'] = 0.15,
                ['deepwater-green'] = 0.2,
            },
            cracking_sounds = {
              'CRACK',
            }
        },
        RefreshMap = {
            enabled = true,
            register = require 'map_gen.Diggy.Feature.RefreshMap'.register,
        },
        SimpleRoomGenerator = {
            enabled = true,
            register = require 'map_gen.Diggy.Feature.SimpleRoomGenerator'.register,

            -- value between 0 and 1, higher value means stronger variance between coordinates
            noise_variance = 0.089,

            -- adds per tile what the current noise is
            enable_noise_grid = false,

            -- minimum distance and noise range required for water to spawn
            room_noise_minimum_distance = 9,
            room_noise_ranges = {
                {name = 'water', min = -1, max = -0.52},
                {name = 'dirt', min = -0.51, max = -0.33},
                {name = 'water', min = 0.52, max = 1},
                {name = 'dirt', min = 0.33, max = 0.51},
            },
        },
        ScatteredResources = {
            enabled = true,
            register = require 'map_gen.Diggy.Feature.ScatteredResources'.register,

            -- percentage of resource added to the sum. 100 tiles means
            -- 10% more resources with a distance_richness_modifier of 10
            -- 20% more resources with a distance_richness_modifier of 5
            distance_richness_modifier = 5,

            -- defines the increased chance of spawning resources
            -- calculated_probability = resource_probability + ((distance / distance_probability_modifier) / 100)
            distance_probability_modifier = 2,

            -- increases the amount of oil * oil_value_modifier
            oil_value_modifier = 650,

            -- percentage of chance that resources will spawn after mining
            resource_probability = 0.15,

            -- max chance of spawning resources based on resource_probability + calculated distance_probability_modifier
            max_resource_probability = 0.45,

            -- chances per resource of spawning, sum must be 1.00
            resource_chances = {
                ['coal']        = 0.21,
                ['copper-ore']  = 0.30,
                ['iron-ore']    = 0.26,
                ['stone']       = 0.20,
                ['uranium-ore'] = 0.02,
                ['crude-oil']   = 0.01,
            },

            -- minimum distance from the spawn point required before it spawns
            minimum_resource_distance = {
                ['coal']        = 16,
                ['copper-ore']  = 18,
                ['iron-ore']    = 18,
                ['stone']       = 15,
                ['uranium-ore'] = 86,
                ['crude-oil']   = 57,
            },

            -- defines the chance of which resource_richness_value to spawn, sum must be 1.00
            resource_richness_probability = {
                ['scarce']     = 0.40,
                ['low']        = 0.28,
                ['sufficient'] = 0.16,
                ['good']       = 0.10,
                ['plenty']     = 0.04,
                ['jackpot']    = 0.02,
            },

            -- defines the min and max range of ores to spawn
            resource_richness_values = {
                ['scarce']     = {1, 200},
                ['low']        = {201, 400},
                ['sufficient'] = {401, 750},
                ['good']       = {751, 1200},
                ['plenty']     = {1201, 2000},
                ['jackpot']    = {2001, 5000},
            },
        },
        AlienSpawner = {
            enabled = true,
            register = require 'map_gen.Diggy.Feature.AlienSpawner'.register,

            -- minimum distance from spawn before aliens can spawn
            alien_minimum_distance = 35,

            -- chance of spawning aliens when mining
            alien_probability = 0.07,
        },
        MiningEfficiency = {
            enabled = true,
            register = require 'map_gen.Diggy.Feature.MiningEfficiency'.register,

            -- percentage * mining productivity level gets added to mining speed
            mining_speed_productivity_multiplier = 15,

            -- standard mining speed
            default_mining_speed = 0.4,
        },
        MarketExchange = {
            enabled = true,
            register = require 'map_gen.Diggy.Feature.MarketExchange'.register,

            stone_to_surface_amount = 50,
            currency_item = 'stone',

            -- price in currency_item
            -- item_name to give
            -- bulk (defaults to {1}) to add bulk options
            market_inventory = {
                {price = 250, item_name = 'small-electric-pole', bulk = {1, 10}},
                {price = 100, item_name = 'raw-fish'},
                {price = 400, item_name = 'steel-axe'},
                {price = 30, item_name = 'stone-brick'},
                {price = 250, item_name = 'stone-wall'},
                {price = 1500, item_name = 'submachine-gun'},
                {price = 125, item_name = 'firearm-magazine', bulk = {1, 10}},
                {price = 1500, item_name = 'light-armor'},
            },
        },
    },
}

return Config
