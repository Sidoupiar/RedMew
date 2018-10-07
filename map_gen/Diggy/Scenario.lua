-- dependencies
local Config = require 'map_gen.Diggy.Config'
local Debug = require 'map_gen.Diggy.Debug'
local ScenarioInfo = require 'info'

require 'utils.list_utils'
require 'utils.utils'

-- this
local Scenario = {}

-- private state
local scenario_registered = false

--[[--
    Allows calling a callback for each enabled feature.

    Signature: callback(feature_name, Table feature_data) from {@see Config.features}.

    @param if_enabled function to be called if enabled
]]
local function each_enabled_feature(if_enabled)
    local type = type(if_enabled)
    if ('function' ~= type) then
        error('each_enabled_feature expects callback to be a function, given type: ' .. type)
    end

    for current_name, feature_data in pairs(Config.features) do
        if (nil == feature_data.enabled) then
            error('Feature ' .. current_name .. ' did not define the enabled property.')
        end

        if (feature_data.enabled) then
            if_enabled(current_name, feature_data)
        end
    end
end

--[[--
    Register the events required to initialize the scenario.
]]
function Scenario.register(debug)
    if scenario_registered then
        error('Cannot register the scenario multiple times.')
        return
    end

    if ('boolean' == type(debug)) then
        Config.Debug = debug
    end

    if (Config.debug) then
        Debug.enable_debug()
    end

    if (Config.cheats) then
        Debug.enable_cheats()
    end

    local extra_map_info = ''

    each_enabled_feature(
        function(feature_name, feature_data)
            local feature = require ('map_gen.Diggy.Feature.' .. feature_name)
            if ('function' ~= type(feature.register)) then
                error('Feature ' .. feature_name .. ' did not define a register function.')
            end

            feature.register(feature_data)

            if ('function' == type(feature.get_extra_map_info)) then
                extra_map_info = extra_map_info .. feature.get_extra_map_info(feature_data) .. '\n\n'
            end
        end
    )

    ScenarioInfo.set_map_name('Diggy')
    ScenarioInfo.set_map_description('Dig your way through!')
    ScenarioInfo.set_map_extra_info(extra_map_info)

    scenario_registered = true
end

return Scenario
