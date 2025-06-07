-- Global Values
getgenv().AutoCollect = false
getgenv().AutoBuy = false

-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Functions
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(1) do
    pcall(function()
      if workspace.Map.Tycoons[eu.Name]:FindFirstChild("T_Collect_Zone") then
        firetouchinterest(eu.Character.HumanoidRootPart, workspace.Map.Tycoons[eu.Name].T_Collect_Zone.CollectZone, 0)
        firetouchinterest(eu.Character.HumanoidRootPart, workspace.Map.Tycoons[eu.Name].T_Collect_Zone.CollectZone, 1)
      elseif workspace.Map.Tycoons[eu.Name]:FindFirstChild("TycoonTemplate") and workspace.Map.Tycoons[eu.Name].TycoonTemplate:FindFirstChild("T_Collect_Zone") then
        firetouchinterest(eu.Character.HumanoidRootPart, workspace.Map.Tycoons[eu.Name].TycoonTemplate.T_Collect_Zone.CollectZone, 0)
        firetouchinterest(eu.Character.HumanoidRootPart, workspace.Map.Tycoons[eu.Name].TycoonTemplate.T_Collect_Zone.CollectZone, 1)
      end
    end)
  end
end
local function AutoBuy()
  while getgenv().AutoBuy and task.wait(1) do
    pcall(function()
      for _, button in pairs(workspace.Map.Tycoons[eu.Name]:GetChildren()) do
        pcall(function()
          if button:IsA("Model") and button:GetAttribute("UnlockCost") and button:GetAttribute("UnlockCost") <= eu.PlayerData.Mana.Value then
            firetouchinterest(eu.Character.HumanoidRootPart, button.Button_Base, 0)
            firetouchinterest(eu.Character.HumanoidRootPart, button.Button_Base, 1)
            task.wait(0.1)
          end
        end)
      end
    end)
  end
end

--[[
workspace.Map.Tycoons.HallowHub.T_Collect_Zone.CollectZone.TouchInterest
game:GetService("Players").LocalPlayer.PlayerData.Mana
workspace.Map.Tycoons.HallowHub.F1_Wall_1_Button UnlockCost
workspace.Map.Tycoons.HallowHub.F1_Wall_1_Button.Button_Base.TouchInterest
--]]

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"}),
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Hellpful" })
Tabs.Menu:Toggle({
  Title = "Auto Collect Mana",
  Desc = "Automatically collect mana.",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state
    AutoCollect()
  end
})
Tabs.Menu:Toggle({
  Title = "Auto Upgrade",
  Desc = "Automatically buy buttons.",
  Value = false,
  Callback = function(state)
    getgenv().AutoBuy = state
    AutoBuy()
  end
})