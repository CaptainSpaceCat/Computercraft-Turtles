-- Recipe
-- crafting recipe class
-- by CaptainSpaceCat

-- keywords
local class = require "lib/class"

-- objects
local List = require "lib/list"
local util = require "lib/util"

-- new creation
local Recipe = class()

-- functions
function Recipe:__init(output, count)
	self.ingredients = List()
	self.output = output
	self.count = count
end

function Recipe:__call()
	return util.all(self.ingredients.list)
end

function Recipe:add(name, positions)
	local entry = {}
	entry.name = name
	entry.positions = List(positions)
	self.ingredients:append(entry)
end
