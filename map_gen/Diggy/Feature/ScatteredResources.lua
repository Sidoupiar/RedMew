--[[-- info
    Provides the ability to spawn random ores all over the place.
]]

-- dependencies
local Event = require 'utils.event'
local Debug = require 'map_gen.Diggy.Debug'
local Template = require 'map_gen.Diggy.Template'

-- this
local ScatteredResources = {}

global.ScatteredResources = {
    can_spawn_resources = false
}

local function get_name_by_random(collection)
    local random = math.random()
    local current = 0

    for name, probability in pairs(collection) do
        current = current + probability
        if (current >= random) then
            return name
        end
    end

    Debug.print('Current \'' .. current .. '\' should be higher or equal to random \'' .. random .. '\'')
end

local function spawn_resource(config, surface, x, y, distance)
    local resource_name = get_name_by_random(config.resource_chances)

    if (config.minimum_resource_distance[resource_name] > distance) then
        return
    end

    local min_max = config.resource_richness_values[get_name_by_random(config.resource_richness_probability)]
    local amount = math.ceil(math.random(min_max[1], min_max[2]) * (1 + ((distance / config.distance_richness_modifier) / 100)))

    if ('crude-oil' == resource_name) then
        amount = amount * config.oil_value_modifier
    end

    local position = {x = x, y = y}

    Template.resources(surface, {{name = resource_name, position = position, amount = amount}})
end

--[[--
    Registers all event handlers.
]]
function ScatteredResources.register(cfg)
    local config = cfg.features.ScatteredResources
    function sum(t)
        local sum = 0
        for _, v in pairs(t) do
            sum = sum + v
        end

        return sum
    end

    local resource_sum = sum(config.resource_chances)
    if (1 ~= resource_sum) then
        error('Expected a sum of 1.00, got \'' .. resource_sum .. '\' for config.feature.ScatteredResources.resource_chances.')
    end

    local richness_sum = sum(config.resource_richness_probability)
    if (1 ~= richness_sum) then
        error('Expected a sum of 1.00, got \'' .. richness_sum .. '\' for config.feature.ScatteredResources.resource_richness_probability.')
    end

    Event.add(Template.events.on_void_removed, function(event)
        if (not global.ScatteredResources.can_spawn_resources) then
            return
        end

        local x = event.old_tile.position.x
        local y = event.old_tile.position.y

        local distance = math.floor(math.sqrt(x^2 + y^2))
        local calculated_probability = config.resource_probability + ((distance / config.distance_probability_modifier) / 100)
        local probability = 0.7

        if (calculated_probability < probability) then
            probability = calculated_probability
        end

        if (probability > math.random()) then
            spawn_resource(config, event.surface, x, y, distance)
        end
    end)

    global.ScatteredResources.can_spawn_resources = true
end

return ScatteredResources
