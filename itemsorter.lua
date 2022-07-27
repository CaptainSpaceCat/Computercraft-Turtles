kIdleDelay = 2

function idle()
    while turtle.getItemCount(1) == 0 do
        sleep(kIdleDelay)
    end
end

function sortEm(keep)
    for i = 1, 16 do
        if turtle.getItemCount(i) > 0 then
            turtle.select(i)
            if turtle.getItemDetail(i).name:find("incomplete") then
                turtle.dropUp()
            else
                turtle.drop()
            end
        end
    end
end

while true do
    idle()
    sortEm()
end
