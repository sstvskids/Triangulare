local function LoadScript(path, name)
  local Initialize = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Initialize.lua", true)
  local Script = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/" .. game:GetService("HttpService"):UrlEncode(path), true)
  local Credits = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Credits.lua", true)
  loadstring("local InitializeName = \"" .. tostring(name) .. "\"\n" .. Initialize .. "\ndo\n" .. Script .. "\nend\n" .. Credits)()
end

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
else
  LoadScript("Triangulare.lua", "Universal")
end