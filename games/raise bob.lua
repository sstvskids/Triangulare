-- Global Values
getgenv().AutoClick = false
getgenv().AutoCollect = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Bombs = {}
}
task.spawn(function()
  while task.wait(1) do
    pcall(function()
      for _, bomb in pairs(workspace.Utilities.Bombs:GetChildren()) do
        pcall(function()
          if not table.find(Settings.Bombs, bomb) and bomb:FindFirstChild("Model") and bomb.Model:FindFirstChild("Head") then
            table.insert(Settings.Bombs, bomb)
          end
        end)
      end
    end)
  end
end)

-- Functions
local function AutoClick()
  while getgenv().AutoClick and task.wait(0.05) do
    pcall(function()
      for _, bomb in pairs(Settings.Bombs) do
        pcall(function()
          game:GetService("ReplicatedStorage").Remotes.Bomb_Click:FireServer(bomb.Name)
        end)
      end
    end)
  end
end
local function AutoCollect()
  for _, cash in pairs(workspace.Utilities.Cash:GetChildren()) do
    pcall(function()
      firetouchinterest(eu.Character.HumanoidRootPart, cash, 0)
      firetouchinterest(eu.Character.HumanoidRootPart, cash, 1)
    end)
  end
  if not workspace.Utilities.Cash:GetAttribute("Connected") then
    workspace.Utilities.Cash:SetAttribute("Connected", true)
    workspace.Utilities.Cash.ChildAdded:Connect(function(instance)
      if not getgenv().AutoCollect then return end
      firetouchinterest(eu.Character.HumanoidRootPart, instance, 0)
      firetouchinterest(eu.Character.HumanoidRootPart, instance, 1)
    end)
  end
end

--[[
workspace.Utilities.Cash.Cash.TouchInterest
workspace.Utilities.Poop["5375b4bf-ad20-472c-80d2-7013c76bca87"].ProximityPrompt
workspace.Utilities.Bombs["57cf708d-6d47-4b6e-bfad-cd31ee60f057"].Model.Head.Pet
--]]

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Auto Farm", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Helpful" })
Tabs.Menu:Toggle({
  Title = "Auto Click",
  Desc = "Click Click",
  Value = false,
  Callback = function(state)
    getgenv().AutoClick = state
    if getgenv().AutoClick then pcall(AutoClick) end
  end
})
Tabs.Menu:Toggle({
  Title = "Auto Collect Cash",
  Desc = "Automatically collect cash.",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state
    if getgenv().AutoCollect then pcall(AutoCollect) end
  end
})