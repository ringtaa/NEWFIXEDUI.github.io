local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function gradient(text, startColor, endColor)
    local result = ""
    local length = #text

    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)

        local char = text:sub(i, i)
        result = result .. "<font color=\"rgb(" .. r ..", " .. g .. ", " .. b .. ")\">" .. char .. "</font>"
    end

    return result
end

local Confirmed = false

WindUI:Popup({
    Title = "Hi!",
    Icon = "info",
    Content = "This script made by " .. gradient("SnowTTeam", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    Buttons = {
        {
            Title = "Cancel",
            --Icon = "",
            Callback = function() end,
            Variant = "Tertiary", -- Primary, Secondary, Tertiary
        },
        {
            Title = "Continue",
            Icon = "arrow-right",
            Callback = function() Confirmed = true end,
            Variant = "Primary", -- Primary, Secondary, Tertiary
        }
    }
})

repeat task.wait() until Confirmed

WindUI:Notify({
    Title = "test",
    Content = "Скрипт успешно загружен!",
    Icon = "check-circle",
    Duration = 3,
})

local Window = WindUI:CreateWindow({
    Title = "SNT HUB | Dead Rails",
    Icon = "infinity",
    Author = "SnOwT",
    Folder = "WindUI",
    Size = UDim2.fromOffset(500, 300),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    UserEnabled = true,
    HasOutline = true,
})

Window:EditOpenButton({
    Title = "Открыть UI",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 4),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("1E213D"),
        Color3.fromHex("1F75FE")
    ),
    Draggable = true,
})

local Tabs = {
    CharacterTab = Window:Tab({ Title = "Character", Icon = "file-cog" }),
    AutofarmTab = Window:Tab({
        Title = "Autofarm", Icon = "rub" }),
    CollectTab = Window:Tab({
        Title = "Collect", Icon = "sword", }),
    TrainTab = Window:Tab({
        Title = "Train", Icon = "train", }),
    EspTab = Window:Tab({ Title = "ESP", Icon = "eye" }),
    AimbotTab = Window:Tab({ Title = "Aimbot", Icon = "axe" }),
    TeleportTab = Window:Tab({ Title = "Teleport", Icon = "user" }),
    be = Window:Divider(),
    SettingsTab = Window:Tab({ Title = "Settings", Icon = "code" }),
    ChangelogsTab = Window:Tab({ Title = "Changelogs", Icon = "info", }),
    SocialsTab = Window:Tab({ Title = "Socials", Icon = "star"}),
    b = Window:Divider(),
    WindowTab = Window:Tab({ Title = "Window and File Configuration", Icon = "settings", Desc = "Manage window settings and file configurations." }),
    CreateThemeTab = Window:Tab({ Title = "Create Theme", Icon = "palette", Desc = "Design and apply custom themes." }),
}



--[[ НАСТРОЙКИ ПЕРСОНАЖА ]]--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local CharacterSettings = {
    WalkSpeed = {Value = 16, Default = 16, Locked = false},
    JumpPower = {Value = 50, Default = 50, Locked = false}
}

local function updateCharacter()
    local character = LocalPlayer.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if not CharacterSettings.WalkSpeed.Locked then
            humanoid.WalkSpeed = CharacterSettings.WalkSpeed.Value
        end
        if not CharacterSettings.JumpPower.Locked then
            humanoid.JumpPower = CharacterSettings.JumpPower.Value
        end
    end
end

Tabs.CharacterTab:Slider({
    Title = "Walkspeed",
    Value = {Min = 0, Max = 200, Default = 16},
    Callback = function(value)
        CharacterSettings.WalkSpeed.Value = value
        updateCharacter()
    end
})

Tabs.CharacterTab:Button({
    Title = "Reset walkspeed",
    Callback = function()
        CharacterSettings.WalkSpeed.Value = CharacterSettings.WalkSpeed.Default
        updateCharacter()
    end
})

Tabs.CharacterTab:Toggle({
    Title = "Block walkspeed",
    Default = false,
    Callback = function(state)
        CharacterSettings.WalkSpeed.Locked = state
        updateCharacter()
    end
})

Tabs.CharacterTab:Slider({
    Title = "Jumppower",
    Value = {Min = 0, Max = 200, Default = 50},
    Callback = function(value)
        CharacterSettings.JumpPower.Value = value
        updateCharacter()
    end
})


