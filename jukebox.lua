local args = {...}
local currentPos = {
	--x, y, z, f
}
 
local scanner = peripheral.wrap("right")
local function getVIP(name)
    players = scanner.getPlayersInRange(120)
    for _, p in pairs(players) do
        if p == name then
            return p
        end
    end
    return players[1]
end

local function getTurtlePos()
	local handle = io.open("turtlePos", "r")
	if handle then
		line =  handle:read("l")
		currentPos.x = tonumber(line)
		line =  handle:read("l")
		currentPos.z = tonumber(line)
		line =  handle:read("l")
		currentPos.f = tonumber(line)
		handle:close()
	else
		currentPos.x = tonumber(args[1])
		currentPos.z = tonumber(args[2])
		currentPos.f = tonumber(args[3])
	end
end

local function updatePos()
	local handle = io.open("turtlePos", "w")
	handle:write(currentPos.x .. "\n")
	handle:write(currentPos.z .. "\n")
	handle:write(currentPos.f .. "\n")
	handle:close()
end

local dirTab = {
	{["x"]=0, ["z"]=-1},
	{["x"]=1, ["z"]=0},
	{["x"]=0, ["z"]=1},
	{["x"]=-1, ["z"]=0},
}
local function forward()
	turtle.forward()
	delta = dirTab[currentPos.f]
	currentPos.x = currentPos.x + delta.x
	currentPos.z = currentPos.z + delta.z
end
local function back()
	turtle.back()
	delta = dirTab[currentPos.f]
	currentPos.x = currentPos.x - delta.x
	currentPos.z = currentPos.z - delta.z
end
local function left()
	turtle.turnLeft()
	currentPos.f = currentPos.f - 1
	if currentPos.f < 1 then
		currentPos.f = currentPos.f + 4
	end
end
local function right()
	turtle.turnRight()
	currentPos.f = currentPos.f + 1
	if currentPos.f > 4 then
		currentPos.f = currentPos.f - 4
	end
end

local function step(dir)
	df = currentPos.f - dir
	if df < 0 then
		df = df + 4
	end
	if df == 0 then
		forward()
	elseif df == 1 then
		left()
	elseif df == 2 then
		back()
	elseif df == 3 then
		right()
	end
	updatePos()
end


local function moveto(pos)
    --take one step towards the goal
    dx = math.max(math.min(pos.x - currentPos.x, 1), -1)
    dz = math.max(math.min(pos.z - currentPos.z, 1), -1)

    -- get list of possible movement directions
    pDirs = {}
    if dx < 0 then
    	pDirs[#pDirs+1] = 4
    elseif dx > 0 then
    	pDirs[#pDirs+1] = 2
    end
    if dz < 0 then
    	pDirs[#pDirs+1] = 1
    elseif dz > 0 then
    	pDirs[#pDirs+1] = 3
    end

    if #pDirs == 0 then
    	return
    elseif #pDirs == 1 then
    	step(pDirs[1])
    else
    	if currentPos.f % 2 == pDirs[1] % 2 then
    		step(pDirs[1])
    	else
    		step(pDirs[2])
    	end
    end
end

local speaker = peripheral.wrap("left")
local b_end = "betterendforge:betterendforge.ambient"
local suffixes = {
"blossoming_spires",
"chorus_forest",
--"dust_wastelands",
"foggy_mushroomland",
"glowing_grasslands",
"megalake",
"megalake_grove",
--"sulphur_springs",
"umbrella_jungle",
}

function printTime(n)
    if n > 1 then
        x, y = term.getCursorPos()
        term.setCursorPos(x, y-1)
        term.clearLine()
    end
    print(n)
end

-- radius 14 from middle
local delay = 0
local function playSound()
    local idx = math.random(1, #suffixes)
    local sound = b_end .. "." .. suffixes[idx]
    delay = math.random(65, 100)
    print("Playing " .. suffixes[idx] .. " for " .. delay .. "s")
    speaker.playSound(sound)
end    

getTurtlePos()
local startTime = os.time()
local secondsMultiplier = 0.02
while true do
    player = getVIP("CaptainSpaceCat7")
    if player then
	    pos = scanner.getPlayerPos(player)
	    moveto(pos)
	end
	local currentTime = os.time()
	print( currentTime - startTime .. "   " .. secondsMultiplier * delay)
	if currentTime - startTime > secondsMultiplier * delay then
		playSound()
		startTime = currentTime
	end
	--printTime()
end

--[[
getTurtlePos()
local moveRoutine = coroutine.create(function ()
	while true do
	    player = getVIP("CaptainSpaceCat7")
	    print("found player " .. player)
	    if player then
		    pos = scanner.getPlayerPos(player)
		    print("player at " .. pos.x .. ":" .. pos.z)
		    moveto(pos)
		end
		coroutine.yield()
	end
end)

while true do
	print("routine status: " .. coroutine.status(moveRoutine))
	coroutine.resume(moveRoutine)
	sleep(0.5)
end
]]
