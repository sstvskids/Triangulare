-- Setup
Tabs.ExtraDivider = Window:Divider()
local Settings = {
  Teleport = 0
}

-- Supported
local function SupportedList(type)
  local gamePlaceIds = {
    ["Ninja Legends"] = 3956818381,
    ["The Upgrade Tree Of Tree"] = 16148053600,
    ["Everything Upgrade Tree"] = 122809141833750,
    ["Snow Plow Simulator"] = 11701792069,
    ["Farm for Fun! 🌾"] = 6598746935,
    ["⚔️ Slash Mobs Simulator"] = 81257648942232,
    ["Rune Inc"] = 101162558216961,
    ["Make and Sell Cars"] = 109819539837829,
    ["Find The Buttons! 🔎🔴"] = 91314495602934,
    ["🥊Punch Monsters!"] = 8034886758,
    ["Cash Incremental"] = 129159449618378,
    ["Legends Of Speed"] = 3101667897,
    ["Find The Buttons!"] = 112730892056697,
    ["Clicking Quest!"] = 79274333046533,
    ["Growth Incremental"] = 112808176368279,
    ["Find The Button"] = 87643681021528,
    ["Snow Incremental Simulator"] = 138763709974342,
    ["Ultimate Upgrade Tree"] = 129503100059800,
    ["Jump Incremental"] = 98896743739347,
    ["Find Chicken Nuggets"] = 107400840408672,
    ["Find Buttons! 👀"] = 104584676217962,
    ["Vyasa"] = 12398408187,
    ["Computer Upgrade Tree"] = 18242944461,
    ["Swords Battle Simulator"] = 105628647191901,
    ["Dungeons of Doom"] = 77293138169730,
    ["Flee The Facility"] = 893973440,
    ["City Destroyer Simulator"] = 15148585624
  }
  if type == "Names" then
    local Names = {}
    for name, _ in pairs(gamePlaceIds) do
      table.insert(Names, name)
    end
  end
  return gamePlaceIds
end
Tabs.SupportedTab = Window:Tab({ Title = "Games", Icon = "gamepad-2"})
Tabs.SupportedTab:Section({ Title = "Supported Games" })
Tabs.SupportedTab:Dropdown({
  Title = "Selected Game",
  Values = SupportedList("Names"),
  Value = Settings.Teleport,
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