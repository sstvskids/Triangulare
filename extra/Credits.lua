-- Setup
local CredSettings = {
  Teleport = "Noobs Must Die"
}
local CredTabs = {}
CredTabs.ExtraDivider = Window:Divider()

-- Supported
local function SupportedList(type)
  local gamePlaceIds = {
    ["Noobs Must Die"] = 93557410403539,
    ["Rope Battles"] = 136195938137126,
    ["Dangerous Night"] = 109686116036889,
    ["[DUELS] Murderers VS Sherrifs"] = 135856908115931,
    ["Make a Sprunki Tycoon!"] = 71508074112900,
    ["Fast Food Simulator"] = 119055906651998,
    ["Basketball Legends"] = 14259168147,
    ["Saber Showdown"] = 12625784503,
    ["Kingdom of Magic Tycoon"] = 18608175830,
    ["Wizard Tycoon - 2 Player"] = 281489669,
    ["raise bob"] = 84593840279371,
    ["Steal a Pet"] = 106848621211283
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
CredTabs.SupportedTab = Window:Tab({ Title = "Games", Icon = "gamepad-2"})
CredTabs.SupportedTab:Section({ Title = "Supported Games" })
CredTabs.SupportedTab:Dropdown({
  Title = "Selected Game",
  Values = SupportedList("Names"),
  Value = CredSettings.Teleport,
  Callback = function(option)
    CredSettings.Teleport = option
  end
})
CredTabs.SupportedTab:Section({ Title = "Teleport to Game" })
CredTabs.SupportedTab:Button({
  Title = "Teleport",
  Desc = "Teleports you to the selected game.",
  Callback = function()
    local id = SupportedList("IDs")[CredSettings.Teleport]
    game:GetService("TeleportService"):Teleport(id, game:GetService("Players").LocalPlayer)
  end
})

-- Credits
CredTabs.CreditsTab = Window:Tab({ Title = "Credits", Icon = "info"})
CredTabs.CreditsTab:Section({ Title = "Developers" })
  CredTabs.CreditsTab:Paragraph({
  Title = "Founder Developer",
  Desc = "Discord: @moligrafi",
})
  CredTabs.CreditsTab:Paragraph({
  Title = "Co-Developer",
  Desc = "Discord: @estranquilo",
})
CredTabs.CreditsTab:Section({ Title = "Discord Server" })
CredTabs.CreditsTab:Paragraph({
  Title = "Discord Server",
  Desc = "https://discord.gg/Pwk5HdZX3S",
  Buttons = {
    {
      Title = "Copy Server Link",
      Variant = "Primary",
      Callback = function()
        setclipboard("https://discord.gg/Pwk5HdZX3S")
      end,
      Icon = "link"
    }
  }
})
