local function LoadScript(path, name)
  local Initialize = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Initialize.lua")
  local Script = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/" .. game:GetService("HttpService"):UrlEncode(path))
  local Credits = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Credits.lua")
  loadstring("local InitializeName = " .. name .. "\n" .. Initialize .. "\n" .. Script .. "\n" .. Credits)()
end

local Game = game.GameId

if Game == 7516718402 then
  LoadScript("games/Noobs Must Die.lua", "cu gratuito")
else
  LoadScript("Triangulare.lua")
end