-- Global Values
getgenv().AutoDirty = false
getgenv().AutoOrder = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local DirtyConnection

-- Functions
local function CollectDirty()
  for _, tray in pairs(workspace.OwnedRestaurants[eu.Name].DirtyTrays:GetChildren()) do
    tray.Collect:FireServer()
  end
end
local function AutoDirty()
  CollectDirty()
  if getgenv().AutoDirty and not DirtyConnection then
    DirtyConnection = workspace.OwnedRestaurants[eu.Name].DirtyTrays.ChildAdded:Connect(function(instance)
      if getgenv().AutoDirty then
        instance.Collect:FireServer()
      else
        DirtyConnection:Disconnect()
        DirtyConnection = nil
      end
    end)
  end
end
local function DeliverTray()
  for _, tray in pairs(workspace.OwnedRestaurants[eu.Name].Trash:GetChildren()) do
    pcall(function()
      if tray.Name == "Tray" and #tray.FoodsLeft:GetChildren() == 0 then
        game:GetService("ReplicatedStorage").Remotes.Gameplay.PlaceItem:FireServer(tray, tray.NPCBeam.Attachment1.WorldCFrame * CFrame.new(0, 2, 0))
      end
    end)
  end
end
local function AutoDeliver()
  while getgenv().AutoDeliver and task.wait(1) do
    pcall(function()
      DeliverTray()
    end)
  end
end
-- Cook
local function FlipBurgers()
  for _, top in pairs(workspace.OwnedRestaurants[eu.Name].Furniture.Cooktop.Cooktop:GetChildren()) do
    pcall(function()
      if top["Raw Patty"]:GetAttribute("Occupied") and top["Raw Patty"].Timer.Value == 100 then
        top["Raw Patty"].Flip:FireServer()
      end
    end)
  end
end
local function AutoFlip()
  while getgenv().AutoFlip and task.wait(1) do
    pcall(function()
      FlipBurgers()
    end)
  end
end
-- Orders
local function CollectOrder()
  pcall(function()
    workspace.OwnedRestaurants[eu.Name].Furniture.CashRegisters.Register.TakeOrder:FireServer()
  end)
end
local function AutoOrder()
  while getgenv().AutoOrder and task.wait(3) do
    CollectOrder()
  end
end

-- Tabs
local Tabs = {
  Trays = Window:Tab({ Title = "Trays", Icon = "utensils-crossed"}),
  Cook = Window:Tab({ Title = "Cook", Icon = "chef-hat"}),
  Orders = Window:Tab({ Title = "Orders", Icon = "receipt"})
}
Window:SelectTab(1)

-- Trays
Tabs.Trays:Section({ Title = "Dirty Trays" })
Tabs.Trays:Button({
  Title = "Collect Dirty Trays",
  Desc = "Collects all dirty trays.",
  Callback = function()
    CollectDirty()
  end
})
Tabs.Trays:Toggle({
  Title = "Auto Collect Trays",
  Desc = "Automatically collect dirty trays.",
  Value = false,
  Callback = function(state)
    getgenv().AutoDirty = state
    AutoDirty()
  end
})
Tabs.Trays:Section({ Title = "Finished Trays" })
Tabs.Trays:Button({
  Title = "Deliver Trays",
  Desc = "Deliver all finished trays.",
  Callback = function()
    DeliverTray()
  end
})
Tabs.Trays:Toggle({
  Title = "Auto Deliver",
  Desc = "Automatically deliver finsihed trays.",
  Value = false,
  Callback = function(state)
    getgenv().AutoDeliver = state
    AutoDeliver()
  end
})

-- Cook
Tabs.Cook:Section({ Title = "Burgers" })
Tabs.Cook:Button({
  Title = "Flip Burgers",
  Desc = "Flip raw patties.",
  Callback = function()
    FlipBurgers()
  end
})
Tabs.Cook:Toggle({
  Title = "Auto Flip",
  Desc = "Automatically flip pattie.",
  Value = false,
  Callback = function(state)
    getgenv().AutoFlip = state
    AutoFlip()
  end
})

-- Orders
Tabs.Orders:Section({ Title = "Orders" })
Tabs.Orders:Button({
  Title = "Collect Orders",
  Desc = "Collects all orders.",
  Callback = function()
    CollectOrder()
  end
})
Tabs.Orders:Toggle({
  Title = "Auto Collect Orders",
  Desc = "Automatically collect orders.",
  Value = false,
  Callback = function(state)
    getgenv().AutoOrder = state
    AutoOrder()
  end
})