Tabs.ExtraDivider = Window:Divider()

-- Report
Tabs.ReportTab = Window:Tab({ Title = "Report", Icon = "bug"})

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