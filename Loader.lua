local function LoadScript(path)
  local Script = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/" .. game:GetService("HttpService"):UrlEncode(path))
  local Credits = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Credits.lua")
  loadstring(Script .. "\n" .. Credits)()
end

local Game = game.GameId

if Game == 7516718402 then
  LoadScript("games/Noobs Must Die.lua")
else
  LoadScript("Triangulare.lua")
end