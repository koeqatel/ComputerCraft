print('Running version 1.0.15 of the getItem script')
chatbox = peripheral.wrap("right")
interface = peripheral.wrap("left")
meBridge = peripheral.wrap("back")
 
interface.setOutputSide("west")
interface.setInputSide("west")
 
while true do
    action = ""
    item = ""
    amount = ""
    metadata = ""
 
    -- Wait for player command
    event, player, table = os.pullEvent("command")
    -- Get player inventory
    local s, e = pcall(function()
        for key, value in pairs(table) do
            -- Get action, item, amount and metadata
            if (key == 1) then action = value end
            if (key == 2) then item = value end
            if (key == 3) then amount = tonumber(value) end
            if (key == 4) then metadata = tonumber(value) end
 
            -- Check if everything is filled in
            if (action ~= "" and item ~= "" and amount ~= "" and metadata ~= "") then
                if (action == 'getItem') then
                    -- Get items from the me system     
                    meBridge.retrieve(item, metadata, amount, "south")
 
                    inv = interface.getPlayerInv(player)
                    for i = 0, 26 do inv.push(i, 64) end
 
                else
                    print('unknown command')
                end
            else
                print('Too few arguments')
            end
        end
    end)
end