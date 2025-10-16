---@class ProgressBarAnimation
---@field public type "anim" | "Scenario"
---@field public dict? string
---@field public lib? string
---@field public Scenario? string

---@class ProgressBarOptions
---@field public animation ProgressBarAnimation
---@field public FreezePlayer? boolean
---@field public onFinish? function
---@field public onCancel? function

---@param message string
---@param length? number Timeout in milliseconds
---@param Options? ProgressBarOptions
---@return boolean Success
local function Progressbar(message, length, Options)
    Options = Options or {}
    length = length or 3000
    
    local oxOptions = {
        duration = length,
        label = message or "ESX-Framework",
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = Options.FreezePlayer or false,
            move = Options.FreezePlayer or false,
            combat = true,
        }
    }
    
    -- Handle animations
    if Options.animation then
        if Options.animation.type == "anim" then
            oxOptions.anim = {
                dict = Options.animation.dict,
                clip = Options.animation.lib
            }
        elseif Options.animation.type == "Scenario" and Options.animation.Scenario then
            oxOptions.anim = {
                scenario = Options.animation.Scenario
            }
        end
    end
    
    local success = lib.progressBar(oxOptions)
    
    if success and Options.onFinish then
        Options.onFinish()
    elseif not success and Options.onCancel then
        Options.onCancel()
    end
    
    return success == true
end

local function CancelProgressbar()
    lib.cancelProgress()
end

exports("Progressbar", Progressbar)
exports("CancelProgressbar", CancelProgressbar)
