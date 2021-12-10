local args = {...}

--[[ Setting up variables ]]
local fileWriteOK
local url
local filename
local tArgs = { ... }


local function getHttpBody( url )
    http.request( url )
    
    while true do
        local event, url, hBody = os.pullEvent()
        if event == "http_success" then
            print( "HTTP SUCCESS\nURL = "..url )
            return hBody
        elseif event == "http_failure" then
            error( "HTTP FAILURE\nURL = "..url )    -- If the error is not catched, this will exit the program.
            return nil    -- In case this function is called via pcall.
        end
    end
end

local function processHttpBody( hBody, filename )
    local hFile
    
    if hBody then
        local body = hBody.readAll()    -- Read the whole body.
        hFile = io.open( filename, "w" )    -- Open the provided filename for writing.
        hFile:write( body )     -- Write the body to the file.
        hFile:close()   -- Save the changes and close the file.
    else
        print( "Sorry, no body to process." )
        return false
    end
    
    hBody.close()   -- Do not know for sure if this is really necessary, but just in case.
    return true
end

local function checkOverwrite( filename )
    term.setCursorBlink( false )
    print("\nWarning: File already exists. Overwrite? (Y/N)")
    
    while true do
        event, choice = os.pullEvent( "char" )  -- Only listen for "char" events.
        if string.lower( choice ) == "y" then return true end
        if string.lower( choice ) == "n" then return false end
    end
end


local function getRepoPointer()
	local handle = io.open("configs/git.config", "r")
	local username, repo
	if handle then
		username =  handle:read("l")
		repo =  handle:read("l")
		handle:close()
	end
	return username, repo
end

local function saveRepoConfig(username, repo)
	local handle = io.open("configs/git.config", "w")
	if handle then
		handle:write(username .. "\n")
		handle:write(repo .. "\n")
		handle:close()
		print("Set local repo config:")
		print(username .. "/" .. repo)
	else
		print("Failed to write to repo config")
	end
end

local function printUsage(fn)
	if not fn then
		--print base usage
		print("Usage:")
		print("git [repo | push | pull | run]")
	elseif fn == "repo" then
		--print usage for repo command
		print("Usage:")
		print("git repo <username> <repo>")
		print("Sets the local config file to point to a specific github repo")
	elseif fn == "pull" then
		--print usage for pull command
		print("Usage:")
		print("git pull <git filename> <local filename>")
		print("Downloads <git filename> from the repo in your local config")
		print("Saves this file to <local filename>")
	elseif fn == "push" then
		--print usage for push command
		print("git push is still a WIP")
	elseif fn == "run" then
		--print usage for run command
		print("Usage:")
		print("git run <git filename>")
		print("Downloads <git filename> from the repo in your local config")
		print("Runs this file without saving it")
	end
end

local function warnNoRepo()
	print("Missing repo pointer")
	print("First run \"git repo\" to set up")
	printUsage("repo")
end

local function makeGitURL(username, repo, filename)
	return "https://raw.githubusercontent.com/" .. username .. "/" .. repo .. "/main/" .. filename
end

if #args == 0 then
	printUsage()
elseif args[1] == "pull" then
	-- git pull <git file> <local file>?
	if #args == 2 or #args == 3 then
		username, repo = getRepoPointer()
		if not username then
			warnNoRepo()
		else
			--save to filename <args[3]> if provided, else <args[2]>
			local result = processHttpBody(getHttpBody(makeGitURL(username, repo, args[2])), args[3] or args[2])
			if result then
				print("File saved locally to " .. args[3] or args[2])
			end
		end
	else
		printUsage("pull")
	end
elseif args[1] == "push" then
	-- git push <local file> <git file>
elseif args[1] == "run" then
	-- git run <git file>
elseif args[1] == "repo" then
	--git repo <username> <repository>
	--sets the pointer to the repo
	if #args == 3 then
		saveRepoConfig(args[2], args[3])
	else
		printUsage("repo")
	end
else
	--error, undefined command
	printUsage()
end

