local function LoadScript(path, name)
  local Initialize = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Initialize.lua")
  local Script = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/" .. game:GetService("HttpService"):UrlEncode(path))
  local Credits = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Credits.lua")
  loadstring("local InitializeName = \"" .. tostring(name) .. "\"\n" .. Initialize .. "\n" .. Script .. "\n" .. Credits)()
end

local Game = game.GameId

if Game == 7516718402 then
  LoadScript("games/Noobs Must Die.lua", "Noobs Must Die")
elseif Game == 6944270854 then
  LoadScript("games/Rope Battles.lua", "Rope Battles")
elseif Game == 7453941040 then
  LoadScript("games/Dangerous Night.lua", "Dangerous Night")
else
  LoadScript("Triangulare.lua", "Universal")
end