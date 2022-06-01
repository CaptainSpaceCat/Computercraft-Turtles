-- Buffer
-- computercraft inventory transfer buffer class
-- by CaptainSpaceCat

-- keywords
local class = require "lib/class"

-- objects
local List = require "lib/list"

-- new creation
local Buffer = class()

-- variables
local isTurtle = turtle ~= nil

-- functions

-- initializes the buffer
-- user must specify which side is the storage and sucker side
function Buffer:__init(storage_side, sucker_side)
  self.storage_side = storage_side
  self.sucker_side = sucker_side
  self.storage = peripheral.wrap(storage_side)
  self.sucker = peripheral.wrap(sucker_side)
  self:refresh()
end

-- moves all items from sucker to storage
-- and updates internal inventory to match whatever is in storage
function Buffer:refresh()
  -- move all items from sucker to storage
  local raw_invo = List()
  for i, _ in pairs(self.sucker.list()) do
    raw_invo:append(i)
  end
  for entry in raw_invo() do
    self.storage.pullItems(self.sucker_side, entry)
  end

  -- count up whatever is in storage
  self.inventory = {}
  for i, v in pairs(self.storage.list()) do
    if not self:contains(v.name) then
      entry = {}
      entry.name = v.name
      entry.count = v.count
      entry.indices = List()
      entry.indices:append(i)
      self.inventory[v.name] = entry
    else
      self.inventory[v.name].indices:append(i)
      self.inventory[v.name].count = self.inventory[v.name].count + v.count
    end
  end
end

-- returns true if the buffer contains an item with the specified name
function Buffer:contains(name)
  return self.inventory[name] ~= nil and self.inventory[name].count > 0
end

-- returns the count of items with the specified name
function Buffer:count(name)
  if self:contains(name) then
    return self.inventory[name].count
  end
  return 0
end

-- if any stacks can be combined in the buffer, this function does so
-- and updates the internal inventory
function Buffer:defragment()

end

function Buffer:turtle_idx_to_crafting_idx(idx)
  if idx > 6 then
      return idx + 2
  elseif idx > 3 then
      return idx + 1
  end
  return idx
end

-- attempts to craft <amount> copies of <recipe>
-- TODO make it return false if there's not enough ingredients to do so
-- TODO make it take into account the number of items the recipe outputs and divide accordingly
function Buffer:craft(recipe, amount)
  assert(isTurtle, "Crafting is only possible in a turtle")
  assert(turtle.craft, "Must equip crafting table")

  amount = amount or 1
  for entry in recipe() do
    self:take(entry.name, #entry.positions*amount)
    for idx in entry.positions() do
      turtle.select(self:turtle_idx_to_crafting_idx(idx))
      turtle.suck(amount)
    end
  end
  turtle.select(16)
  turtle.craft()
end

-- if any item exists with the specified name, will attempt to transfer
-- <count> of that item into the sucker
function Buffer:take(name, count)
  if self.inventory[name] == nil then
    return 0
  end
  local total = count
  while #self.inventory[name].indices > 0 do
    local moved = self.storage.pushItems(self.sucker_side, self.inventory[name].indices[0], total)
    self.inventory[name].count = self.inventory[name].count - moved
    total = total - moved
    if total <= 0 then return count end
    -- if we didn't break, it means an itemstack was fully removed without completing the request
    -- this means we can remove this index from the list of indices for this item
    self.inventory[name].indices:pop(0)
  end
  return count - total
end

function Buffer:__tostring()
  local str = "Buffer: {\n"
  for _, entry in pairs(self.inventory) do
    str = str.."["..entry.name.."] = {count: "..tostring(entry.count).."}\n"
  end
  str = str.."}"
  return str
end


return Buffer
