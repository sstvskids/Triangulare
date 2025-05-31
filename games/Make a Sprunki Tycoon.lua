-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Functions
local function AutoSell()
  while getgenv().AutoSell and task.wait(1) do
    if eu.Character:FindFirstChild("Sprunki") or eu.Backpack:FindFirstChild("Sprunki") then
      for _, npc in pairs(workspace.Npcs:GetChildren()) do
        if npc.HumanoidRootPart.ProximityPrompt.Enabled then
          fireproximityprompt(npc.HumanoidRootPart.ProximityPrompt)
          if not eu.Character:FindFirstChild("Sprunki") and not eu.Backpack:FindFirstChild("Sprunki") then break end
        end
      end
    end
  end
end
local function GetOre()
  while getgenv().GetOre and task.wait(1) do
    if not eu.Character:FindFirstChild("Fabric") and not eu.Backpack:FindFirstChild("Fabric") then
      fireproximityprompt(workspace.Map.Tycoons[eu.Name .. "'s Tycoon"]["Pile of Rubble 1"].PromptPart.ProximityPrompt)
    end
  end
end
local function BetterWorkers()
  while getgenv().BetterWorkers and task.wait(1) do
    for _, worker in pairs(workspace.Map.Tycoons[eu.Name .. "'s Tycoon"]:GetChildren()) do
      if string.find("Worker", worker.Name) and worker.HumanoidRootPart.WakeupPrompt.Enabled then
        fireproximityprompt(worker.HumanoidRootPart.WakeupPrompt)
      end
    end
  end
end
local function AutoBuy()
  while getgenv().AutoBuy and task.wait(1) do
    for _, button in pairs(workspace.Map.Tycoons[eu.Name .. "'s Tycoon"]:GetChildren()) do
      if string.find("Button", button.Name) and butto:GetAttribute("Price") <= eu.leaderstats.Money.Value then
        firetouchinterest(eu.Character.HumanoidRootPart, button.Head, 0)
        firetouchinterest(eu.Character.HumanoidRootPart, button.Head, 1)
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
  Menu = Window:Tab({ Title = "Main", Icon = "home"})
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
  Title = "Auto Sell",
  Desc = "Automatically sells Sprunkis.",
  Value = false,
  Callback = function(state)
    getgenv().AutoSell = state
    AutoSell()
  end
})