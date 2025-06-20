local cloneref = cloneref or function(val) return val end
local HttpService = cloneref(game:GetService('HttpService'))
local Players = cloneref(game:GetService('Players'))

local function loadscript(path, name)
    local init = game:HttpGet('https://raw.githubusercontent.com/sstvskids/Triangulare/'..HttpService:JSONDecode(game:HttpGet('https://api.github.com/repos/sstvskids/Triangulare/commits'))[1].sha..'/extra/Initialize.lua', true)
    local scriptpath = game:HttpGet('https://raw.githubusercontent.com/sstvskids/Triangulare/'..HttpService:JSONDecode(game:HttpGet('https://api.github.com/repos/sstvskids/Triangulare/commits'))[1].sha..'/'..HttpService:UrlEncode(path), true)
    local credits = game:HttpGet('https://raw.githubusercontent.com/sstvskids/Triangulare/'..HttpService:JSONDecode(game:HttpGet('https://api.github.com/repos/sstvskids/Triangulare/commits'))[1].sha..'/extra/Credits.lua', true)
    return loadstring("local InitializeName = \""..tostring(name).."\"\n"..init.."\ndo\n"..scriptpath.."\nend\n"..credits)()
end

if game.PlaceId == 93557410403539 then
    loadscript('games/Noobs Must Die.lua', 'Noobs Must Die')
end

-- why vro
--[[
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
elseif Game == 7577218041 then
  LoadScript("games/Steal a Character.lua", "Steal a Character")
elseif Game == 7868793307 then
  LoadScript("games/Steal a Gubby.lua", "Steal a Gubby")
elseif Game == 7842205848 then
  LoadScript("games/Steal a Labubu.lua", "Steal a Labubu")
else
  LoadScript("Triangulare.lua", "Universal")
end
]]