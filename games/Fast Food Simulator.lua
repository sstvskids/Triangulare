-- Global Values
getgenv().AutoDirty = false

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
  Menu = Window:Tab({ Title = "Main", Icon = "utensils-crossed"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Dirty Trays" })
Tabs.Menu:Button({
  Title = "Collect Dirty Trays",
  Desc = "Collects all dirty trays.",
  Callback = function()
    CollectDirty()
  end
})
Tabs.Menu:Toggle({
  Title = "Auto Collect Trays",
  Desc = "Automatically collect dirty trays.",
  Value = false,
  Callback = function(state)
    getgenv().AutoDirty = state
    AutoDirty()
  end
})
Tabs.Menu:Section({ Title = "Orders" })
Tabs.Menu:Button({
  Title = "Collect Orders",
  Desc = "Collects all orders.",
  Callback = function()
    CollectOrder()
  end
})
Tabs.Menu:Toggle({
  Title = "Auto Collect Orders",
  Desc = "Automatically collect orders.",
  Value = false,
  Callback = function(state)
    getgenv().AutoOrder = state
    AutoOrder()
  end
})