Tabs.CharacterTab:Button({
    Title = "Reset jumppower",
    Callback = function()
        CharacterSettings.JumpPower.Value = CharacterSettings.JumpPower.Default
        updateCharacter()
    end
})

Tabs.CharacterTab:Toggle({
    Title = "Block jumppower",
    Default = false,
    Callback = function(state)
        CharacterSettings.JumpPower.Locked = state
        updateCharacter()
    end
})

Tabs.CharacterTab:Toggle({
    Title = "Infinite stamina",
    Default = false,
    Callback = function(Value)
        InfiniteStamina = Value
end,
})

-- Items
local function GetItemNames()
    local items = {}
    local runtimeItems = workspace:FindFirstChild("RuntimeItems")
    if runtimeItems then
        for _, item in ipairs(runtimeItems:GetDescendants()) do
            if item:IsA("Model") then
                table.insert(items, item.Name)
            end
        end
    else
        warn("RuntimeItems folder not found!")
    end
    return items
end

local Dropdown = Tabs.CollectTab:Dropdown({
    Title = "Item",
    Values = GetItemNames(),
    Value = "Select item name",
    Multi = false,
    Callback = function(selectedItem)
       if type(selectedItem) == "table" then
           selectedItem = selectedItem[1] 
       end
   end,
})

Tabs.CollectTab:Button({
    Title = "Refresh item list",
    Callback = function()
      Dropdown:Refresh(GetItemNames())
    end,
})

Tabs.CollectTab:Button({
    Title = "Collect selected",
    Callback = function()local selectedItemName = Dropdown.CurrentOption
       if type(selectedItemName) == "table" then
           selectedItemName = selectedItemName[1] 
       end

       if selectedItemName == "Select an item" then
           warn("No item selected!")
           return
       end

       local runtimeItems = workspace:FindFirstChild("RuntimeItems")
       if not runtimeItems then
           warn("RuntimeItems folder not found!")
           return
       end

       local selectedItem
       for _, item in ipairs(runtimeItems:GetDescendants()) do
           if item:IsA("Model") and item.Name == selectedItemName then
               selectedItem = item
               break
           end
       end

       if not selectedItem then
           warn("Item not found in RuntimeItems:", selectedItemName)
           return
       end

       local Players = game:GetService("Players")
       local LocalPlayer = Players.LocalPlayer
       if not LocalPlayer then
           warn("LocalPlayer not found!")
           return
       end

       local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
       local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

       if not selectedItem.PrimaryPart then
           warn(selectedItem.Name .. " has no PrimaryPart and cannot be moved.")
           return
       end

       selectedItem:SetPrimaryPartCFrame(HumanoidRootPart.CFrame + Vector3.new(0, 1, 0))
       print("Collected:", selectedItem.Name)
   end,
})

Tabs.CollectTab:Button({
    Title = "Collect all items",
    Callback = function()
        local runtimeItems = workspace:FindFirstChild("RuntimeItems")
       if not runtimeItems then
           warn("RuntimeItems folder not found!")
           return
       end

       local ps = game:GetService("Players").LocalPlayer
       local ch = ps.Character or ps.CharacterAdded:Wait()
       local HumanoidRootPart = ch:WaitForChild("HumanoidRootPart")

       for _, item in ipairs(runtimeItems:GetDescendants()) do
           if item:IsA("Model") then
               if item.PrimaryPart then
                   local offset = HumanoidRootPart.CFrame.LookVector * 5
                   item:SetPrimaryPartCFrame(HumanoidRootPart.CFrame + offset)
               else
                   warn(item.Name .. " has no PrimaryPart .")
               end
           end
       end 
   end,
})

-- [[ ESP MOBS & ITEMS ]] --

local ESPHandles = {}
local ESPEnabled = false

local function CreateESP(object, color)
    if not object or not object.PrimaryPart then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = object
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.Parent = object

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Adornee = object.PrimaryPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = object

    local textLabel = Instance.new("TextLabel")
    textLabel.Text = object.Name
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.TextColor3 = color
    textLabel.BackgroundTransparency = 1
    textLabel.TextSize = 7
    textLabel.Parent = billboard

    ESPHandles[object] = {Highlight = highlight, Billboard = billboard}
end

local function ClearESP()
    for obj, handles in pairs(ESPHandles) do
        if handles.Highlight then handles.Highlight:Destroy() end
        if handles.Billboard then handles.Billboard:Destroy() end
    end
    ESPHandles = {}
end

