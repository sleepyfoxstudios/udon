-- ROBLOX Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--[[
    Internally handles all of the globals used by Udon across the entire game.
       
    @param udon udon -- The base class used by Udon.
    @param Instance udonScript -- The ModuleScript instance of Udon managed by Roblox.
    @private
]]
return function(udon, udonScript)
    -- Handle the server & client sided functions.
    local handleServerFunctions = require(udonScript.prep.ServerFunctions)
    local handleClientFunctions = require(udonScript.prep.ClientFunctions)

    if udon.IsServer == true then
        -- Handle the server functions.
        handleServerFunctions(udon)

        -- Setup server redistributables.
        if ReplicatedStorage:FindFirstChild("UdonRedist") == nil then
            local redist = Instance.new("Folder")
            redist.Name = "UdonRedist"

            -- Parent the redistributable folder to ReplicatedStorage.
            redist.Parent = ReplicatedStorage
        end

        local ServerStorage = game:GetService("ServerStorage")

        if ServerStorage:FindFirstChild("UdonServerRedist") == nil then
            local redist = Instance.new("Folder")

            -- Parent the server's redistributable folder to ServerStorage.
            redist.Parent = ServerStorage
        end
    else 
        handleClientFunctions(udon)
        
        -- Setup client redistributables.
        if ReplicatedStorage:FindFirstChild("UdonRedist") == nil then
            local redist = Instance.new("Folder")
            redist.Name = "UdonRedist"

            -- Parent the redistributable folder to ReplicatedStorage.
            redist.Parent = ReplicatedStorage
        end

    end
end