-- TODO: Maybe add a check to see if the setup is alright?
-- Change where the turtle is looking at
function setPosition(target)
    -- If neccissary take a 360 degrees turn
    for i = 4, 1, -1 do

        -- Get the current block that the turtle is looking at
        local success, initialBlock = turtle.inspect()
        -- If a block was found all is fine, otherwise keep turning until a block was found
        if success then
            if string.find(initialBlock.name, target) then
                return true
            else
                turnToTarget(target)
            end
        else
            turnToTarget(target)
        end

    end
end

-- Turn to the block that inculde the target param in its name
function turnToTarget(target)
    if target == "Chest" then
        turtle.turnRight()
    elseif target == "storage" then
        turtle.turnLeft()
    elseif target == "Crucible" then
        turtle.turnRight()
    else
        turtle.turnRight()
    end

    -- Return true if the block was found
    local success, block = turtle.inspect()
    if success then if string.find(block.name, target) then return true end end
end

-- Put an ore or unfinished ingot in the crucible
function putInCrucible()
    turtle.suck()
    sleep(1)
    turtle.suck()

    -- TODO: Do we need this?
    -- Store the selected slot
    local lastSlot = turtle.getSelectedSlot()

    -- Either drop it in the top slot or in the bottom slot with a shortcut
    if setPosition("Crucible") then
        turtle.select(15)
        turtle.drop(1)
        turtle.select(lastSlot)
        turtle.drop(1)
    end
end

-- Put the item in the chest next to the turtle
function putInChest()
    -- if setPosition("Chest") then
    if setPosition("storage") then
        turtle.drop()
        setPosition("Crucible")
    end
end

-- Just a check to see if the ingot mold is full or partially filed
function checkForFullIngot(item) return item.damage == 0 end

while true do
    turtle.select(1)
    if setPosition("Crucible") then
        -- Get all items from crucible
        turtle.suck()
        turtle.select(1)
        sleep(1)
        turtle.suck()

        -- Check the first 14 slots for items
        for i = 1, 14 do
            turtle.select(i)
            local item = turtle.getItemDetail()
            -- Check if an item was found, it would crash otherwise ._.
            if item ~= null then
                -- If the item is an empty mold
                if item.name == "terrafirmacraft:item.Mold" then
                    turtle.transferTo(16)
                elseif string.find(item.name, "coal") then
                    turtle.transferTo(15)
                    -- If the item is an ingot
                elseif string.find(item.name, "Unshaped") then
                    -- Check if it is a whole ingot or a partial one
                    if checkForFullIngot(item) then
                        putInChest()
                    else
                        putInCrucible()
                        break
                    end
                else
                    -- Just dump it in the chest
                    putInChest()
                end
            elseif i == 14 then
                turtle.select(16)
                putInCrucible()
            end
        end
        turtle.select(1)

    end

    -- Wait a while for the next ingot to smelt
    sleep(12)
end
