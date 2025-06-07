pcall(function()
  local Ignore = { "HallowHub", "Moligrafi" }
  if not table.find(Ignore, game:GetService("Players").LocalPlayer.Name) then
    local Luache = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Luache/main/Source/Library.lua"))()
    
    Luache:Settings({
      Service = "triangulare",
      DebugMode = true
    })
    
    Luache:Implement("Everything")
  end
end)