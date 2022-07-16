
function waitToCraft()
	rs.setAnalogOutput("top", 15)
	while true do
		if turtle.getItemCount(1) > 0 then
			rs.setAnalogOutput("top", 0)
			return true
		end
		sleep(5)
	end
end


while waitToCraft() do
	turtle.craft()
	turtle.drop()
	sleep(1)
end
