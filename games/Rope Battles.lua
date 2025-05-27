-- Global Values
getgenv().AutoStruggle = false
getgenv().AutoRope = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Cooldown = 1,
  Selected = "Commom"
}

-- Functions
local function ReturnRopes()
  local Names = {}
  
  for _, rope in pairs(game:GetService("ReplicatedStorage").Resources.Fp:GetChildren()) do
    if rope:IsA("Model") then
      table.insert(Names, rope.Name)
    end
  end
  
  return Names
end
local function RopeAll()
  pcall(function()
    for _, p in pairs(game.Players:GetPlayers()) do
      for _, tool in pairs(eu.Character:GetChildren()) do
        if p ~= eu and tool:IsA("Tool") then
          local args = {
            [1] = eu,
            [2] = {
              ["toolInstance"] = tool,
              ["target"] = p.Character,
              ["ropeInfos"] = {
                ["Thickness"] = 0.03,
                ["WinchForce"] = 800,
                ["Visible"] = true,
                ["WinchResponsiveness"] = 200,
                ["WinchTarget"] = 25,
                ["WinchEnabled"] = true,
                ["WinchSpeed"] = 15,
                ["Color"] = BrickColor.new(1001)
              },
              ["attacker"] = eu.Character,
              ["body"] = p.Character:FindFirstChild("Left Leg")
            }
          }
          game:GetService("ReplicatedStorage").RemoteEvents.OnHitRE:FireServer(unpack(args))
        end
      end
    end
  end)
end
local function AutoRope()
  while getgenv().AutoRope and task.wait(Settings.Cooldown) do
    RopeAll()
  end
end
local function AutoStruggle()
  while getgenv().AutoStruggle and task.wait(1) do
    if not eu.Character:GetAttribute("Connected") then
      eu.Character:SetAttribute("Connected", true)
      eu.Character:GetAttributeChangedSignal("StruggleProgress"):Connect(function()
        if getgenv().AutoStruggle and eu.Character:GetAttribute("StruggleProgress") ~= 0 then
          game:GetService("ReplicatedStorage").RemoteEvents.StruggleRE:FireServer({ event = "Break", activeBreak = false })
        end
      end)
    end
  end
end

-- Tabs
local Tabs = {
  BlatantTab = Window:Tab({ Title = "Blatant", Icon = "swords"}),
  ItemsTab = Window:Tab({ Title = "Items", Icon = "box"})
}
Window:SelectTab(1)

-- Blatant
Tabs.BlatantTab:Section({ Title = "Detectable" })
Tabs.BlatantTab:Button({
  Title = "Lasso Everyone",
  Desc = "Lasso every player alive.",
  Callback = function()
    RopeAll()
  end
})
Tabs.BlatantTab:Toggle({
  Title = "Auto Lasso",
  Desc = "Auto lasso Everyone.",
  Value = false,
  Callback = function(state)
    getgenv().AutoRope = state
    AutoRope()
  end
})
Tabs.BlatantTab:Input({
  Title = "Auto Lasso Cooldown",
  Value = tostring(Settings.Cooldown),
  Placeholder = "Numbers only, ex.: 15",
  Callback = function(input)
    Settings.Cooldown = (tonumber(input)) or 1
  end
})
Tabs.BlatantTab:Section({ Title = "Helpful" })
Tabs.BlatantTab:Toggle({
  Title = "Auto Struggle",
  Desc = "Anti strangulation.",
  Value = false,
  Callback = function(state)
    getgenv().AutoStruggle = state
    AutoStruggle()
  end
})

-- Items
Tabs.ItemsTab:Section({ Title = "Selected" })
Tabs.ItemsTab:Dropdown({
  Title = "Selected Rope",
  Values = ReturnRopes(),
  Value = Settings.Selected,
  Callback = function(option)
    Settings.Selected = option
  end
})
Tabs.ItemsTab:Section({ Title = "Equip" })
Tabs.ItemsTab:Button({
  Title = "Equip Selected Rope",
  Desc = "Equip the selected rope.",
  Callback = function()
    game:GetService("ReplicatedStorage").RemoteFunctions.EquipToolRF:InvokeServer(Settings.Selected)
  end
})