local function UpdateESP()
    ClearESP()

    -- ESP for Items 
    local runtimeItems = workspace:FindFirstChild("RuntimeItems")
    if runtimeItems then
        for _, item in ipairs(runtimeItems:GetDescendants()) do
            if item:IsA("Model") then
                CreateESP(item, Color3.new(1, 0, 0)) 
            end
        end
    end

    -- ESP mobs
    local baseplates = workspace:FindFirstChild("Baseplates")
    if baseplates and #baseplates:GetChildren() >= 2 then
        local secondBaseplate = baseplates:GetChildren()[2]
        local centerBaseplate = secondBaseplate and secondBaseplate:FindFirstChild("CenterBaseplate")
        local animals = centerBaseplate and centerBaseplate:FindFirstChild("Animals")
        if animals then
            for _, animal in ipairs(animals:GetDescendants()) do
                if animal:IsA("Model") then
                    CreateESP(animal, Color3.new(1, 0, 1)) -- Purple for Animals
                end
            end
        end
    end
    
    local nightEnemies = workspace:FindFirstChild("NightEnemies")
    if nightEnemies then
        for _, enemy in ipairs(nightEnemies:GetDescendants()) do
            if enemy:IsA("Model") then
                CreateESP(enemy, Color3.new(0, 0, 1)) -- Blue for Night Enemies
            end
        end
    end

    local destroyedHouse = workspace:FindFirstChild("RandomBuildings") and workspace.RandomBuildings:FindFirstChild("DestroyedHouse")
    local zombiePart = destroyedHouse and destroyedHouse:FindFirstChild("StandaloneZombiePart")
    local zombies = zombiePart and zombiePart:FindFirstChild("Zombies")
    if zombies then
        for _, zombie in ipairs(zombies:GetChildren()) do
            if zombie:IsA("Model") then
                CreateESP(zombie, Color3.new(0, 1, 0)) -- Green for Zombies
            end
        end
    end
end

local function AutoUpdateESP()
    while ESPEnabled do
        UpdateESP()
        wait() 
    end
end

Tabs.EspTab:Toggle({
    Title = "Enable Mobs&Items ESP",
    Default = ESPSettings.Mobs.Enabled,
   Callback = function(Value)
        ESPEnabled = Value
        if Value then
            UpdateESP()
            coroutine.wrap(AutoUpdateESP)()
        else
            ClearESP()
        end
    end
})

-- Aimbot --

