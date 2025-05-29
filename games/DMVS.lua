-- Global Values
getgenv().AutoGun = false
getgenv().PullGun = false
getgenv().HitBox = false
getgenv().PlayerESP = false
getgenv().GunSound = false
getgenv().AnnoyTrade = false
getgenv().CancelTrade = false
getgenv().Triggerbot = false
getgenv().AutoSlash = false
getgenv().KnifeTrigger = false
getgenv().EquipKnife = false
getgenv().AutoTPe = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Selected = "Lobby",
  Teleport = "Everytime",
  TriggerbotCooldown = 3,
  SlashCooldown = 0.5,
  SpamSoundCooldown = 0.2,
  KnifeCooldown = 1,
  IgnoreWalls = false,
  KnifeMethod = "Single Target"
}
local HitSize = 5
local IsCooldown = false
local CorInocente = Color3.fromRGB(255, 125, 0)

-- Functions
local function Teleport()
  pcall(function()
    if Settings.Selected == "Lobby" then
      eu.Character.HumanoidRootPart.CFrame = CFrame.new(-337, 76, 19)
    elseif Settings.Selected == "Factory" then
      eu.Character.HumanoidRootPart.CFrame = CFrame.new(-1074, 113, 5437)
    elseif Settings.Selected == "House" then
      eu.Character.HumanoidRootPart.CFrame = CFrame.new(408, 111, 6859)
    elseif Settings.Selected == "Mansion" then
      eu.Character.HumanoidRootPart.CFrame = CFrame.new(-1175, 47, 6475)
    elseif Settings.Selected == "MilBase" then
      eu.Character.HumanoidRootPart.CFrame = CFrame.new(-1186, 27, 3737)
    end
  end)
