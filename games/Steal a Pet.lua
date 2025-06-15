-- Global Values
getgenv().AutoCollect = false
getgenv().AutoDeliver = false
getgenv().AutoLock = false
getgenv().AntiLasers = false
getgenv().SniperPet = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil,
  Pet = "CelestialWolf",
  Busy = false
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
local function AntiLasers()
  local function SetLaser(path, boolean)
    for _, obj in pairs(path:GetDescendants()) do
      if obj:IsA("BasePart") then
        obj.CanTouch = boolean
        obj.CanCollide = boolean
      end
    end
  end
  while getgenv().AntiLasers and task.wait(1) do
    pcall(function()
      for _, plot in pairs(workspace.Plots:GetChildren()) do
      pcall(function()
        if plot.owner.Value ~= eu then
          if not plot:GetAttribute("AntiLasers") then
            plot:SetAttribute("AntiLasers", true)
            plot.plot_model.ChildAdded:Connect(function(obj)
              if getgenv().AntiLasers and obj.Name == "lasers" then
                SetLaser(obj, false)
              end
            end)
          end
          if plot.plot_model:FindFirstChild("lasers") then
            SetLaser(plot.plot_model:FindFirstChild("lasers"), false)
          end
        end
       end)
      end
    end)
  end
  if not getgenv().AntiLasers then
    for _, plot in pairs(workspace.Plots:GetChildren()) do
      pcall(function()
        if plot.owner.Value ~= eu then
          if plot.plot_model:FindFirstChild("lasers") then
            SetLaser(plot.plot_model:FindFirstChild("lasers"), true)
          end
        end
      end)
    end
  end
end
local function ReturnPets()
  local Names = {}
  
  for _, pet in pairs(game:GetService("ReplicatedStorage").Pets.Models:GetChildren()) do
    if pet:FindFirstChild("Head") and not table.find(Names, pet.Name) then
      table.insert(Names, pet.Name)
    end
  end
  
  return Names
end
local function SniperPet()
  local function SniperThisMf(pet)
    if not pet:GetAttribute("Clicking") and pet:FindFirstChild("HumanoidRootPart") and pet.HumanoidRootPart:FindFirstChild("Purchase_Prompt")  and pet.HumanoidRootPart.Purchase_Prompt:IsA("ProximityPrompt") then
      pet:SetAttribute("Scanning", true)
      repeat task.wait(0.25)
        if not getgenv().SniperPet then return end
        eu.Character.HumanoidRootPart.CFrame = pet.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
        fireproximityprompt(pet.HumanoidRootPart.Purchase_Prompt)
      until not pet or not pet:IsDescendantOf(workspace.Pets.Available)
    end
  end
  while getgenv().SniperPet and task.wait(1) do
    if not workspace.Pets.Available:GetAttribute("Connected") then
      workspace.Pets.Available:SetAttribute("Connected", true)
      workspace.Pets.Available.ChildAdded:Connect(function(pet)
        if getgenv().SniperPet and pet.Name == Settings.Pet then
          WindUI:Notify({
            Title = Settings.Pet .. "detected!",
            Content = "Make sure you got the money.",
            Icon = "crosshair",
            Duration = 5,
          })
          SniperThisMf(pet)
        end
      end)
    end
    for _, pet in pairs(workspace.Pets.Available:GetChildren()) do
      if pet.Name == Settings.Pet then
        SniperThisMf(pet)
      end
    end
  end
end

--[[
workspace.Pets.Available.Duck.HumanoidRootPart.Purchase_Prompt
game:GetService("ReplicatedStorage").Pets.Models
CelestialWolf
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
  Menu = Window:Tab({ Title = "Auto Farm", Icon = "house"}),
  Snipe = Window:Tab({ Title = "Sniper Pet", Icon = "crosshair"})
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
Tabs.Menu:Toggle({
  Title = "Anti Lasers",
  Desc = "Disable the dangerous lasers.",
  Value = false,
  Callback = function(state)
    getgenv().AntiLasers = state
    AntiLasers()
  end
})

-- Snipe
Tabs.Snipe:Section({ Title = "Select" })
Tabs.Snipe:Dropdown({
  Title = "Selected Pet",
  Values = ReturnPets(),
  Value = Settings.Pet,
  Callback = function(option)
    Settings.Pet = option
  end
})
Tabs.Snipe:Section({ Title = "Sniper" })
Tabs.Snipe:Toggle({
  Title = "Sniper Pet",
  Desc = "Buys the selected pet when it spawns.",
  Value = false,
  Callback = function(state)
    getgenv().SniperPet = state
    SniperPet()
  end
})