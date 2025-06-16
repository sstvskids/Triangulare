-- Global Values
getgenv().AutoCollect = false
getgenv().AutoLock = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil
}

-- Load
task.spawn(function()
  while not Settings.Plot and task.wait(1) do
    for _, plot in pairs(workspace.GameFolder.HouseFolder:GetChildren()) do
      if plot:GetAttribute("Owned") == eu.Name then
        Settings.Plot = plot
        return
      end
    end
  end
end)

local function AutoCollect()
  while getgenv().AutoCollect and task.wait(1) do
    pcall(function()
      for _, display in pairs(Settings.Plot.Display:GetChildren()) do
        pcall(function()
          if display:GetAttribute("Amount") > 0 then
            firetouchinterest(eu.Character.HumanoidRootPart, display.CollectPart, 0)
            firetouchinterest(eu.Character.HumanoidRootPart, display.CollectPart, 1)
          end
        end)
      end
    end)
  end
end
local function AutoLock()
  while getgenv().AutoLock and task.wait(0.39) do
    pcall(function()
      if Settings.Plot.Lasers.Part.Transparency == 1 then
        firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.LockPart, 0)
        firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.LockPart, 1)
      end
    end)
  end
end

--[[
7868793307/79983021053282
workspace.GameFolder.HouseFolder.House6.LockPart.TouchInterest
Owned == eu.Name
workspace.GameFolder.HouseFolder.House6.Display.DisplayPad1.CollectPart.TouchInterest
Amount
workspace.GameFolder.HouseFolder.House6.Lasers.Part
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