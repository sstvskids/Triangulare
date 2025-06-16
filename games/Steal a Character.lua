-- Global Values
getgenv().AutoCollect = false
getgenv().AutoLock = false
getgenv().AntiLasers = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Studio = nil,
  Busy = false
}

-- Loading
for _, studio in pairs(workspace.Studios:GetChildren()) do
  if studio:GetAttribute("Owner") == eu.UserId then
    Settings.Studio = studio
    break
  end
end

-- Functions
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(1) do
    pcall(function()
      for _, platform in pairs(Settings.Studio.Platforms:GetChildren()) do
        if platform:FindFirstChildOfClass("Model") then
          firetouchinterest(eu.Character.HumanoidRootPart, platform.Collect, 0)
          firetouchinterest(eu.Character.HumanoidRootPart, platform.Collect, 1)
        end
      end
    end)
  end
end
local function AutoLock()
  while getgenv().AutoLock and task.wait(1) do
    pcall(function()
      if not Settings.Studio:GetAttribute("Locked") and eu.leaderstats.Worth.Value >= 30000 then
        firetouchinterest(eu.Character.HumanoidRootPart, Settings.Studio.LockOneMin.Hitbox, 0)
        firetouchinterest(eu.Character.HumanoidRootPart, Settings.Studio.LockOneMin.Hitbox, 1)
      end
    end)
  end
end
local function AntiLasers()
  local function SetState(state)
   for _, studio in pairs(workspace.Studios:GetChildren()) do
     pcall(function()
        if studio:GetAttribute("Owner") ~= eu.UserId then
          for _, barrier in pairs(studio.Barrier:GetChildren()) do
            barrier.CanCollide = state
            barrier.CanTouch = state
          end
        end
      end)
    end
  end
  while getgenv().AntiLasers and task.wait(1) do
    SetState(false)
  end
  if not getgenv().AntiLasers then
    SetState(true)
  end
end

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
  Title = "Anti Lasers",
  Desc = "Disable the dangerous lasers.",
  Value = false,
  Callback = function(state)
    getgenv().AntiLasers = state
    AntiLasers()
  end
})