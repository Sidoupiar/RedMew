-- Size of the logo.
local scale_factor = 6

-- Distance between islands.
local island_distance_x = 256
local island_distance_y = 128

map_gen_decoratives = false -- Generate our own decoratives
map_gen_rows_per_tick = 8 -- Inclusive integer between 1 and 32. Used for map_gen_threaded, higher numbers will generate map quicker but cause more lag.

-- Recommend to use generate, but generate_not_threaded may be useful for testing / debugging.
--require "map_gen.shared.generate_not_threaded"
require "map_gen.shared.generate"

local b = require "map_gen.shared.builders"

local pic = require "map_gen.data.presets.factorio_logo2"
local pic = b.decompress(pic)

local shape = b.picture(pic)
shape = b.scale(shape, scale_factor, scale_factor)

local pattern_width = scale_factor * pic.width + island_distance_x
local pattern_height = scale_factor * pic.height + island_distance_y
shape = b.single_pattern(shape, pattern_width, pattern_height)

shape = b.change_tile(shape, false, "water")

shape = b.fish(shape, 0.008)

return shape