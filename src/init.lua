--[=[
    @class Udon

    This is a purely static class that handles everything within the Udon framework. All functions that can be used respectively on the server or client sides are left to their respective classes, while everything that is interchangably used between both is left here.
]=]
local Udon = {
    IsServer = false;
    IsClient = false;
    Controllers = {};
}

-- ROBLOX SERVICES
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Check whether the entity referencing this script is the server, or a client.
if RunService:IsServer() then
    Udon.IsServer = true
else
    Udon.IsClient = true
end

--[=[
    Attempts to import a ModuleScript using a valid identifier. 
    
    If this function is ran by the server, it will check `ServerStorage` first. Otherwise, it will check `ReplicatedStorage`. In order from first to last, it will check these locations for the module:
    * ServerStorage (if ran by the server);
    * ReplicatedStorage;
    * the Packages folder created by Rojo/Wally if it exists;
    * and the children of the Udon script's folders.

    ```lua
        -- Ran over the server, so it will check ServerStorage.
        local ExampleController = Udon.Import("ExampleController")

        -- Register all of our controllers.
        Udon.RegisterControllers({
            ExampleController
        })
    ```

    @param identifier string -- The identifier to use.
    @param folder [Instance?] -- An optional instance with children to check in place of the current rotation of folders checked.
    @return table
]=]
function Udon.Import(identifier: string, folder: Instance)
    -- Set a specific folder if one is not provided.
    if folder == nil or not folder:IsA("Folder") then
        if Udon.IsServer == true then
            folder = game:GetService("ServerStorage")
        else
            folder = ReplicatedStorage
        end
    end

    -- Check the folder to see if it contains the item being sought for.
    local values = string.split(identifier, "/")
    local found = false
    local module = nil

    for index = 1, #values do
        module = (module or folder):FindFirstChild(values[index])

        if module == nil then
            break
        end

        -- Folder found, continue going.
        if index ~= #values then
            continue
        else
            -- Module found.
            found = true
        end
    end

    if found == false then
        -- Chech what we're searching.
        if folder.Name == "ServerStorage" then
            return Udon.Import(identifier, ReplicatedStorage)
        elseif folder.Name == "ReplicatedStorage" then
            -- Check whether the Packages folder exists.
            local packagesFolder = ReplicatedStorage:FindFirstChild("Packages")
            if packagesFolder ~= nil and packagesFolder:IsA("Folder") then
                -- Check the packages folder.
                return Udon.Import(identifier, packagesFolder)
            else
                -- Go straight to the children of this folder.
                for _, scriptFolder in pairs(script:GetChildren()) do
                    if scriptFolder.Name == "prep" then
                        -- Skip the prep folder.
                        continue
                    end

                    module = Udon.Import(identifier, scriptFolder)

                    if module == nil then
                        continue
                    else
                        -- We found our module.
                        break
                    end
                end
            end
        end
    end

    if module == nil then
        return nil
    end

    -- Finally return the module.
    if module:IsA("ModuleScript") then
        return require(module)
    else
        return module
    end
end

-- CONTROLLER FUNCTIONS
--[=[
    Adds a set of controllers to this Udon instance.

    @param controllers {Controller} -- An array full of controllers.
]=]
function Udon.RegisterControllers(controllers)

end

return Udon