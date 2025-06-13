-- Global Values
getgenv().AutoCollect = false
getgenv().AutoDeliver = false
getgenv().AutoLock = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil
}

-- Load
task.spawn(function()
  while not Settings.Plot and task.wait(1) do
    for _, plot in pairs(workspace.Plots:GetChildren()) do
      if plot:FindFirstChild("owner") and plot.owner.Value == eu then
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
      for _, pet in pairs(Settings.Plot.plot_model.pet_slots:GetChildren()) do
        pcall(function()
          if pet.main.to_collect.Value > 0 then
            firetouchinterest(eu.Character.HumanoidRootPart, pet.main.collect_touch, 0)
            firetouchinterest(eu.Character.HumanoidRootPart, pet.main.collect_touch, 1)
          end
        end)
      end
    end)
  end
end
local function AutoDeliver()
  while getgenv().AutoDeliver and task.wait(0.39) do
    pcall(function()
      firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.plot_model.safe_zone.zone, 0)
      firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.plot_model.safe_zone.zone, 1)
    end)
  end
end
local function AutoLock()
  local function Lock()
    if eu.leaderstats.Cash.Value >= 30000 then
      firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.plot_model.touches.Lock1m_touch, 0)
      firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.plot_model.touches.Lock1m_touch, 1)
    end
  end
  while getgenv().AutoLock and task.wait(0.39) do
    pcall(function()
      if not Settings.Plot.plot_model:GetAttribute("Connected") then
        Settings.Plot.plot_model:SetAttribute("Connected", true)
        Settings.Plot.plot_model.ChildRemoved:Connect(function()
          if getgenv().AutoLock and not Settings.Plot.plot_model:FindFirstChild("lasers") then
            Lock()
          end
        end)
      end
      
      if not Settings.Plot.plot_model:FindFirstChild("lasers") then
        Lock()
      end
    end)
  end
end

--[[
game:GetService("Players").LocalPlayer.leaderstats.Cash
workspace.Plots:GetChildren()[7].plot_model.pet_slots["1"].main.to_collect.Value > 0
workspace.Plots:GetChildren()[7].plot_model.pet_slots["1"].main.collect_touch
workspace.Plots:GetChildren()[7].owner
workspace.Plots:GetChildren()[7].plot_model.safe_zone.zone.TouchInterest
workspace.Plots:GetChildren()[3].plot_model.touches.Lock1m_touch.TouchInterest
workspace.Plots:GetChildren()[3].plot_model.lasers.Laser_Bot
7713074498/106848621211283
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
Tabs.Menu:Toggle({
  Title = "Auto Deliver",
  Desc = "Automatically delivers stole pets.",
  Value = false,
  Callback = function(state)
    getgenv().AutoDeliver = state
    AutoDeliver()
  end
})