-- Global Values
getgenv().AutoCollect = false
getgenv().AutoDeliver = false
getgenv().AutoLock = false
getgenv().AntiLasers = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil
}

-- Load
task.spawn(function()
  while not Settings.Plot and task.wait(1) do
    for _, plot in pairs(workspace.Bases:GetChildren()) do
      if plot:FindFirstChild("Spawn") and plot.Spawn:FindFirstChild("BaseUI") and plot.Spawn.BaseUI.Enabled then
        Settings.Plot = plot
        return
      end
    end
  end
end)

-- Functions
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(1) do
    pcall(function()
      for _, slot in pairs(Settings.Plot.Slots:GetChildren()) do
        pcall(function()
          if slot:FindFirstChild("TouchInterest") then
            firetouchinterest(eu.Character.HumanoidRootPart, slot, 0)
            firetouchinterest(eu.Character.HumanoidRootPart, slot, 1)
          end
        end)
      end
    end)
  end
end
local function AutoLock()
  while getgenv().AutoLock and task.wait(0.39) do
    pcall(function()
      if not Settings.Plot.LockPart.BaseLockUI.Value.Visible then
        firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.LockPart, 0)
        firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.LockPart, 1)
      end
    end)
  end
end

--[[
7790982864/123763291847901
workspace.Bases.Base2.Slots.Collector1.TouchInterest
workspace.Bases.Base2.Spawn.BaseUI.Enabled
Your Base
workspace.Bases.Base2.LockPart.BaseLockUI.Value.Visible == false
workspace.Bases.Base2.Gate:GetChildren()[18].Transparency == 1, 0.3
--]]

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Auto Farm", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Helpful" })
Tabs.Menu:Toggle({
  Title = "Auto Collect",
  Desc = "Automatically collects cash.",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state
    AutoCollect()
  end
})
Tabs.Menu:Toggle({
  Title = "Auto Lock",
  Desc = "Automatically locks your plot.",
  Value = false,
  Callback = function(state)
    getgenv().AutoLock = state
    AutoLock()
  end
})