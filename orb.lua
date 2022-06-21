local Buffer = require "lib/buffer"
local List = require "lib/list"
local Recipe = require "lib/recipe"

local delay = 1
local buf = Buffer("top", "front")

function urinate()
    if buf.take("emendatusenigmatica:uranium_ingot", 2) ~= 2 then return false end
    turtle.suck()
    turtle.dropDown()
    if buf.take("emendatusenigmatica:fluorite_dust", 1) ~= 1 then return false end
    turtle.suck()
    turtle.dropDown()
    if buf.take("emendatusenigmatica:sulfur_dust", 1) ~= 1 then return false end
    turtle.suck()
    turtle.dropDown()
end

while true do
    urinate()
    sleep(delay)
end
