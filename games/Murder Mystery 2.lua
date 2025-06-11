local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "UI Title",
    Icon = "door-open",
    Author = "Example UI",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    Background = "",
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            print("clicked")
        end,
    },
})

local Tabs = {
  Visual = Window:Tab({ Title = "Visual", Icon = "eye" }),
  Sheriff = Window:Tab({ Title = "Sheriff", Icon = "shield-plus" }),
  Murderer = Window:Tab({ Title = "Murderer", Icon = "sword" }),
  Auto = Window:Tab({ Title = "Auto", Icon = "bot" }),
  Player = Window:Tab({ Title = "Player", Icon = "user-round" }),
  Teleport = Window:Tab({ Title = "Teleport", Icon = "shell" }),
  Round = Window:Tab({ Title = "Round", Icon = "waves" }),
}
Window:SelectTab(1)

--//--// VISUAL TAB \\--\\--

getgenv().PlayerESPEnabled = false
getgenv().SheriffESPEnabled = false
getgenv().MurdererESPEnabled = false
getgenv().GunESPEnabled = false
getgenv().CoinESPEnabled = false

local RoleColors = {
    Innocent = Color3.fromRGB(0, 255, 0),
    Murderer = Color3.fromRGB(255, 0, 0),
    Sheriff = Color3.fromRGB(0, 0, 255),
    Hero = Color3.fromRGB(255, 255, 0),
    Unknown = Color3.fromRGB(255, 255, 255)
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

Tabs.Visual:Section({ Title = "ESP" })

--// PLAYER ESP \\--

Tabs.Visual:Toggle({
    Title = "Player ESP",
    Desc = "Shows ESP for all players regardless of role",
    Default = false,
    Callback = function(state)
        getgenv().PlayerESPEnabled = state
    end
})

Tabs.Visual:Toggle({
    Title = "Sheriff ESP",
    Desc = "Only shows ESP for the sheriff",
    Default = false,
    Callback = function(state)
        getgenv().SheriffESPEnabled = state
    end
})

Tabs.Visual:Toggle({
    Title = "Murderer ESP",
    Desc = "Only shows ESP for the murderer",
    Default = false,
    Callback = function(state)
        getgenv().MurdererESPEnabled = state
    end
})

local function createBillboard(nameText, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RoleBillboard"
    billboard.Size = UDim2.new(0, 90, 0, 21)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "TextLabel"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = nameText
    textLabel.TextColor3 = color
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.Gotham
    textLabel.Parent = billboard

    return billboard
end

local function ShouldShowESPFor(role)
    if getgenv().PlayerESPEnabled then return true end
    if getgenv().SheriffESPEnabled and role == "Sheriff" then return true end
    if getgenv().MurdererESPEnabled and role == "Murderer" then return true end
    return false
end

local function updateRoles()
    local success, playerData = pcall(function()
        return ReplicatedStorage.Remotes.Gameplay.GetCurrentPlayerData:InvokeServer()
    end)
    if not success or typeof(playerData) ~= "table" then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local data = playerData[player.Name]
            if data and not data.Dead then
                local role = data.Role or "Unknown"
                local color = RoleColors[role] or RoleColors.Unknown

                local highlight = player.Character:FindFirstChild("RoleESP")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "RoleESP"
                    highlight.FillTransparency = 0.75
                    highlight.OutlineTransparency = 0.2
                    highlight.Adornee = player.Character
                    highlight.Parent = player.Character
                end
                highlight.FillColor = color

                local head = player.Character.Head
                local billboard = head:FindFirstChild("RoleBillboard")
                if not billboard then
                    billboard = createBillboard(player.DisplayName, color)
                    billboard.Adornee = head
                    billboard.Parent = head
                else
                    local label = billboard:FindFirstChild("TextLabel")
                    if label then
                        label.TextColor3 = color
                        label.Text = player.DisplayName
                    end
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    local success, playerData = pcall(function()
        return ReplicatedStorage.Remotes.Gameplay.GetCurrentPlayerData:InvokeServer()
    end)
    if not success or typeof(playerData) ~= "table" then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local data = playerData[player.Name]
            local role = data and data.Role or "Unknown"
            local alive = data and not data.Dead
            local show = alive and ShouldShowESPFor(role)

            local highlight = player.Character:FindFirstChild("RoleESP")
            if highlight then
                highlight.Enabled = show
            end

            local head = player.Character.Head
            local billboard = head:FindFirstChild("RoleBillboard")
            if billboard then
                billboard.Enabled = show

                if show then
                    local dist = (camera.CFrame.Position - head.Position).Magnitude
                    local maxDistance = 300
                    if dist > maxDistance then
                        billboard.Enabled = false
                    else
                        local alpha = 1
                        if dist > 150 then
                            alpha = 1 - ((dist - 150) / (maxDistance - 150))
                        end

                        local label = billboard:FindFirstChild("TextLabel")
                        if label then
                            label.TextTransparency = 1 - alpha
                            label.TextStrokeTransparency = 0.5 + (1 - alpha) * 0.5
                        end
                    end
                end
            end
        end
    end
end)

local updateInterval = 0.5
local lastUpdate = 0

RunService.RenderStepped:Connect(function()
    if tick() - lastUpdate >= updateInterval then
        pcall(updateRoles)
        lastUpdate = tick()
    end
end)

--// GUN ESP \\--

local GunName = "GunDrop"
local hlName = "GunHighlight"
local bbName = "GunBillboard"
local hlColor = Color3.fromRGB(255, 255, 0)

local function createGunESP(part)
	local coinHL = Workspace:FindFirstChild("CoinHighlight_" .. part:GetDebugId())
	if coinHL then
		coinHL:Destroy()
	end

	if not part:FindFirstChild(hlName) then
		local highlight = Instance.new("Highlight")
		highlight.Name = hlName
		highlight.FillColor = hlColor
		highlight.OutlineColor = hlColor
		highlight.FillTransparency = 0.3
		highlight.OutlineTransparency = 0.1
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Adornee = part
		highlight.Parent = part
	end

	if not part:FindFirstChild(bbName) then
		local billboard = Instance.new("BillboardGui")
		billboard.Name = bbName
		billboard.Size = UDim2.new(0, 90, 0, 21)
		billboard.StudsOffset = Vector3.new(0, 2, 0)
		billboard.AlwaysOnTop = true
		billboard.Adornee = part
		billboard.Parent = part

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = "GUN DROP"
		label.TextColor3 = hlColor
		label.TextStrokeTransparency = 0.5
		label.TextScaled = true
		label.Font = Enum.Font.SourceSansBold
		label.Parent = billboard
	end
end

local function scanGunDrops()
	for _, model in ipairs(Workspace:GetChildren()) do
		if model:IsA("Model") then
			for _, part in ipairs(model:GetChildren()) do
				if part:IsA("Part") and part.Name == GunName then
					createGunESP(part)
					local hl = part:FindFirstChild(hlName)
					if hl then hl.Enabled = getgenv().GunESPEnabled end

					local bb = part:FindFirstChild(bbName)
					if bb then bb.Enabled = getgenv().GunESPEnabled end
				end
			end
		end
	end
end

Workspace.ChildAdded:Connect(function(model)
	if model:IsA("Model") then
		model.ChildAdded:Connect(function(part)
			if part:IsA("Part") and part.Name == GunName then
				createGunESP(part)
				local hl = part:FindFirstChild(hlName)
				if hl then hl.Enabled = getgenv().GunESPEnabled end

				local bb = part:FindFirstChild(bbName)
				if bb then bb.Enabled = getgenv().GunESPEnabled end
			end
		end)
	end
end)

RunService.RenderStepped:Connect(function()
	if not getgenv().GunESPEnabled then return end

	for _, model in ipairs(Workspace:GetChildren()) do
		if model:IsA("Model") then
			for _, part in ipairs(model:GetChildren()) do
				if part:IsA("Part") and part.Name == GunName then
					local billboard = part:FindFirstChild(bbName)
					if billboard then
						local dist = (camera.CFrame.Position - part.Position).Magnitude
						local maxDistance = 300
						billboard.Enabled = dist <= maxDistance

						if dist <= maxDistance then
							local alpha = dist > 150 and (1 - (dist - 150) / 150) or 1
							local label = billboard:FindFirstChildOfClass("TextLabel")
							if label then
								label.TextTransparency = 1 - alpha
								label.TextStrokeTransparency = 0.5 + (1 - alpha) * 0.5
							end
						end
					end

					local hl = part:FindFirstChild(hlName)
					if hl then hl.Enabled = true end
				end
			end
		end
	end
end)

Tabs.Visual:Toggle({
	Title = "Gun ESP",
	Desc = "Shows ESP for the Gun Drop",
	Default = false,
	Callback = function(state)
		getgenv().GunESPEnabled = state
		scanGunDrops()
	end
})

--// COIN ESP \\--

local hlColor = Color3.fromRGB(245, 205, 48)
local coinContainer = Workspace:FindFirstChild("CoinContainer") or Workspace

local function createHLS(part)
	if not getgenv().CoinESPEnabled then return end
	if part.Name == "GunDrop" then return end

	local id = "CoinHighlight_" .. part:GetDebugId()
	if Workspace:FindFirstChild(id) then return end

	local adorneeTarget = part.Parent:IsA("Model") and part.Parent or part

	local highlight = Instance.new("Highlight")
	highlight.Name = id
	highlight.FillColor = hlColor
	highlight.OutlineColor = hlColor
	highlight.FillTransparency = 0.8
	highlight.OutlineTransparency = 0.1
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Adornee = adorneeTarget
	highlight.Parent = Workspace
end

local function scanForCoins()
	for _, child in ipairs(coinContainer:GetChildren()) do
		if child:IsA("Part") and child.Name == "Coin_Server" then
			createHLS(child)
		elseif child:IsA("Model") then
			for _, inner in ipairs(child:GetChildren()) do
				if inner:IsA("Part") and inner.Name == "Coin_Server" then
					createHLS(inner)
				end
			end
		end
	end
end

local function updateCoinESPState()
	for _, obj in ipairs(Workspace:GetChildren()) do
		if obj:IsA("Highlight") and obj.Name:match("^CoinHighlight_") then
			if getgenv().CoinESPEnabled then
				obj.Enabled = true
			else
				obj:Destroy()
			end
		end
	end
end
scanForCoins()

Workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("Part") and obj.Name == "Coin_Server" then
		createHLS(obj)
	end
end)

