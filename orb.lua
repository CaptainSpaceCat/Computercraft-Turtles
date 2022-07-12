local Buffer = require "lib/buffer"

local delay = 1
local timeout = 1
local buf = Buffer("top", "front")
local RS_SIDE = "right"

function pee_ready()
    buf:refresh()
    return (
        buf:count("emendatusenigmatica:uranium_ingot") >= 2 and
        buf:count("emendatusenigmatica:fluorite_dust") >= 1 and
        buf:count("emendatusenigmatica:sulfur_dust") >= 1
    )
end

function toilet_flushed()
    return rs.getAnalogInput(RS_SIDE) == 0
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
    while not pee_ready() and toilet_flushed() do
        sleep(timeout)
    end
    urinate()
    sleep(delay)
end
