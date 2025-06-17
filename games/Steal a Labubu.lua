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
    for _, plot in pairs(workspace.Map.Plots:GetChildren()) do
      if plot:GetAttribute("OwnerId") == eu.UserId then
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
      for _, pad in pairs(Settings.Plot.CharacterPads:GetChildren()) do
        pcall(function()
          if pad:GetAttribute("Cash") > 0 then
            firetouchinterest(eu.Character.HumanoidRootPart, pad.CollectPad.Hitbox, 0)
            firetouchinterest(eu.Character.HumanoidRootPart, pad.CollectPad.Hitbox, 1)
          end
        end)
      end
    end)
  end
end
local function AutoLock()
  while getgenv().AutoLock and task.wait(0.39) do
    pcall(function()
      if not Settings.Plot:GetAttribute("LockTimeLeft") then
        firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.LockButton, 0)
        firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.LockButton, 1)
      end
    end)
  end
end
local function AutoDeliver()
  while getgenv().AutoDeliver and task.wait(0.39) do
    pcall(function()
      firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.CashMultiDisplay, 0)
      firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.CashMultiDisplay, 1)
    end)
  end
end

--[[
workspace.Map.Plots:GetChildren()[8].CharacterPads["1"].CollectPad.Hitbox.TouchInterest
Cash 1
workspace.Map.Plots:GetChildren()[8].LockButton.TouchInterest
workspace.Map.Plots:GetChildren()[8].CashMultiDisplay.TouchInterest
workspace.Map.Plots:GetChildren()[8]
LockTimeLeft
7842205848/119823419558973
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