local lastUpdate = 0
RunService.RenderStepped:Connect(function()
	local now = tick()
	if now - lastUpdate >= 0.5 then
		lastUpdate = now
		if getgenv().CoinESPEnabled then
			scanForCoins()
		end
	end
end)

Tabs.Visual:Toggle({
    Title = "Coin ESP",
    Desc = "Shows ESP for the Coins",
    Default = false,
    Callback = function(state)
        getgenv().CoinESPEnabled = state
        updateCoinESPState()
    end
})

--//--// SHERIFF TAB \\--\\--

Tabs.Sheriff:Section({ Title = "Gun" })

--// SHOOT MURDERER \\--

local function findGun()
    local function findIn(container)
        local gun = container:FindFirstChild("Gun")
        if gun and gun:FindFirstChild("KnifeLocal") then
            return gun
        end
        return nil
    end
    return findIn(localPlayer.Backpack) or findIn(localPlayer.Character)
end

local function hasKnife(player)
    local function hasIn(container)
        local knife = container:FindFirstChild("Knife")
        return knife and knife:IsA("Tool")
    end
    return hasIn(player.Backpack) or hasIn(player.Character)
end

local function shootMurderer()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if hasKnife(player) then
                local humanoidPos = player.Character.HumanoidRootPart.Position
                local targetVector = vector.create(humanoidPos.X, humanoidPos.Y, humanoidPos.Z)

                local gun = findGun()
                if not gun then return end

                local remote = gun:WaitForChild("KnifeLocal"):WaitForChild("CreateBeam"):WaitForChild("RemoteFunction")
                local args = {
                    1,
                    targetVector,
                    "AH2"
                }
                remote:InvokeServer(unpack(args))
                break
            end
        end
    end
end

local function tpToMurderer()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if hasKnife(player) then
                local targetHRP = player.Character.HumanoidRootPart
                local targetCFrame = targetHRP.CFrame

                local behindCFrame = targetCFrame * CFrame.new(0, 0, 3)
                local myChar = localPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    myChar.HumanoidRootPart.CFrame = behindCFrame
                end

                return true
            end
        end
    end
    return false
end

local debounce = false

Tabs.Sheriff:Keybind({
    Title = "Shoot Murderer",
    Desc = "Keybind",
    Value = "K",
    Callback = function(v)
        if debounce then return end
        debounce = true
        shootMurderer()
        task.delay(1, function()
            debounce = false
        end)
    end
})

Tabs.Sheriff:Keybind({
    Title = "Shoot Murderer (Teleport)",
    Desc = "Keybind",
    Value = "J",
    Callback = function(v)
        if debounce then return end
        debounce = true

        local success = tpToMurderer()
        if success then
            task.delay(0.1, function()
                shootMurderer()
            end)
        end

        task.delay(1, function()
            debounce = false
        end)
    end
})