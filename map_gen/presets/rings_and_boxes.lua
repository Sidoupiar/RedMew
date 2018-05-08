map_gen_decoratives = false -- Generate our own decoratives
map_gen_rows_per_tick = 8 -- Inclusive integer between 1 and 32. Used for map_gen_threaded, higher numbers will generate map quicker but cause more lag.

-- Recommend to use generate, but generate_not_threaded may be useful for testing / debugging.
--require "map_gen.shared.generate_not_threaded"
require "map_gen.shared.generate"

local b = require "map_gen.shared.builders"

local small_circle = b.circle(16)
local big_circle = b.circle(18)
local ring = b.all{big_circle, b.invert(small_circle)}

local box = b.rectangle(10,10)
box = b.translate(box, 16, -16)
local line = b.rectangle(36,1)
line = b.translate(line, 0, -20.5)
box = b.any{box, line}

local boxes = {}
for i = 0, 3 do
    local b = b.rotate(box, degrees(i*90))
    table.insert(boxes, b)
end

boxes = b.any(boxes)

local shape = b.any{ring, boxes}

local shapes ={}
local sf = 1.8
local sf_total = 1
for i = 1, 10 do
    sf_total = sf_total * sf
    local s = b.scale(shape, sf_total, sf_total)
    table.insert(shapes, s)
end

local map = b.any(shapes)

return map