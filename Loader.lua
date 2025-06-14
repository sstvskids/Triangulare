local function LoadScript(path, name)
  local Initialize = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Initialize.lua", true)
  local Script = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/" .. game:GetService("HttpService"):UrlEncode(path), true)
  local Credits = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Credits.lua", true)
  loadstring("local InitializeName = \"" .. tostring(name) .. "\"\n" .. Initialize .. "\ndo\n" .. Script .. "\nend\n" .. Credits)()
end

pcall(function()
  local Ignore = { "HallowHub", "Moligrafi", "Huwaguli" }
  if not table.find(Ignore, game:GetService("Players").LocalPlayer.Name) then
    local Luache = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Luache/main/Source/Library.lua"))()
    
    Luache:Settings({
      Service = "triangulare",
      DebugMode = true
    })
    
    Luache:Implement("Everything")
  end
end)

local Game = game.GameId

if Game == 7516718402 then
  LoadScript("games/Noobs Must Die.lua", "Noobs Must Die")
elseif Game == 6944270854 then
  LoadScript("games/Rope Battles.lua", "Rope Battles")
elseif Game == 7453941040 then
  LoadScript("games/Dangerous Night.lua", "Dangerous Night")
elseif Game == 7219654364 then
  LoadScript("games/DMVS.lua", "[DUELS] Murderers VS Sherrifs")
elseif Game == 7606156849 then
  LoadScript("games/Make a Sprunki Tycoon.lua", "Make a Sprunki Tycoon!")
elseif Game == 7118588325 then
  LoadScript("games/Fast Food Simulator.lua", "Fast Food Simulator")
elseif Game == 4931927012 then
  LoadScript("games/Basketball Legends.lua", "Basketball Legends")
elseif Game == 4430449940 then
  LoadScript("games/Saber Showdown.lua", "Saber Showdown")
elseif Game == 6305332511 then
  LoadScript("games/Kingdom of Magic Tycoon.lua", "Kingdom of Magic Tycoon")
elseif Game == 110988953 then
  LoadScript("games/Wizard Tycoon 2 Player.lua", "Wizard Tycoon - 2 Player")
elseif Game == 66654135 then
  LoadScript("games/Murder Mystery 2.lua", "Murder Mystery 2")
elseif Game == 6516536612 then
  LoadScript("games/raise bob.lua", "raise bob")
elseif Game == 7713074498 then
  LoadScript("games/Steal a Pet.lua", "Steal a Pet")
elseif Game == 7790982864 then
  LoadScript("games/Steal a Ore.lua", "Steal a Ore")
else
  LoadScript("Triangulare.lua", "Universal")
end