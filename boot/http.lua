http.request("http://127.0.0.1:3000/files")

local requesting = true

while requesting do
    local event, url, sourceText = os.pullEvent()

    if event == "http_success" then
        local res = sourceText.readAll()
        sourceText.close()

        -- Get the file tag
        local wildPattern = "<file name=%[(.-)%]>(.-)</file>"
        local fileTag = string.match(res, wildPattern)

        for fileName, fileContent in string.gmatch(res, wildPattern) do
            print("Updating: " .. fileName);
            -- Write to file
            local file = io.open(fileName, "w")
            file:write(fileContent)
            file:close()
        end

        print("Updated files from the server")

        requesting = false
    elseif event == "http_failure" then
        print("Server didn't respond.")

        requesting = false
    end
end