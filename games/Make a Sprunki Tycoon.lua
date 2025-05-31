-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Functions
local function AutoSell()
  while getgenv().AutoSell and task.wait(1) do
    if eu.Character:FindFirstChildOfClass("Tool") then
      for _, npc in pairs(workspace.Npcs:GetChildren()) do
        if npc.HumanoidRootPart.ProximityPrompt.Enabled then
          fireproximityprompt(npc.HumanoidRootPart.ProximityPrompt)
          if not eu.Character:FindFirstChildOfClass("Tool") then break end
        end
      end
    end
  end
end
local function GetOre()
  while getgenv().GetOre and task.wait(1) do
    if not eu.Character:FindFirstChild("Ore") and not eu.Backpack:FindFirstChild("Ore") then
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

-- 71508074112900 place
-- 7606156849 game
--[[
workspace.Map.Tycoons["HallowHub's Tycoon"]["Worker 1 Button"]
game:GetService("Players").LocalPlayer.leaderstats.Money.Value
workspace.Map.Tycoons["HallowHub's Tycoon"]["Pile of Rubble 1"].PromptPart.ProximityPrompt
workspace.Map.Tycoons["HallowHub's Tycoon"].Conveyor1["Insert Rocks"].BillboardGui.Amount Add Fabric (0/3)
workspace.Map.Tycoons["HallowHub's Tycoon"]["Worker 1"].HumanoidRootPart.WakeupPrompt
workspace.Npcs["2025110"].HumanoidRootPart.ProximityPrompt
--]]