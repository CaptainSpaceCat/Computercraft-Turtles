local files = {
	"buffer.lua",
	"class.lua",
	"list.lua",
	"recipe.lua",
	"tbl.lua",
	"update.lua",
	"util.lua",
}

for _, f in pairs(files) do
	shell.run("rm ".. f)
	shell.run("wget https://raw.githubusercontent.com/CaptainSpaceCat/Computercraft-Turtles/master/lib/"..f)
end
