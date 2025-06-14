-- Global Values
getgenv().AutoCollect = false
getgenv().AutoLock = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil,
  Tool = "BanHammer",
  Amount = 5
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
local function ReturnTools()
  local Names = {}
  
  for _, tool in pairs(game:GetService("ReplicatedStorage").Assets.Tools:GetChildren()) do
    if not table.find(Names, tool.Name) then
      table.insert(Names, tool.Name)
    end
  end
  
  return Names
end
local function GetItem()
  local args = {
      [1] = {
          ["gear"] = game:GetService("ReplicatedStorage").Assets.Tools[Settings.Tool],
          ["desc"] = "by Triangulare",
          ["rebirth"] = 0,
          ["cost"] = 0
      },
      [2] = "Purchase"
  }
  
  game:GetService("ReplicatedStorage").Networker.Remotes.Gear:FireServer(unpack(args))
end
local function GetItems()
  for _, tool in pairs(game:GetService("ReplicatedStorage").Assets.Tools:GetChildren()) do
    local args = {
        [1] = {
            ["gear"] = tool,
            ["desc"] = "by Triangulare",
            ["rebirth"] = 0,
            ["cost"] = 0
        },
        [2] = "Purchase"
    }
    
    game:GetService("ReplicatedStorage").Networker.Remotes.Gear:FireServer(unpack(args))
  end
end
local function GetMoney()
  if eu.Backpack:FindFirstChild("BanHammer") then
    eu.Backpack.BanHammer:Destroy()
  elseif eu.Character:FindFirstChild("BanHammer") then
    eu.Character.BanHammer:Destroy()
  end
  
  local args = {
      [1] = {
          ["gear"] = game:GetService("ReplicatedStorage").Assets.Tools.BanHammer,
          ["desc"] = "by Triangulare",
          ["rebirth"] = 0,
          ["cost"] = -Settings.Amount
      },
      [2] = "Purchase"
  }
  
  game:GetService("ReplicatedStorage").Networker.Remotes.Gear:FireServer(unpack(args))
end

--[[
for _, tool in pairs(game:GetService("ReplicatedStorage").Assets.Tools:GetChildren()) do
local args = {
    [1] = {
        ["gear"] = tool,
        ["desc"] = "by Triangulare",
        ["rebirth"] = 0,
        ["cost"] = -100000000
    },
    [2] = "Purchase"
}

game:GetService("ReplicatedStorage").Networker.Remotes.Gear:FireServer(unpack(args))
end
7790982864/123763291847901
workspace.Bases.Base2.Slots.Collector1.TouchInterest
workspace.Bases.Base2.Spawn.BaseUI.Enabled
Your Base
workspace.Bases.Base2.LockPart.BaseLockUI.Value.Visible == false
workspace.Bases.Base2.Gate:GetChildren()[18].Transparency == 1, 0.3
--]]

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Auto Farm", Icon = "house"}),
  Items = Window:Tab({ Title = "Items", Icon = "box"}),
  Money = Window:Tab({ Title = "Money", Icon = "sparkles"}),
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

-- Items
Tabs.Items:Section({ Title = "Selected" })
Tabs.Items:Dropdown({
  Title = "Selected Item",
  Values = ReturnTools(),
  Value = Settings.Tool,
  Callback = function(option)
    Settings.Tool = option
  end
})
Tabs.Items:Section({ Title = "Get" })
Tabs.Items:Button({
  Title = "Get Selected Item",
  Desc = "Gives you the selected item.",
  Callback = function()
    GetItem()
  end
})
Tabs.Items:Button({
  Title = "Get All Item",
  Desc = "Gives you all the items.",
  Callback = function()
    GetItems()
  end
})

-- Money
Tabs.Money:Section({ Title = "Amount" })
Tabs.Money:Input({
  Title = "Amount to Get",
  Value = tostring(Settings.Amount),
  Placeholder = "Numbers only, ex.: 15",
  Callback = function(input)
    Settings.Amount = tonumber(input) or 1
  end
})
Tabs.Money:Section({ Title = "Get" })
Tabs.Money:Button({
  Title = "Get Money",
  Desc = "Gives you the amount of money.",
  Callback = function()
    GetMoney()
  end
})