while (true) do
    turtle.place()

    local item = turtle.getItemDetail()
    if item ~= null then
        if item.name == "terrafirmacraft:item.Wooden Bucket Milk" then
            turtle.dropDown()
        end
    end
    sleep(1)
end
