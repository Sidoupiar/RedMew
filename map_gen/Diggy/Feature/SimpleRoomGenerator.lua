--[[-- info
    Provides the ability to make a simple room with contents
]]

-- dependencies
local Template = require 'map_gen.Diggy.Template'
local Perlin = require 'map_gen.shared.perlin_noise'
local Event = require 'utils.event'
local Debug = require'map_gen.Diggy.Debug'
local Task = require 'utils.Task'
local Token = require 'utils.global_token'

-- this
local SimpleRoomGenerator = {}

local do_spawn_tile = Token.register(function(params)
    Template.insert(params.surface, {params.tile}, {})
end)

local do_mine = Token.register(function(params)
    local sand_rocks = params.surface.find_entities_filtered({position = params.position, name = 'sand-rock-big'})

    if (0 == #sand_rocks) then
        Debug.printPosition(params.position, 'missing rock when trying to mine.')
        return
    end

    for _, rock in pairs(sand_rocks) do
        rock.die()
    end
end)

local function handle_noise(name, surface, position)
    Task.set_timeout_in_ticks(1, do_mine, {surface = surface, position = position})

    if ('water' == name) then
        -- water is lower because for some odd reason it doesn't always want to mine it properly
        Task.set_timeout_in_ticks(5, do_spawn_tile, { surface = surface, tile = { name = 'deepwater-green', position = position}})
        return
    end

    if ('dirt' == name) then
        return
    end

    error('No noise handled for type \'' .. name .. '\'')
end

--[[--
    Registers all event handlers.
]]

local room_noise_minimum_distance_sq

function SimpleRoomGenerator.register(cfg)
    local config = cfg.features.SimpleRoomGenerator

    room_noise_minimum_distance_sq = config.room_noise_minimum_distance * config.room_noise_minimum_distance

    local function get_noise(surface, x, y)
        local seed = surface.map_gen_settings.seed + surface.index
        return Perlin.noise(x * config.noise_variance, y * config.noise_variance, seed)
    end

    Event.add(Template.events.on_void_removed, function (event)
        local position = event.old_tile.position
        local distance_sq = position.x^2 + position.y^2

        if (distance_sq <= room_noise_minimum_distance_sq) then
            return
        end

        local noise = get_noise(event.surface, position.x, position.y)

        for _, noise_range in pairs(config.room_noise_ranges) do
            if (noise >= noise_range.min and noise <= noise_range.max) then
                handle_noise(noise_range.name, event.surface, position)
            end
        end
    end)

    if (config.enable_noise_grid) then
        Event.add(defines.events.on_chunk_generated, function (event)
            for x = event.area.left_top.x, event.area.left_top.x + 31 do
                for y = event.area.left_top.y, event.area.left_top.y + 31 do
                    Debug.print_grid_value(get_noise(event.surface, x, y), event.surface, {x = x, y = y})
                end
            end
        end)
    end
end

return SimpleRoomGenerator
