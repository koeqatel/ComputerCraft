local smelting = false

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
        turtle.turnRight()
    elseif target == "Crucible" then
        turtle.turnLeft()
    else
        turtle.turnRight()
    end

    -- Return true if the block was found
    local success, block = turtle.inspect()
    if success then if string.find(block.name, target) then return true end end
end

-- Put an ore or unfinished ingot in the crucible
function putInCrucible(slot)
    turtle.suck()
    sleep(1)
    turtle.suck()

    -- TODO: Do we need this?
    -- Store the selected slot
    local lastSlot = turtle.getSelectedSlot()

    -- Either drop it in the top slot or in the bottom slot with a shortcut
    if setPosition("Crucible") then
        if slot == 1 then
            turtle.drop()
        elseif slot == 2 then
            turtle.select(15)
            turtle.drop(1)
            turtle.select(lastSlot)
            turtle.drop(1)
            turtle.select(15)
            turtle.suck()
            turtle.select(1)
        else
            turtle.drop(1)
        end
    end
end

-- Put the item in the chest next to the turtle
function putInChest()
    -- if setPosition("storage") then
    if setPosition("storage") then
        turtle.drop()
        setPosition("Crucible")
    end
end

-- Put the item in the chest next to the turtle
function putInHopper()
    turtle.dropUp()
    setPosition("Crucible")
end

-- Prepare the crucible to smelt ores
function smeltOre()
    if smelting == false then
        smelting = true
        local lastSlot = turtle.getSelectedSlot()

        -- for i = 1, 14 do
        --     if item ~= null then
        --         local item = turtle.getItemDetail()
        --         if string.find(item.name, "Unshaped") then
        --             -- Check if it is a whole ingot or a partial one
        --             if checkForFullIngot(item) then

        --             else
        --                 print("Found an unfinished one")
        --                 break
        --             end
        --         end
        --     end
        --     if i == 14 then turtle.select(16) end
        -- end

        turtle.select(16)
        putInCrucible(2)
        turtle.select(lastSlot)
        -- turtle.dropUp()
    end
end

-- Just a check to see if the ingot mold is full or partially filed
function checkForFullIngot(item) return item.damage == 0 end

while true do
    local isSmelting = false;

    -- Block the hopper from adding ores
    redstone.setOutput("left", true)
    redstone.setOutput("right", true)
    redstone.setOutput("front", true)
    redstone.setOutput("back", true)

    turtle.select(1)
    if setPosition("Crucible") then
        -- Get all items from crucible
        turtle.suck()
        sleep(1)
        turtle.suck()

        -- Check the first 14 slots for items
        for i = 1, 14 do
            turtle.select(i)
            local item = turtle.getItemDetail()
            -- Check if an item was found, it would crash otherwise ._.
            if item ~= null then
                -- If the item is an ore
                if item.name == "terrafirmacraft:item.Ore" then
                    isSmelting = true
                    putInHopper()
                elseif item.name == "terrafirmacraft:item.Small Ore" then
                    isSmelting = true
                    putInHopper()
                else
                    -- If the item is an empty mold
                    if item.name == "terrafirmacraft:item.Mold" then
                        turtle.transferTo(16)
                        -- If the item is an ingot
                    elseif string.find(item.name, "Unshaped") then
                        -- Check if it is a whole ingot or a partial one
                        if checkForFullIngot(item) then
                            putInChest()
                        else
                            putInCrucible(2)
                            break
                        end
                    else
                        -- Just dump it in the chest
                        putInChest()
                    end
                    if i == 14 then smeltOre() end
                end
            elseif i == 14 then
                smeltOre()
            end
        end
        turtle.select(1)

    end

    smelting = false

    -- Allow the hopper to do what it does best again
    redstone.setOutput("left", false)
    redstone.setOutput("right", false)
    redstone.setOutput("front", false)
    redstone.setOutput("back", false)

    -- Wait a while for the next ingot to smelt
    if isSmelting == true then
        sleep(15)
    else
        sleep(12)
    end
end
