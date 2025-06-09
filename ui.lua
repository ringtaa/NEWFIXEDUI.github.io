if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.wait(2) -- Allow game to settle

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

-- Player related variables
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    LocalPlayer = Players.PlayerAdded:Wait()
end

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Load UI Library
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Store Default Values
local DEFAULT_WALKSPEED = 16
local DEFAULT_JUMPPOWER = 50
local DEFAULT_FOV = 70
local DEFAULT_MAX_ZOOM_DISTANCE = LocalPlayer.CameraMaxZoomDistance

if Humanoid and Humanoid.Parent then
    DEFAULT_WALKSPEED = Humanoid.WalkSpeed
    DEFAULT_JUMPPOWER = Humanoid.JumpPower
end
if Workspace.CurrentCamera then
    DEFAULT_FOV = Workspace.CurrentCamera.FieldOfView
end

-- Variables to store current settings
local currentWalkSpeed = DEFAULT_WALKSPEED
local currentJumpPower = DEFAULT_JUMPPOWER
local currentFov = DEFAULT_FOV
local AntiAFKEnabled = false
local InfiniteMaxZoomEnabled = false

-- UI Element References (will be assigned when elements are created)
local AntiAFKToggleElement = nil
local WalkSpeedSliderElement = nil
local JumpPowerSliderElement = nil
local FovSliderElement = nil
local InfiniteMaxZoomToggleElement = nil
local ThemeDropdownElement = nil
local TransparencyToggleElement = nil

-- Window Creation
local Window = WindUI:CreateWindow({
    Title = "cookieys hub",
    Icon = "cookie",
    Author = "XyraV",
    Folder = "cookieys",
    Size = UDim2.fromOffset(40, 40), -- Adjusted size
    Transparent = true, -- Initial transparency state
    Theme = "Dark", -- Initial theme
    SideBarWidth = 180,
    HasOutline = false,
    KeySystem = {
        Key = {
            "1234",
            "5678"
        },
        Note = "The Key is '1234' or '5678'",
        URL = "https://github.com/Footagesus/WindUI",
        SaveKey = true,
    },
})

Window:EditOpenButton({
    Title = "Open UI",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 10),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    Draggable = true,
})

-- Anti AFK Logic
local AntiAFKConnection
local function StartAntiAFK()
    if AntiAFKConnection then
        AntiAFKConnection:Disconnect()
    end
    AntiAFKConnection = RunService.Stepped:Connect(function()
        if AntiAFKEnabled and LocalPlayer and LocalPlayer.Character then
            pcall(VirtualUser.Button2Down, VirtualUser, Enum.UserInputType.MouseButton2)
            task.wait(0.1)
            pcall(VirtualUser.Button2Up, VirtualUser, Enum.UserInputType.MouseButton2)
        end
    end)
end

local function StopAntiAFK()
    if AntiAFKConnection then
        AntiAFKConnection:Disconnect()
        AntiAFKConnection = nil
    end
end

-- Function to safely set humanoid properties
local function SetHumanoidProperty(propName, value)
    local player = Players.LocalPlayer
    if player and player.Character then
        local char = player.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum[propName] = value
            end)
        end
    end
end

-- Function to safely set player properties
local function SetPlayerProperty(propName, value)
    local player = Players.LocalPlayer
    if player then
        pcall(function()
            player[propName] = value
        end)
    end
end

-- Tabs Definition
local Tabs = {
    HomeTab = Window:Tab({
        Title = "Home",
        Icon = "house",
        Desc = "Welcome! Find general information here."
    }),
    MainTab = Window:Tab({
        Title = "Main",
        Icon = "star",
        Desc = "Core features and utilities."
    }),
    PhantomTab = Window:Tab({
        Title = "Phantom",
        Icon = "ghost",
        Desc = "Player modifications and utilities."
    }),
    SettingsTab = Window:Tab({
        Title = "Settings",
        Icon = "settings",
        Desc = "Customize UI appearance and manage configurations."
    })
}
Window:SelectTab(1) -- Select Home tab by default

