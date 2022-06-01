local files = {
	"class.lua",
	"json.lua",
	"list.lua",
	"util.lua",
	"tbl.lua",
	"set.lua",
	"backpack.lua",
	"buffer.lua",
	"update.lua",
}

for _, f in pairs(files) do
	shell.run("rm ".. f)
	shell.run("wget https://raw.githubusercontent.com/CaptainSpaceCat/Computercraft-Turtles/master/lib/"..f)
end