end
local function EquipKnife()
  while getgenv().EquipKnife and task.wait(0.25) do
    pcall(function()
      for _, tool in pairs(eu.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Slash") and tool:FindFirstChild("Throw") then
          tool.Parent = eu.Character
        end
      end
    end)
  end
end
local function AnnoyTrade()
  while getgenv().AnnoyTrade and wait(0.25) do
    pcall(function()
      for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        game:GetService("ReplicatedStorage").Trade:FireServer("SENT", player)
      end
    end)
  end
end
local function CancelTrade()
  while getgenv().CancelTrade and wait(0.25) do
    pcall(function()
      for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        game:GetService("ReplicatedStorage").Trade:FireServer("CANCEL_TRADE", player)
      end
    end)
  end
end
local function KillGun()
  pcall(function()
    for _, player in pairs(game.Players:GetPlayers()) do
      if player ~= eu and player:GetAttribute("Game") == eu:GetAttribute("Game") and player:GetAttribute("Team") ~= eu:GetAttribute("Team") then
        for _, tool in pairs(eu.Character:GetChildren()) do
          if tool:IsA("Tool") then
          tool.kill:FireServer(player, Vector3.new(player.Character.Head.Position))
          end
        end
      end
    end
  end)
end
local function AutoGun()
  while getgenv().AutoGun and wait(0.33) do
    KillGun()
  end
end
local function PullGun()
  while getgenv().PullGun and task.wait(0.25) do
    pcall(function()
      for _, tool in pairs(eu.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("kill") then
          tool.Parent = eu.Character
        end
      end
    end)
  end
end
local function HitBox()
	while getgenv().HitBox and wait() do
	  pcall(function()
		for _, player in pairs(game.Players:GetPlayers()) do
			if player ~= eu and player:GetAttribute("Game") == eu:GetAttribute("Game") and player:GetAttribute("Team") ~= eu:GetAttribute("Team") then
				if player.Character then
					if player.Character:FindFirstChild("HumanoidRootPart") then
						if player.Character.HumanoidRootPart.Size ~= Vector3.new(HitSize, HitSize, HitSize) or player.Character.HumanoidRootPart.Transparency ~= 0.6 then
							player.Character.HumanoidRootPart.Size = Vector3.new(HitSize, HitSize, HitSize)
							player.Character.HumanoidRootPart.Transparency = 0.6
							player.Character.HumanoidRootPart.CanCollide = false
						end
					end
				end
			end
		end
	  end)
	end
	if not getgenv().HitBox then
		for _, player in pairs(game.Players:GetPlayers()) do
			if player ~= game.Players.LocalPlayer then
				if player.Character and game.Players.LocalPlayer.Character then
					if player.Character:FindFirstChild("HumanoidRootPart") then
						if player.Character.HumanoidRootPart.Size ~= Vector3.new(2, 2, 1) or player.Character.HumanoidRootPart.Transparency ~= 0 then
							player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
							player.Character.HumanoidRootPart.Transparency = 0
						end
					end
				end
			end
		end
	end
end
local function PlayerESP()
	while getgenv().PlayerESP and wait(0.33) do
	  pcall(function()
		for _, players in pairs(game.Players:GetPlayers()) do
			local player = players.Character
			if player and player.Parent and players:GetAttribute("Game") == eu:GetAttribute("Game") and players:GetAttribute("Team") ~= eu:GetAttribute("Team") then
				if player ~= game.Players.LocalPlayer.Character then
					if player:FindFirstChild("Highlight") then
						if player.Highlight.Enabled == false then
							player.Highlight.Enabled = true
						end
						if player.Highlight.FillColor ~= CorInocente or player.Highlight.OutlineColor ~= CorInocente then
						  player.Highlight.FillColor = CorInocente
						  player.Highlight.OutlineColor = CorInocente
						end
					else
						local highlight = Instance.new("Highlight")
						highlight.FillColor = CorInocente
						highlight.OutlineColor = CorInocente
						highlight.FillTransparency = 0.6
						highlight.Adornee = player
						highlight.Parent = player
					end
				end
			end
		end
		end)
	end
	if not getgenv().PlayerESP then
		for _, players in pairs(game.Players:GetPlayers()) do
			local player = players.Character
			if player and players:GetAttribute("Game") == eu:GetAttribute("Game") and players:GetAttribute("Team") ~= eu:GetAttribute("Team") and player:FindFirstChild("Highlight") then
				if player.Highlight.Enabled == true then
					player.Highlight.Enabled = false
				end
			end
		end
	end
end
local function GunSound()
  while getgenv().GunSound and  task.wait(Settings.SpamSoundCooldown) do
    pcall(function()
      for _, tool in pairs(eu.Character:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("fire") then
          tool.fire:FireServer()
        end
      end
    end)
  end
end
local function Triggerbot()
    -- Variáveis locais
    local Players = game:GetService("Players")
    local Workspace = game.Workspace
    local LocalPlayer = Players.LocalPlayer
    -- Função principal do Triggerbot
    while getgenv().Triggerbot do
        task.wait(0.01) -- Intervalo para evitar uso excessivo de CPU
        -- Iterar sobre todos os jogadores
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer 
                and player:GetAttribute("Game") == LocalPlayer:GetAttribute("Game")
                and player:GetAttribute("Team") ~= LocalPlayer:GetAttribute("Team") then
                local character = player.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    -- Verificar se o raio atinge o jogador
                    local camera = Workspace.CurrentCamera
                    if camera then
                        local rayOrigin = camera.CFrame.Position
                        local rayDirection = (rootPart.Position - rayOrigin).Unit * 1000
                        local ray = Ray.new(rayOrigin, rayDirection)
                        local hit, _ = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
                        if hit and hit.Parent == rootPart.Parent then
                            -- Iterar sobre as ferramentas do jogador local
                            local localCharacter = LocalPlayer.Character
                            if localCharacter then
                                for _, tool in ipairs(localCharacter:GetChildren()) do
                                    if not IsCooldown 
                                        and tool:IsA("Tool") 
                                        and tool:FindFirstChild("Handle") 
                                        and tool:FindFirstChild("showBeam") 
                                        and tool:FindFirstChild("kill") 
                                        and tool:FindFirstChild("fire") then
                                        local handle = tool.Handle
                                        -- Ativar as funções da ferramenta
                                        tool.fire:FireServer()
                                        tool.showBeam:FireServer(character.HumanoidRootPart.Position, handle.Position, handle)
                                        tool.kill:FireServer(player, Vector3.new(player.Character.Head.Position))
                                        
                                        -- Definir cooldown após o disparo
                                        IsCooldown = true
                                        task.spawn(function()
                                            task.wait(Settings.TriggerbotCooldown) -- Cooldown de 3 segundos
                                            IsCooldown = false
                                        end)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
local function AutoSlash()
  while getgenv().AutoSlash and task.wait(Settings.SlashCooldown) do
    pcall(function()
      for _, tool in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren() or game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Slash") then
          tool.Slash:FireServer()
        end
      end
    end)
  end
end
local function KnifeTrigger()
    while getgenv().KnifeTrigger do
        pcall(function()
            local players = game:GetService("Players"):GetPlayers()
            for _, p in ipairs(players) do
                if p ~= eu and 
                   p:GetAttribute("Game") == eu:GetAttribute("Game") and 
                   p:GetAttribute("Team") ~= eu:GetAttribute("Team") then

                    local targetChar = p.Character
                    local euChar = eu.Character
                    if targetChar and euChar and 
                       targetChar:FindFirstChild("HumanoidRootPart") and 
                       euChar:FindFirstChild("HumanoidRootPart") then

                        local targetPos = targetChar.HumanoidRootPart.Position
                        local euPos = euChar.HumanoidRootPart.Position
                        local canThrow = true

                        if not Settings.IgnoreWalls then
                            local direction = (targetPos - euPos).unit * 500
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {euChar}
                            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                            local rayResult = workspace:Raycast(euPos, direction, rayParams)
                            if rayResult then
                                canThrow = false
                            end
                        end

                        if canThrow then
                            -- Agrupa ferramentas do personagem e da mochila
                            local tools = {}
                            for _, tool in ipairs(euChar:GetChildren()) do
                                table.insert(tools, tool)
                            end

                            for _, tool in ipairs(tools) do
                                if tool:IsA("Tool") and tool:FindFirstChild("Throw") then
                                    local cf = CFrame.new(targetPos)
                                    tool.Throw:FireServer(cf, targetPos, euPos)
                                    if Settings.KnifeMethod == "Single Target" then
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        task.wait(Settings.KnifeCooldown)
    end
end
local function GetTP()
  pcall(function()
    local mouse = eu:GetMouse()
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "Teleport Tool"
    tool.ToolTip = "Equip and click somewhere to teleport - Triangulare"
    -- tool.TextureId = "rbxassetid://17091459839"
    
    tool.Activated:Connect(function()
      local pos = mouse.Hit.Position + Vector3.new(0, 2.5, 0)
      eu.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end)
    
    tool.Parent = eu.Backpack
  end)
end
local function DelTP()
  pcall(function()
    for _, tool in pairs(eu.Character:GetChildren()) do
      if tool:IsA("Tool") and tool.Name == "Teleport Tool" then
        tool:Destroy()
      end
    end
    for _, tool in pairs(eu.Backpack:GetChildren()) do
      if tool:IsA("Tool") and tool.Name == "Teleport Tool" then
        tool:Destroy()
      end
    end
  end)
end
local function AutoTPe()
  while getgenv().AutoTPe and task.wait() do
    pcall(function()
      local function ToolsLoaded()
        local Faca = false
        local Arma = false
        
        for _, tool in pairs(eu.Character:GetChildren()) do
          if not Faca and tool:IsA("Tool") and tool:FindFirstChild("Slash") and tool:FindFirstChild("Throw") then
            Faca = true
          end
        end
        for _, tool in pairs(eu.Backpack:GetChildren()) do
          if not Faca and tool:IsA("Tool") and tool:FindFirstChild("Slash") and tool:FindFirstChild("Throw") then
            Faca = true
          end
        end
        for _, tool in pairs(eu.Character:GetChildren()) do
          if not Arma and tool:IsA("Tool") and tool:FindFirstChild("fire") and tool:FindFirstChild("showBeam") then
            Arma = true
          end
        end
        for _, tool in pairs(eu.Backpack:GetChildren()) do
          if not Arma and tool:IsA("Tool") and tool:FindFirstChild("fire") and tool:FindFirstChild("showBeam") then
            Arma = true
          end
        end
        
        if Faca and Arma then
          return true
        end
        return false
      end
      if Settings.Teleport == "Tools Load" and (eu.Backpack:FindFirstChild("Teleport Tool") or eu.Character:FindFirstChild("Teleport Tool")) and not ToolsLoaded() then
        DelTP()
      elseif not eu.Backpack:FindFirstChild("Teleport Tool") and not eu.Character:FindFirstChild("Teleport Tool") then
        if Settings.Teleport == "Tools Load" and ToolsLoaded() then
          GetTP()
        elseif Settings.Teleport == "Everytime" then
          GetTP()
        end
      end
    end)
  end
end

-- Tabs
local Tabs = {
  Gun = Window:Tab({ Title = "Gun", Icon = "skull"}),
  Knife = Window:Tab({ Title = "Knife", Icon = "sword"}),
  Teleport = Window:Tab({ Title = "Teleport", Icon = "shell"})
}
Window:SelectTab(1)

-- Gun
Tabs.Gun:Section({ Title = "Undetectable" })
Tabs.Gun:Toggle({
  Title = "Triggerbot",
  Desc = "Auto kill enemies in sight.",
  Value = false,
  Callback = function(state)
    getgenv().Triggerbot = state
    Triggerbot()
  end
})
Tabs.Gun:Input({
  Title = "Shoot Cooldown",
  Value = "3",
  Placeholder = "In seconds, ex.: 3",
  Callback = function(input)
    Settings.TriggerbotCooldown = tonumber(input) or 1
  end
})
Tabs.Gun:Section({ Title = "Blatant" })
Tabs.Gun:Button({
  Title = "Kill All",
  Desc = "Kills everyone using your gun.",
  Callback = function()
    KillGun()
  end
})
Tabs.Gun:Toggle({
  Title = "Auto Kill",
  Desc = "Auto kills everyone.",
  Value = false,
  Callback = function(state)
    getgenv().AutoGun = state
    AutoGun()
  end
})
Tabs.Gun:Toggle({
  Title = "Auto Equip Gun",
  Desc = "Automatically equips your gun.",
  Value = false,
  Callback = function(state)
    getgenv().PullGun = state
    PullGun()
  end
})
Tabs.Gun:Section({ Title = "Misc" })
Tabs.Gun:Toggle({
  Title = "Spam Sound (FE)",
  Desc = "Automatically spams the shoot sound.",
  Value = false,
  Callback = function(state)
    getgenv().GunSound = state
    GunSound()
  end
})
Tabs.Gun:Input({
  Title = "Sound Cooldown",
  Value = "0.2",
  Placeholder = "In seconds, ex.: 0.2",
  Callback = function(input)
    Settings.SpamSoundCooldown= tonumber(input) or 1
  end
})

-- Knife
Tabs.Knife:Section({ Title = "Legit" })
Tabs.Knife:Toggle({
  Title = "Auto Slash",
  Desc = "Auto use your knife.",
  Value = false,
  Callback = function(state)
    getgenv().AutoSlash = state
    AutoSlash()
  end
})
Tabs.Knife:Input({
  Title = "Slash Cooldown",
  Value = "0.5",
  Placeholder = "In seconds, ex.: 0.5",
  Callback = function(input)
    Settings.SlashCooldown = tonumber(input) or 1
  end
})
Tabs.Knife:Section({ Title = "Blatant" })
Tabs.Knife:Toggle({
  Title = "Auto Equip Knife",
  Desc = "Automatically equips your knife.",
  Value = false,
  Callback = function(state)
    getgenv().EquipKnife = state
    EquipKnife()
  end
})

-- Teleport
Tabs.Teleport:Section({ Title = "Teleport to Map" })
Tabs.Teleport:Dropdown({
  Title = "Selected Item",
  Values = { "Lobby", "Factory", "House", "Mansion", "MilBase" },
  Value = Settings.Selected,
  Callback = function(option)
    Settings.Selected = option
  end
})
Tabs.Teleport:Button({
  Title = "Teleport",
  Desc = "Teleports you to the selected map.",
  Callback = function()
    Teleport()
  end
})
Tabs.Teleport:Section({ Title = "Teleport Tool" })
Tabs.Teleport:Button({
  Title = "Get Teleport Tool",
  Desc = "Gives you the teleport tool.",
  Callback = function()
    GetTP()
  end
})
Tabs.Teleport:Button({
  Title = "Remove Tool",
  Desc = "Removes the teleport tool.",
  Callback = function()
    DelTP()
  end
})
Tabs.teleport:Toggle({
  Title = "Permanent Tool",
  Desc = "Auto get teleport tool.",
  Value = false,
  Callback = function(state)
    getgenv().AutoTPe = state
    AutoTPe()
  end
})
Tabs.Teleport:Dropdown({
  Title = "Get Tool When",
  Values = { "Tools Load", "Everytime" },
  Value = Settings.Teleport,
  Callback = function(option)
    Settings.Teleport = option
  end
})