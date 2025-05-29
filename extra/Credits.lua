-- Setup
Tabs.ExtraDivider = Window:Divider()
local Settings = {
  Teleport = 93557410403539
}

-- Supported
local function SupportedList(type)
  local gamePlaceIds = {
    ["Noobs Must Die"] = 93557410403539,
    ["Rope Battles"] = 136195938137126,
    ["Dangerous Night"] = 109686116036889
  }
  if type == "Names" then
    local Names = {}
    for name, _ in pairs(gamePlaceIds) do
      table.insert(Names, name)
    end
    return Names
  end
  return gamePlaceIds
end
Tabs.SupportedTab = Window:Tab({ Title = "Games", Icon = "gamepad-2"})
Tabs.SupportedTab:Section({ Title = "Supported Games" })
Tabs.SupportedTab:Dropdown({
  Title = "Selected Game",
  Values = SupportedList("Names"),
  Value = SupportedList("IDs")[Settings.Teleport],
  Callback = function(option)
    Settings.Teleport = option
  end
})
Tabs.SupportedTab:Section({ Title = "Teleport to Game" })
Tabs.SupportedTab:Button({
  Title = "Teleport",
  Desc = "Teleports you to the selected game.",
  Callback = function()
    local id = SupportedList("IDs")[Settings.Teleport]
    game:GetService("TeleportService"):Teleport(id, game.Players.LocalPlayer)
  end
})

-- Credits
Tabs.CreditsTab = Window:Tab({ Title = "Credits", Icon = "info"})
Tabs.CreditsTab:Section({ Title = "Developers" })
  Tabs.CreditsTab:Paragraph({
  Title = "Founder Developer",
  Desc = "Discord: @moligrafi",
})
Tabs.CreditsTab:Section({ Title = "Discord Server" })
Tabs.CreditsTab:Paragraph({
  Title = "Discord Server",
  Desc = "https://discord.gg/P9fdBwqcCs",
  Buttons = {
    {
      Title = "Copy Server Link",
      Variant = "Primary",
      Callback = function()
        setclipboard("https://discord.gg/P9fdBwqcCs")
      end,
      Icon = "link"
    }
  }
})