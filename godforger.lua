
local Buffer = require "lib/buffer"
local List = require "lib/list"
local Recipe = require "lib/recipe"

local buf = Buffer("bottom", "front")

local all_shards = List({
    List({
        "atum:anput_godshard",
        "atum:anubis_godshard",
        "atum:horus_godshard",
        "atum:montu_godshard",
        "atum:ptah_godshard",
    }),
    List({
        "atum:atem_godshard",
        "atum:geb_godshard",
        "atum:ra_godshard",
        "atum:shu_godshard",
        "atum:tefnut_godshard",
    }),
    List({
        "atum:isis_godshard",
        "atum:nepthys_godshard",
        "atum:nuit_godshard",
        "atum:osiris_godshard",
        "atum:seth_godshard",
    }),
})

local scaling_factor = {8, 4, 1}

function getLeastPriorityShard()
    local scores = List()
    local m = 1
    for level in all_shards() do
        for shard in level() do
            local entry = {}
            print(buf:count(shard))
            print(scaling_factor[m])
            entry.score = buf:count(shard) * scaling_factor[m]
            entry.name = shard
            scores:append(entry)
        end
        m = m + 1
    end
    maxScore = 0
    maxName = ""
    for entry in scores() do
        if entry.score > maxScore then
            maxScore = entry.score
            maxName = entry.name
        end
    end
    return maxName ~= "" and maxName
end

function getRecipe(shardtype)
  local r = Recipe("atum:godforged_block", 1)
  r:add("atum:nebu_ingot", {1,3,7,9})
  r:add("resourcefulbees:dusty_mummbee_honeycomb", {2,5,8})
  r:add(shardtype, {4,6})
  return r
end

function craft()
  local shard = getLeastPriorityShard()
  if not shard then return false end
  local recipe = getRecipe(shard)
  if shard == nil then
      return false
  end
  buf:craft(recipe)

  -- place the godforged block somewhere to be broken automatically
  turtle.turnLeft()
  turtle.place()
  turtle.turnRight()
  return true
end

while craft() do
    sleep(10)
end