-- Home Tab Content
Tabs.HomeTab:Button({
    Title = "Discord Invite",
    Desc = "Click to copy the Discord server invite link.",
    Callback = function()
        local discordLink = "https://discord.gg/ee4veXxYFZ"
        if setclipboard then
            local success, err = pcall(setclipboard, discordLink)
            if success then
                WindUI:Notify({
                    Title = "Link Copied!",
                    Content = "Discord invite link copied to clipboard.",
                    Icon = "clipboard-check",
                    Duration = 3
                })
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Failed to copy link: " .. tostring(err),
                    Icon = "alert-triangle",
                    Duration = 5
                })
            end
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Could not copy link (setclipboard unavailable).",
                Icon = "alert-triangle",
                Duration = 5
            })
            warn("setclipboard function not available in this environment.")
        end
    end
})

-- Main Tab Content
local function LoadScriptFromURL(url, scriptName)
    WindUI:Notify({
        Title = "Loading...",
        Content = "Loading " .. scriptName .. ". Please wait.",
        Icon = "loader-circle",
        Duration = 3
    })
    task.spawn(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        if not success then
            WindUI:Notify({
                Title = "Error",
                Content = "Failed to load " .. scriptName .. ": " .. tostring(err),
                Icon = "alert-triangle",
                Duration = 5
            })
            warn(scriptName .. " load error:", err)
        else
            WindUI:Notify({
                Title = "Success",
                Content = scriptName .. " loaded successfully.",
                Icon = "check",
                Duration = 3
            })
        end
    end)
end

Tabs.MainTab:Button({
    Title = "Load Infinite Yield",
    Desc = "Loads the Infinite Yield admin script.",
    Callback = function()
        LoadScriptFromURL("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", "Infinite Yield")
    end
})

Tabs.MainTab:Button({
    Title = "Load Nameless Admin",
    Desc = "Loads the Nameless Admin script.",
    Callback = function()
        LoadScriptFromURL("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua", "Nameless Admin")
    end
})

-- Phantom Tab Content
AntiAFKToggleElement = Tabs.PhantomTab:Toggle({
    Title = "Anti AFK",
    Desc = "Prevents game kick for inactivity.",
    Value = AntiAFKEnabled,
    Callback = function(state)
        AntiAFKEnabled = state
        if AntiAFKEnabled then
            StartAntiAFK()
        else
            StopAntiAFK()
        end
    end
})

WalkSpeedSliderElement = Tabs.PhantomTab:Slider({
    Title = "Walk Speed",
    Desc = "Adjust character movement speed.",
    Value = {
        Min = 0,
        Max = 200,
        Default = DEFAULT_WALKSPEED
    },
    Callback = function(value)
        SetHumanoidProperty("WalkSpeed", value)
        currentWalkSpeed = value
    end
})

JumpPowerSliderElement = Tabs.PhantomTab:Slider({
    Title = "Jump Power",
    Desc = "Adjust character jump height.",
    Value = {
        Min = 0,
        Max = 200,
        Default = DEFAULT_JUMPPOWER
    },
    Callback = function(value)
        SetHumanoidProperty("JumpPower", value)
        currentJumpPower = value
    end
})

FovSliderElement = Tabs.PhantomTab:Slider({
    Title = "FOV Changer",
    Desc = "Adjust camera Field of View.",
    Value = {
        Min = 1,
        Max = 120,
        Default = DEFAULT_FOV
    },
    Callback = function(value)
        if Workspace.CurrentCamera then
            Workspace.CurrentCamera.FieldOfView = value
        end
        currentFov = value
    end
})

InfiniteMaxZoomToggleElement = Tabs.PhantomTab:Toggle({
    Title = "Infinite Max Zoom",
    Desc = "Allows zooming out indefinitely.",
    Value = InfiniteMaxZoomEnabled,
    Callback = function(state)
        InfiniteMaxZoomEnabled = state
        if InfiniteMaxZoomEnabled then
            SetPlayerProperty("CameraMaxZoomDistance", math.huge)
        else
            SetPlayerProperty("CameraMaxZoomDistance", DEFAULT_MAX_ZOOM_DISTANCE)
        end
    end
})

