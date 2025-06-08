-- Global Values
getgenv().AutoCollect = false
getgenv().AutoBuy = false
getgenv().AutoClick = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Tycoon = nil,
  Side = nil,
  Giver = nil
}
task.spawn(function()
  while (not Settings.Tycoon or not Settings.Side) and task.wait(1) do
    for _, tycoon in pairs(workspace["berezaa's Tycoon Kit"]:GetChildren()) do
      for _, side in pairs(tycoon:GetChildren()) do
        if side:FindFirstChild("Owner") and side.Owner.Value == eu then
          Settings.Tycoon = tycoon
          Settings.Side = side
          if string.find(side.Name, "Second") then
            Settings.Giver = tycoon.Essentials.Giver2
          elseif string.find(side.Name, "First") then
            Settings.Giver = tycoon.Essentials.Giver
          end
          return
        end
      end
    end
  end
end)

local function AutoCollect()
  while getgenv().AutoCollect and task.wait(1) do
    pcall(function()
      firetouchinterest(eu.Character.HumanoidRootPart, Settings.Giver, 0)
      firetouchinterest(eu.Character.HumanoidRootPart, Settings.Giver, 1)
    end)
  end
end
local function AutoBuy()
  while getgenv().AutoBuy and task.wait(1) do
    pcall(function()
      for _, button in pairs(Settings.Side.Buttons:GetChildren()) do
        pcall(function()
          if button.Head.Transparency == 0 and button.Price.Value <= eu.leaderstats.Cash.Value then
            firetouchinterest(eu.Character.HumanoidRootPart, button.Head, 0)
            firetouchinterest(eu.Character.HumanoidRootPart, button.Head, 1)
            task.wait(0.39)
          end
        end)
      end
    end)
  end
end
local function AutoClick()
  while getgenv().AutoClick and task.wait(0.05) do
    if Settings.Clicker then
      fireclickdetector(Settings.Clicker)
    else
      for _, side in pairs(Settings.Tycoon:GetChildren()) do
        if string.find(side.Name, "Second") and side.PurchasedObjects:FindFirstChild("Mine") then
          fireclickdetector(side.PurchasedObjects.Mine.Button.ClickDetector)
          Settings.Clicker = side.PurchasedObjects.Mine.Button.ClickDetector
        end
      end
    end
  end
end

--[[
local args = {
    [1] = CFrame.new(-131.27867126464844, 70.39132690429688, 160.02992248535156) * CFrame.Angles(-3.130964517593384, 0.7702462077140808, 3.1341919898986816),
    [2] = 100,
    [3] = 1.5,
    [4] = game:GetService("Players").LocalPlayer.Character.Wand,
    [5] = 15,
    [6] = game:GetService("Players").LocalPlayer.Character
}
game:GetService("Players").LocalPlayer.Character.Wand.Fire:FireServer(unpack(args))
game:GetService("Players").LocalPlayer.leaderstats.Cash.Value
workspace["berezaa's Tycoon Kit"]["Pastel Blue"].BlueSecond.Owner
workspace["berezaa's Tycoon Kit"]["Pastel Blue"].BlueFirst.Owner
workspace["berezaa's Tycoon Kit"]["Pastel Blue"].Essentials.Giver2
workspace["berezaa's Tycoon Kit"]["Pastel Blue"].BlueSecond.Buttons["Broom - $5000"].Price.Value

workspace["berezaa's Tycoon Kit"]["Pastel Blue"].BlueSecond.Buttons["Broom - $5000"].Head
110988953/281489669
--]]

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Auto Farm", Icon = "house"}),
  Blatant = Window:Tab({ Title = "Blatant", Icon = "swords"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Collect" })
Tabs.Menu:Toggle({
  Title = "Auto Click",
  Desc = "Click Click",
  Value = false,
  Callback = function(state)
    getgenv().AutoClick = state
    AutoClick()
  end
})
Tabs.Menu:Toggle({
  Title = "Auto Collect Cash",
  Desc = "Automatically collect cash.",
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

-- Blatant
Tabs.Menu:Section({ Title = "Shoot" })