Tabs.AimbotTab:Section({
    Title = "Aimlock",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Aimlock = {
    Enabled = false,
    Target = nil,
    Hitpart = "Head",
    Prediction = 0.14,
    Smoothing = 0.1,
    FOV = 60
}

local SilentAim = {
    Enabled = false,
    HitChance = 100,
    Hitpart = "Head"
}

local ShowFOVCircle = false
local FOVCircle = nil

Tabs.AimbotTab:Toggle({
    Title = "Aimlock",
    Default = false,
    Callback = function(Value)
        Aimlock.Enabled = Value
        if Value then
            RunAimlock()
        end
end,
})

Tabs.AimbotTab:Dropdown({
    Title = "Part to hit",
    Values = {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso"},
    Value = "Head",
    Callback = function(Option)
    Aimlock.Hitpart = Option
end,
})

Tabs.AimbotTab:Slider({
    Title = "Prediction",
    Step = 0.01,
    Value = {Min = 0, 
             Max = 0.5, 
             Default = 0.14},
    Callback = function(Value)
        Aimlock.Prediction = Value
end,
})

Tabs.AimbotTab:Slider({
    Title = "Smoothing",
    Step = 0.01,
    Value = {Min = 0, 
             Max = 1, 
             Default = 0.1},
    Callback = function(Value)
        Aimlock.Smoothing = Value
end,
})

Tabs.AimbotTab:Slider({
    Title = "FOV Range",
    Value = {Min = 0, Max = 360, Default = 60},
    Callback = function(Value)
        Aimlock.FOV = Value
        if FOVCircle then
            FOVCircle.Radius = Aimlock.FOV
        end
end,
})

Tabs.AimbotTab:Section({
    Title = "Silent AIM",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tabs.AimbotTab:Toggle({
    Title = "Silent Aim",
    Default = false,
    Callback = function(Value)
        SilentAim.Enabled = Value
end,
})

Tabs.AimbotTab:Dropdown({
    Title = "Part to aim",
    Values = {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso"},
    Value = "Head",
    Callback = function(Option)
    SilentAim.Hitpart = Option
end,
})

Tabs.AimbotTab:Slider({
    Title = "Hit chance",
    Step = 1,
    Value = {Min = 0,
             Max = 100,
             Default = 100},
    Callback = function(Value)
        SilentAim.HitChance = Value
    end,
})

Tabs.AimbotTab:Toggle({
    Title = "Fov Circle",
    Default = false,
    Callback = function(state)
        ShowFOVCircle = state
        if state then
            CreateFOVCircle()
        else
            if FOVCircle then
                FOVCircle:Destroy()
                FOVCircle = nil
            end
        end
    end,
})

-- Train --

Tabs.TrainTab:Slider({
    Title = "Train speed",
    Step = 0.1,
    Value = {
        Min = 1,
        Max = 10,
        Default = 1,
    },
    Callback = function(Value)
         for _, train in pairs(workspace:FindFirstChild("Trains"):GetChildren()) do
            if train:FindFirstChild("Configuration") and train.Configuration:FindFirstChild("Speed") then
                train.Configuration.Speed.Value = Value * 10
            end
        end
    end,
})

Tabs.TrainTab:Button({
    Title = "Instant Brake",
    Callback = function()
        for _, train in pairs(workspace:FindFirstChild("Trains"):GetChildren()) do
            if train:FindFirstChild("Configuration") and train.Configuration:FindFirstChild("Speed") then
                train.Configuration.Speed.Value = 0
            end
        end
    end,
})

-- Teleport --

local Locations = {
    "Spawn Point",
    "Train Station",
    "Power Plant",
    "Mine Entrance",
    "Tunnel Center"
}

Tabs.TeleportTab:Dropdown({
    Title = "Select Location",
    Values = Locations,
    Value = "Spawn Point",
    Multi = false,
    AllowNone = true,
    Callback = function(option)
        local char = game.Players.LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if option == "Spawn Point" then
                    hrp.CFrame = game:GetService("Workspace").SpawnLocation.CFrame
                elseif option == "Train Station" then
                    hrp.CFrame = CFrame.new(100, 50, -200)
                end
            end
        end
    end,
})

function RunAimlock()
    coroutine.wrap(function()
        while Aimlock.Enabled do
            wait()
            
            local closestPlayer, closestDistance = FindClosestPlayer()
            
            if closestPlayer and closestDistance <= Aimlock.FOV then
                Aimlock.Target = closestPlayer
                local targetPart = closestPlayer.Character:FindFirstChild(Aimlock.Hitpart)
                if targetPart then
                    local predictedPosition = targetPart.Position + (targetPart.Velocity * Aimlock.Prediction)
                    local camera = workspace.CurrentCamera
                    local smoothedPosition = camera.CFrame.Position:Lerp(predictedPosition, Aimlock.Smoothing)
                    
                    camera.CFrame = CFrame.new(camera.CFrame.Position, smoothedPosition)
                end
            else
                Aimlock.Target = nil
            end
        end
    end)()
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if SilentAim.Enabled and method == "FindPartOnRayWithIgnoreList" and math.random(1, 100) <= SilentAim.HitChance then
        local closestPlayer = FindClosestPlayer()
        if closestPlayer then
            local targetPart = closestPlayer.Character:FindFirstChild(SilentAim.Hitpart)
            if targetPart then
                args[1] = Ray.new(args[1].Origin, (targetPart.Position - args[1].Origin).Unit * 1000)
                return oldNamecall(self, unpack(args))
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

function FindClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    local localPlayer = game.Players.LocalPlayer
    local localCharacter = localPlayer.Character
    local localPosition = localCharacter and localCharacter:FindFirstChild("Head") and localCharacter.Head.Position
    
    if localPosition then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local distance = (player.Character.Head.Position - localPosition).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer, closestDistance
end

function CreateFOVCircle()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = true
    FOVCircle.Transparency = 1
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Thickness = 1
    FOVCircle.Filled = false
    FOVCircle.Radius = Aimlock.FOV
    FOVCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
    
    game:GetService("RunService").RenderStepped:Connect(function()
        FOVCircle.Radius = Aimlock.FOV
        FOVCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
    end)
end

game:GetService('RunService').Stepped:Connect(function()
    if Noclip and game.Players.LocalPlayer.Character then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    if InfiniteStamina and game.Players.LocalPlayer.Character:FindFirstChild("Stamina") then
        game.Players.LocalPlayer.Character.Stamina.Value = 100
    end
end)
