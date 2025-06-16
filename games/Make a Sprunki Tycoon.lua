-- Global Values
getgenv().AutoSell = false
getgenv().GetOre = false
getgenv().AutoBuy = false
getgenv().BetterWorkers = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Sprunkis = { "Oren", "Simon", "Pinki", "Tunner" },
  Conveyor1 = true,
  Conveyor2 = true,
  Conveyor3 = true,
  Conveyor4 = true
}

-- Functions
local function GetConveyor(instance)
  if string.find(instance.Name, "Worker") then
    return
  elseif string.find(instance.Name, "Button") then
    return
  end
end
local function SellSprunkis()
end
local function AutoSell()
  while getgenv().AutoSell and task.wait(1) do
    pcall(function()
      if eu.Character:FindFirstChild("Sprunki") or eu.Backpack:FindFirstChild("Sprunki") then
        for _, npc in pairs(workspace.Npcs:GetChildren()) do
          if npc.HumanoidRootPart.ProximityPrompt.Enabled then
            fireproximityprompt(npc.HumanoidRootPart.ProximityPrompt)
            if not eu.Character:FindFirstChild("Sprunki") and not eu.Backpack:FindFirstChild("Sprunki") then break end
          end
        end
      end
    end)
  end
end
local function GetOre()
  while getgenv().GetOre and task.wait(1) do
    pcall(function()
      if not eu.Character:FindFirstChild("Fabric") and not eu.Backpack:FindFirstChild("Fabric") then
        fireproximityprompt(workspace.Map.Tycoons[eu.Name .. "'s Tycoon"]["Pile of Rubble 1"].PromptPart.ProximityPrompt)
      end
    end)
  end
end
local function BetterWorkers()
  while getgenv().BetterWorkers and task.wait(1) do
    pcall(function()
      for _, worker in pairs(workspace.Map.Tycoons[eu.Name .. "'s Tycoon"]:GetChildren()) do
        if string.find(worker.Name, "Worker") and worker.HumanoidRootPart.WakeupPrompt.Enabled then
          fireproximityprompt(worker.HumanoidRootPart.WakeupPrompt)
        end
      end
    end)
  end
end
local function AutoBuy()
  while getgenv().AutoBuy and task.wait(1) do
    pcall(function()
      for _, button in pairs(workspace.Map.Tycoons[eu.Name .. "'s Tycoon"]:GetChildren()) do
        pcall(function()
          if string.find(button.Name, "Button") then
            if button:GetAttribute("RocksSold") then
              if button:GetAttribute("Price") <= eu.leaderstats["Sprunki Sold"].Value then
                firetouchinterest(eu.Character.HumanoidRootPart, button.Head, 0)
                firetouchinterest(eu.Character.HumanoidRootPart, button.Head, 1)
                task.wait(1)
              end
            else
              if button:GetAttribute("Price") <= eu.leaderstats.Money.Value then
                firetouchinterest(eu.Character.HumanoidRootPart, button.Head, 0)
                firetouchinterest(eu.Character.HumanoidRootPart, button.Head, 1)
                task.wait(1)
              end
            end
          end
        end)
      end
    end)
  end
end
local function CollectSprunkis()
  while getgenv().CollectSprunkis and task.wait(1) do
    if not eu.Character:FindFirstChild("Sprunki") and not eu.Backpack:FindFirstChild("Sprunki") then
      for _, sprunki in pairs(workspace.Map.Tycoons[eu.Name .. "'s Tycoon"]:GetChildren()) do
        if not eu.Character:FindFirstChild("Sprunki") and not eu.Backpack:FindFirstChild("Sprunki") and sprunki.Name == "Rock Container" and sprunki.PromptPart.ProximityPrompt.Enabled then
          fireproximityprompt(sprunki.PromptPart.ProximityPrompt)
        end
      end
    end
  end
end

--[[
workspace.Map.Tycoons["HallowHub's Tycoon"]["Worker 1 Button"]
game:GetService("Players").LocalPlayer.leaderstats.Money.Value
workspace.Map.Tycoons["HallowHub's Tycoon"]["Pile of Rubble 1"].PromptPart.ProximityPrompt
workspace.Map.Tycoons["HallowHub's Tycoon"].Conveyor1["Insert Rocks"].BillboardGui.Amount Add Fabric (0/3)
workspace.Map.Tycoons["HallowHub's Tycoon"]["Worker 1"].HumanoidRootPart.WakeupPrompt
workspace.Npcs["2025110"].HumanoidRootPart.ProximityPrompt
--]]

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"}),
  Sprunkis = Window:Tab({ Title = "Sprunkis", Icon = "box"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Auto Farm" })
Tabs.Menu:Toggle({
  Title = "Auto Buy Buttons",
  Desc = "Buy the buttons you can afford.",
  Value = false,
  Callback = function(state)
    getgenv().AutoBuy = state
    AutoBuy()
  end
})
Tabs.Menu:Toggle({
  Title = "Collet Fabric",
  Desc = "Automatically collect fabrics.",
  Value = false,
  Callback = function(state)
    getgenv().GetOre = state
    GetOre()
  end
})
Tabs.Menu:Toggle({
  Title = "Awake Workers",
  Desc = "Automatically wake up workers.",
  Value = false,
  Callback = function(state)
    getgenv().BetterWorkers = state
    BetterWorkers()
  end
})

-- Menu
Tabs.Sprunkis:Section({ Title = "Sell" })
Tabs.Sprunkis:Toggle({
  Title = "Auto Sell",
  Desc = "Automatically sells Sprunkis.",
  Value = false,
  Callback = function(state)
    getgenv().AutoSell = state
    AutoSell()
  end
})
Tabs.Sprunkis:Section({ Title = "Collect" })
Tabs.Sprunkis:Toggle({
  Title = "Auto Collect",
  Desc = "Automatically collect sprunkis.",
  Value = false,
  Callback = function(state)
    getgenv().CollectSprunkis = state
    CollectSprunkis()
  end
})