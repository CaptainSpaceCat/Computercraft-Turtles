local Buffer = require "lib/buffer"

local delay = 1
local buf = Buffer("top", "front")

function pee_ready()
    return (
        buf:count("emendatusenigmatica:uranium_ingot") >= 2 and
        buf:count("emendatusenigmatica:fluorite_dust") >= 1 and
        buf:count("emendatusenigmatica:sulfur_dust") >= 1
    )
end

function urinate()
    buf:take("emendatusenigmatica:uranium_ingot", 2)
    turtle.suck()
    turtle.dropDown()
    buf:take("emendatusenigmatica:fluorite_dust", 1)
    turtle.suck()
    turtle.dropDown()
    buf:take("emendatusenigmatica:sulfur_dust", 1)
    turtle.suck()
    turtle.dropDown()
end

while true do
    while not pee_ready() do
        sleep(10)
    end
    urinate()
    buf:refresh()
    sleep(delay)
end
