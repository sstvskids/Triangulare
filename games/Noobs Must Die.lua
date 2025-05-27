local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
  Title = "Triangulare | Noobs Must Die",
  Icon = "triangle",
  Author = "by Moligrafi",
  Folder = "Triangulare",
  Size = UDim2.fromOffset(580, 460),
  Transparent = true,
  Theme = "Dark",
  User = {
    Enabled = true
  },
  SideBarWidth = 200,
  HasOutline = true,
})
Window:EditOpenButton({
  Title = "Triangulare",
  Icon = "triangle",
  CornerRadius = UDim.new(0,16),
  StrokeThickness = 2,
  Color = ColorSequence.new(Color3.fromRGB(0, 255, 120), Color3.fromRGB(0, 120, 255)),
  Draggable = true
})

-- Global Values
getgenv().AutoKill = false
getgenv().AutoRevive = false
getgenv().KillAura = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Distance = 30,
  Selected = "Armor",
  Fighter = "Telamon",
  Times = 1
}

-- Functios
local function GetItem()
  for i = 1, Settings.Times do
    game:GetService("ReplicatedStorage").PlrMan.Items.PickupItem:FireServer(Settings.Selected)
    task.wait(0.1)
  end
end
local function ReturnListOf(what)
  local Names = {}
  
  if what == "Items" then
    for _, item in pairs(game:GetService("ReplicatedStorage").PlrMan.Items:GetChildren()) do
      if item:IsA("Part") then
        table.insert(Names, item.Name)
      end
    end
  elseif what == "Characters" then
    for _, fighter in pairs(game:GetService("ReplicatedStorage").Fighters:GetChildren()) do
      table.insert(Names, fighter.Name)
    end
  end
  
  return Names
end
local function KillAll()
  for _, enemy in pairs(workspace.Enemies:GetChildren()) do
    game:GetService("ReplicatedStorage").HurtEnemy:FireServer(enemy, math.huge)
  end
end
local function AutoKill()
  while getgenv().AutoKill and task.wait(1) do
    KillAll()
  end
end
local function KillAura()
  local function GetNearby()
    local Detected = {}
    for _, enemy in pairs(workspace:GetPartBoundsInBox(eu.Character.HumanoidRootPart.CFrame, Vector3.new(Settings.Distance, 20, Settings.Distance), nil)) do
      local model = enemy:FindFirstAncestorWhichIsA("Model")
      if model:IsDescendantOf(workspace.Enemies) then
        table.insert(Detected, model)
      end
    end
    return Detected
  end
  while getgenv().KillAura and task.wait(0.1) do
    pcall(function()
      for _, enemy in pairs(GetNearby()) do
        game:GetService("ReplicatedStorage").HurtEnemy:FireServer(enemy, math.huge)
      end
    end)
  end
end
local function AutoRevive()
  while getgenv().AutoRevive and task.wait(1) do
    if not eu.Character:GetAttribute("Connected") then
      eu.Character:SetAttribute("Connected", true)
      eu.Character:GetAttributeChangedSignal("Downed"):Connect(function()
        if getgenv().AutoRevive and eu.Character:GetAttribute("Downed") then
          eu.PlayerGui.ScreenUI.StartGame:FireServer()
        end
      end)
    end
  end
end

-- Tabs
local Tabs = {
  Settings = {
    Report = true,
    Credits = true
  },
  BlatantTab = Window:Tab({ Title = "Blatant", Icon = "swords"}),
  ItemsTab = Window:Tab({ Title = "Items", Icon = "box"}),
  FightersTab = Window:Tab({ Title = "Fighters", Icon = "person-standing"}),
  GodsTab = Window:Tab({ Title = "Invencibility", Icon = "sparkles"}),
  divider1 = Window:Divider()
}
Window:SelectTab(1)

-- Blatant
Tabs.BlatantTab:Section({ Title = "Detectable" })
Tabs.BlatantTab:Button({
  Title = "Kill All Noobs",
  Desc = "Instantly kills every noob alive.",
  Callback = function()
    KillAll()
  end
})
Tabs.BlatantTab:Toggle({
  Title = "Auto Kill All",
  Desc = "Auto kills noobs.",
  Value = false,
  Callback = function(state)
    getgenv().AutoKill = state
    AutoKill()
  end
})
Tabs.BlatantTab:Section({ Title = "Helpful" })
Tabs.BlatantTab:Toggle({
  Title = "Kill Aura",
  Desc = "Kill all closer noobs.",
  Value = false,
  Callback = function(state)
    getgenv().KillAura = state
    KillAura()
  end
})
Tabs.BlatantTab:Input({
  Title = "Aura Distance",
  Value = tostring(Settings.Distance / 2),
  Placeholder = "Numbers only, ex.: 15",
  Callback = function(input)
    Settings.Distance = (tonumber(input) * 2) or 1
  end
})

-- Items
Tabs.ItemsTab:Section({ Title = "Selected" })
Tabs.ItemsTab:Dropdown({
  Title = "Selected Item",
  Values = ReturnListOf("Items"),
  Value = Settings.Selected,
  Callback = function(option)
    Settings.Selected = option
  end
})
Tabs.ItemsTab:Section({ Title = "Amount" })
Tabs.ItemsTab:Input({
  Title = "Amount to Get",
  Value = tostring(Settings.Times),
  Placeholder = "Numbers only, ex.: 15",
  Callback = function(input)
    Settings.Times = tonumber(input) or 1
  end
})
Tabs.ItemsTab:Section({ Title = "Get" })
Tabs.ItemsTab:Button({
  Title = "Get Selected Item",
  Desc = "Gives you the amount selected of the selected item.",
  Callback = function()
    GetItem()
  end
})

-- Fighters
Tabs.FightersTab:Section({ Title = "Selected" })
Tabs.FightersTab:Dropdown({
  Title = "Selected Fighter",
  Values = ReturnListOf("Characters"),
  Value = Settings.Fighter,
  Callback = function(option)
    Settings.Fighter = option
  end
})
Tabs.FightersTab:Section({ Title = "Equip" })
Tabs.FightersTab:Button({
  Title = "Equip Selected Fighter",
  Desc = "Gives you the amount selected of the selected item.",
  Callback = function()
    eu.PlayerGui.ScreenUI.SetActiveFighter:FireServer(Settings.Fighter)
    eu.PlayerGui.ScreenUI.StartGame:FireServer()
  end
})

-- Gods
Tabs.GodsTab:Section({ Title = "Invencibility" })
Tabs.GodsTab:Toggle({
  Title = "Auto Self Revive",
  Desc = "Revive yourself when you die.",
  Value = false,
  Callback = function(state)
    getgenv().AutoRevive = state
    AutoRevive()
  end
})