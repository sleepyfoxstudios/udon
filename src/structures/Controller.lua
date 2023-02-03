--[=[
    @class Controller

    A class that handles all of the game logic within a game, and contains it into an easy to use structure that runs based off events.
]=]
local Controller = {}
Controller.__index = Controller


type ControllerOptions = {}

--[=[
    Creates a new Controller.

    @param name string -- A name for this controller.
    @param options ControllerOptions? -- Options to use for this controller.
]=]
function Controller.new(name: string, options: ControllerOptions?)
    local controller = setmetatable({}, Controller)

    -- Handle constructor logic here.
    Controller.IsController = true
    Controller.Name = name

    return controller
end

--[=[
    A function that gets ran on the execution of this controller.
]=]
function Controller:OnExecute()
    return
end

return Controller