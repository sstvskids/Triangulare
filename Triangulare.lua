local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
  Title = "Triangulare | Universal",
  Icon = "triangle",
  Author = "by Moligrafi",
  Folder = "Triangulare",
  Size = UDim2.fromOffset(580, 460),
  Transparent = true,
  Theme = "Dark",
  User = {
    Enabled = true
  },
  SideBarWidth = 200,
  HasOutline = true,
})
Window:EditOpenButton({
  Title = "Triangulare",
  Icon = "triangle",
  CornerRadius = UDim.new(0,16),
  StrokeThickness = 2,
  Color = ColorSequence.new(Color3.fromRGB(0, 255, 120), Color3.fromRGB(0, 120, 255)),
  Draggable = true
})

-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Tabs
local Tabs = {
  MoveTab = Window:Tab({ Title = "Movement", Icon = "chevrons-up"})
}
Window:SelectTab(1)