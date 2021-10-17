-- see if the file exists
function file_exists(file)
    local f = io.open(file, "rb")
    if f then
        f:close()
    else
        print("Failed to open file")
    end
    return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
    if not file_exists(file) then return {} end
    lines = {}
    for line in io.lines(file) do lines[#lines + 1] = line end
    return lines
end

-- tests the functions above
local file = 'items.txt'
local itemsToDitch = lines_from(file)

function attack()
    turtle.attack()
    turtle.attackUp()
    turtle.attackDown()
end

function suck()
    turtle.suck()
    turtle.suckUp()
end

local function contains(table, val)
    for i = 1, #table do
        if string.find(val, table[i]) then

            -- if table[i] == val then 
            return true
        end
    end
    return false
end

function sort()
    local item = turtle.getItemDetail()

    if item ~= null then
        local name = item.name

        name = name:gsub("antiqueatlas:", "")
        name = name:gsub("minecraft:", "")
        name = name:gsub("necromancy:", "")
        name = name:gsub("terrafirmacraft:item.", "")
        name = name:gsub("terrafirmacraft:", "")
        name = name:gsub("_", " ")

        local time = os.time()
        local formattedTime = textutils.formatTime(time, true)

        -- Check if an item was found, it would crash otherwise ._.
        if contains(itemsToDitch, item.name) then
            print("[" .. formattedTime .. "]: " .. "Voiding: " .. item.count ..
                      " of " .. name:lower())
            turtle.dropDown()
        else
            turtle.turnLeft()
            turtle.drop()
            turtle.turnRight()
        end
    end

end

while true do
    attack()
    suck()
    attack()
    itemsToDitch = lines_from(file)
    for i = 1, 16 do
        attack()
        turtle.select(i)
        sort()
    end
end
