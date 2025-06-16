-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Selected = "",
  Busy = false
}

-- Functions
local function ReturnFurniture()
  local Names = {}
  
  for _, item in pairs(workspace.Wyposazenie:GetChildren()) do
    if item:IsA("Folder") then
      for _, interno in pairs(item:GetChildren()) do
        if interno:IsA("Model") and not table.find(Names, interno.Name) then
          table.insert(Names, interno.Name)
        end
      end
    elseif item:IsA("Model") and not table.find(Names, item.Name) then
      table.insert(Names, item.Name)
    end
  end
  
  return Names
end
local function GetFurniture()
  for _, furniture in pairs(workspace.Wyposazenie:GetChildren()) do
    if furniture:IsA("Folder") then
      for _, interno in pairs(furniture:GetChildren()) do
        if interno:IsA("Model") and interno.Name == Settings.Selected then
          game:GetService("ReplicatedStorage").PickupItemEvent:FireServer(interno)
          return true
        end
      end
    elseif furniture:IsA("Model") and furniture.Name == Settings.Selected then
      game:GetService("ReplicatedStorage").PickupItemEvent:FireServer(furniture)
      return true
    end
  end
  
  return false
end
local function CollectFood()
  local function ReturnFood()
    local Names = {}
    
    for _, food in pairs(workspace:GetChildren()) do
      if food:IsA("Tool") and food:FindFirstChild("Handle") then
        table.insert(Names, food)
      end
    end
    
    return Names
  end
  repeat
    if not Settings.Busy and #ReturnFood() > 0 then
      Settings.Busy = true
      eu.Character.HumanoidRootPart:SetAttribute("Marc", eu.Character.HumanoidRootPart.CFrame)
      for _, food in pairs(ReturnFood()) do
        eu.Character.HumanoidRootPart.CFrame = food.Handle.CFrame
        task.wait(0.3)
        fireproximityprompt(food.Handle.ProximityPrompt)
        eu.Character.HumanoidRootPart.CFrame = eu.Character.HumanoidRootPart:GetAttribute("Marc")
        task.wait(0.1)
      end
      Settings.Busy = false
    end
  until #ReturnFood() == 0
end

-- Tabs
local Tabs = {
  FurnitureTab = Window:Tab({ Title = "Furniture", Icon = "book"}),
  FoodTab = Window:Tab({ Title = "Food", Icon = "banana"})
}
Window:SelectTab(1)

-- Furniture
Tabs.FurnitureTab:Section({ Title = "Selected" })
Tabs.FurnitureTab:Dropdown({
  Title = "Selected Furniture",
  Values = ReturnFurniture(),
  Value = Settings.Selected,
  Callback = function(option)
    Settings.Selected = option
  end
})
Tabs.FurnitureTab:Section({ Title = "Bring" })
Tabs.FurnitureTab:Button({
  Title = "Bring Selected Furniture",
  Desc = "Gives you the selected furniture.",
  Callback = function()
    GetFurniture()
  end
})

-- Food
Tabs.FoodTab:Section({ Title = "Collect" })
Tabs.FoodTab:Button({
  Title = "Collect Food",
  Desc = "Gives you all the food in the map.",
  Callback = function()
    CollectFood()
  end
})