-- Settings Tab Content
Tabs.SettingsTab:Section({
    Title = "UI Appearance"
})

local themeValues = {}
for name, _ in pairs(WindUI:GetThemes()) do
    table.insert(themeValues, name)
end

ThemeDropdownElement = Tabs.SettingsTab:Dropdown({
    Title = "Select Theme",
    Desc = "Change the UI's visual theme.",
    Multi = false,
    AllowNone = false,
    Value = WindUI:GetCurrentTheme(), -- Set initial value
    Values = themeValues,
    Callback = function(theme)
        WindUI:SetTheme(theme)
    end
})

TransparencyToggleElement = Tabs.SettingsTab:Toggle({
    Title = "Window Transparency",
    Desc = "Toggle the window's background transparency.",
    Value = Window.Transparent, -- Use the window's current transparency state
    Callback = function(state)
        Window:ToggleTransparency(state) -- This function should exist in WindUI's Window object
    end
})

Tabs.SettingsTab:Section({
    Title = "Configuration (Example - Not Fully Implemented)"
})
Tabs.SettingsTab:Paragraph({
    Title = "Save/Load Configurations",
    Desc = "Below are placeholders for a configuration system. Full implementation requires file system access (makefolder, writefile, readfile, listfiles) typically provided by the exploit environment."
})

local configFileNameInput = "MySettings"
Tabs.SettingsTab:Input({
    Title = "Config File Name",
    Value = configFileNameInput,
    Placeholder = "Enter config name",
    Callback = function(input)
        configFileNameInput = input
    end
})
Tabs.SettingsTab:Button({
    Title = "Save Current Config (Placeholder)",
    Desc = "Saves current Phantom & UI settings.",
    Callback = function()
        if not configFileNameInput or configFileNameInput == "" then
            WindUI:Notify({
                Title = "Error",
                Content = "Please enter a config file name.",
                Icon = "alert-triangle",
                Duration = 3
            })
            return
        end
        -- Example of what to save. This part needs robust implementation.
        local settingsToSave = {
            walkSpeed = currentWalkSpeed,
            jumpPower = currentJumpPower,
            fov = currentFov,
            antiAFK = AntiAFKEnabled,
            infiniteZoom = InfiniteMaxZoomEnabled,
            theme = WindUI:GetCurrentTheme(),
            transparent = Window.Transparent -- Or WindUI:GetTransparency() if that's more accurate
        }
        -- In a real scenario: SaveFile(configFileNameInput, settingsToSave)
        WindUI:Notify({
            Title = "Save (Placeholder)",
            Content = "Config '" .. configFileNameInput .. "' save function called. Data: " .. HttpService:JSONEncode(settingsToSave),
            Icon = "save",
            Duration = 5
        })
    end
})
Tabs.SettingsTab:Button({
    Title = "Load Config (Placeholder)",
    Desc = "Loads settings from the specified file.",
    Callback = function()
        if not configFileNameInput or configFileNameInput == "" then
            WindUI:Notify({
                Title = "Error",
                Content = "Please enter a config file name to load.",
                Icon = "alert-triangle",
                Duration = 3
            })
            return
        end
        -- In a real scenario: local loadedData = LoadFile(configFileNameInput)
        -- Then apply loadedData to UI elements and internal variables.
        WindUI:Notify({
            Title = "Load (Placeholder)",
            Content = "Config '" .. configFileNameInput .. "' load function called.",
            Icon = "upload-cloud",
            Duration = 3
        })
    end
})


-- Function to reset settings to default and update UI
local function ResetSettingsAndUI()
    -- Phantom Features
    AntiAFKEnabled = false
    if AntiAFKToggleElement and AntiAFKToggleElement.SetValue then
        AntiAFKToggleElement:SetValue(false)
    end
    StopAntiAFK()

    currentWalkSpeed = DEFAULT_WALKSPEED
    SetHumanoidProperty("WalkSpeed", DEFAULT_WALKSPEED)
    if WalkSpeedSliderElement and WalkSpeedSliderElement.SetValue then
        WalkSpeedSliderElement:SetValue(DEFAULT_WALKSPEED)
    end

    currentJumpPower = DEFAULT_JUMPPOWER
    SetHumanoidProperty("JumpPower", DEFAULT_JUMPPOWER)
    if JumpPowerSliderElement and JumpPowerSliderElement.SetValue then
        JumpPowerSliderElement:SetValue(DEFAULT_JUMPPOWER)
    end

    currentFov = DEFAULT_FOV
    if Workspace.CurrentCamera then
        Workspace.CurrentCamera.FieldOfView = DEFAULT_FOV
    end
    if FovSliderElement and FovSliderElement.SetValue then
        FovSliderElement:SetValue(DEFAULT_FOV)
    end

    InfiniteMaxZoomEnabled = false
    SetPlayerProperty("CameraMaxZoomDistance", DEFAULT_MAX_ZOOM_DISTANCE)
    if InfiniteMaxZoomToggleElement and InfiniteMaxZoomToggleElement.SetValue then
        InfiniteMaxZoomToggleElement:SetValue(false)
    end

    -- UI Settings (Theme and Transparency) - Resetting them might depend on desired behavior
    -- For now, let's assume they don't reset with this specific function call,
    -- or if they should, define their defaults and apply them.
    -- Example:
    -- WindUI:SetTheme("Dark") -- Default theme
    -- if ThemeDropdownElement and ThemeDropdownElement.Select then ThemeDropdownElement:Select("Dark") end
    -- Window:ToggleTransparency(true) -- Default transparency
    -- if TransparencyToggleElement and TransparencyToggleElement.SetValue then TransparencyToggleElement:SetValue(true) end
end

game:BindToClose(ResetSettingsAndUI)

local playerRemovingConnection
playerRemovingConnection = LocalPlayer.Destroying:Connect(function()
    ResetSettingsAndUI()
    if playerRemovingConnection then
        playerRemovingConnection:Disconnect()
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid")
    task.wait(0.1)

    -- Re-apply Phantom settings
    SetHumanoidProperty("WalkSpeed", currentWalkSpeed)
    SetHumanoidProperty("JumpPower", currentJumpPower)
    if Workspace.CurrentCamera then
        Workspace.CurrentCamera.FieldOfView = currentFov
    end
    if AntiAFKEnabled then
        StartAntiAFK()
    end
    if InfiniteMaxZoomEnabled then
        SetPlayerProperty("CameraMaxZoomDistance", math.huge)
    else
        SetPlayerProperty("CameraMaxZoomDistance", DEFAULT_MAX_ZOOM_DISTANCE)
    end
end)

task.defer(function()
    -- Initialize Phantom tab UI elements
    if Workspace.CurrentCamera and FovSliderElement and FovSliderElement.SetValue then
        FovSliderElement:SetValue(Workspace.CurrentCamera.FieldOfView)
    end
    if InfiniteMaxZoomToggleElement and InfiniteMaxZoomToggleElement.SetValue then
        InfiniteMaxZoomToggleElement:SetValue(InfiniteMaxZoomEnabled)
    end
    if InfiniteMaxZoomEnabled then
        SetPlayerProperty("CameraMaxZoomDistance", math.huge)
    else
        SetPlayerProperty("CameraMaxZoomDistance", DEFAULT_MAX_ZOOM_DISTANCE)
    end

    -- Initialize Settings tab UI elements
    if ThemeDropdownElement then
        ThemeDropdownElement:Select(WindUI:GetCurrentTheme())
    end
    if TransparencyToggleElement and TransparencyToggleElement.SetValue then
        -- Assuming Window.Transparent reflects the actual state after CreateWindow
        TransparencyToggleElement:SetValue(Window.Transparent)
    end
end)
