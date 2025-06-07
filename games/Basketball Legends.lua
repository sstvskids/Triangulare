local Tabs = {
  Match = Window:Tab({ Title = "Match", Icon = "volleyball" }),
  Player = Window:Tab({ Title = "Player", Icon = "user" }),
}
Window:SelectTab(1)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local playerTeam = LocalPlayer.Team
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local humanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local bar = LocalPlayer.PlayerGui.Visual.Shooting.Bar
local overlay = bar.Overlay
local text = LocalPlayer.PlayerGui.Visual.ShotInfo.Timing.Title
local isActive = false

Tabs.Match:Section({ Title = "Timing" })
Tabs.Match:Toggle({
    Title = "All Perfect",
    Desc = "Makes your shots all green.",
    Value = false,
    Flag = "Toggle1",
    Callback = function(Value)
        isActive = Value
    end,
})

-- AUTO GREEN
local function activatePerfect()
    bar.Size = UDim2.new(1, 0, 1, 0)
    overlay.Size = UDim2.new(1, 0, 1, 0)
    text.Text = "PERFECT"
    text.TextColor3 = Color3.fromRGB(0, 255, 0)
end

bar:GetPropertyChangedSignal("Size"):Connect(function()
    if isActive then
        bar.Size = UDim2.new(1, 0, 1, 0)
        overlay.Size = UDim2.new(1, 0, 1, 0)
    end
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if isActive and input.KeyCode == Enum.KeyCode.E then
        activatePerfect()
    end
end)

local autoGrabEnabled = false
local lastPosition = nil

local player = game:GetService("Players").LocalPlayer
local Workspace = game:GetService("Workspace")
local Ground = Workspace:WaitForChild("Game"):WaitForChild("Court"):WaitForChild("Ground")

-- GRAB BALL
local function grabBall()
    local char = player.Character or player.CharacterAdded:Wait()
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end

    local messageLabel = player.PlayerGui.Visual.MessageBar.Title
    local messageText = messageLabel.Text:lower()
    
    if messageText:find("scored") and messageLabel.TextTransparency == 0 then
        return
    end

    local hrp = char.HumanoidRootPart
    local humanoid = char.Humanoid
    local ball = Workspace:FindFirstChild("Basketball")

    if ball and ball:IsA("BasePart") then
        lastPosition = hrp.Position
        humanoid.PlatformStand = true
        hrp.CFrame = ball.CFrame + Vector3.new(0, 3, 0)
        task.wait(0.2)
        hrp.CFrame = CFrame.new(lastPosition)
        humanoid.PlatformStand = false
    end
end

Tabs.Match:Section({ Title = "Ball" })
Tabs.Match:Button({
    Title = "Grab Ball",
    Desc = "Grabs the ball and teleports you back to your old position. (Needs the ball to be on the ground)",
    Callback = function()
        grabBall()
    end,
})

Tabs.Match:Toggle({
    Title = "Auto Grab Ball",
    Desc = "Automatically grabs the ball and teleports you back to your old position. (Needs the ball to be on the ground)",
    Value = false,
    Callback = function(Value)
        autoGrabEnabled = Value
    end,
})

Workspace.ChildAdded:Connect(function(child)
    if child.Name == "Basketball" and child:IsA("BasePart") then
        child.Touched:Connect(function(hit)
            if autoGrabEnabled and hit == Ground then
                task.wait(0.05)
                grabBall()
            end
        end)
    end
end)

local isFollowing = false
local nearestPlayer = nil

Tabs.Match:Section({ Title = "Defense" })
Tabs.Match:Keybind({
    Title = "Auto Guard",
    Desc = "Follows the nearest enemy player by moveTo.",
    Key = Enum.KeyCode.B,
    Callback = function()
        isFollowing = not isFollowing
    end,
})

-- AUTO GUARD
local function findNearestPlayer()
    local shortestDistance = math.huge
    nearestPlayer = nil

    for _, player in ipairs(Players:GetPlayers()) do
        if
            player ~= LocalPlayer and
            player.Character and
            player.Character:FindFirstChild("HumanoidRootPart") and
            player.Team and playerTeam and
            player.Team.Name ~= playerTeam.Name and
            player.TeamColor.Name ~= playerTeam.TeamColor.Name
        then
            local targetHRP = player.Character.HumanoidRootPart
            local distance = (targetHRP.Position - humanoidRootPart.Position).Magnitude

            if distance < shortestDistance then
                shortestDistance = distance
                nearestPlayer = player
            end
        end
    end
end

local function followPlayer(player)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local targetHRP = player.Character.HumanoidRootPart
        local lookDirection = targetHRP.CFrame.LookVector
        local offsetDistance = 2

        local desiredPosition = targetHRP.Position - lookDirection * offsetDistance

        Humanoid:MoveTo(desiredPosition)
    end
end

RunService.Heartbeat:Connect(function()
    if isFollowing then
        findNearestPlayer()
        followPlayer(nearestPlayer)
    end
end)

Tabs.Match:Toggle({
    Title = "Always Guard (Not Recommended)",
    Desc = "Always keeps the guard position right character.",
    Value = false,
    Callback = function(Value)
        if Value then
            spawn(function()
                while true do
                    ReplicatedStorage.Packages.Knit.Services.ControlService.RE.Guard:FireServer(true)
                    wait(0.7)
                end
            end)
        end
    end,
})

local speed = 0.01
local speedEnabled = false

Tabs.Player:Section({ Title = "Player Speed" })
Tabs.Player:Toggle({
    Title = "Speed Boost",
    Desc = "Increases the player speed.",
    Value = false,
    Flag = "SpeedToggle",
    Callback = function(Value)
        speedEnabled = Value
    end,
})

Tabs.Player:Slider({
    Title = "WalkSpeed",
    Desc = "Adjust Player Speed",
    Value = {
        Min = 1,
        Max = 5,
        Default = 1,
    },
    Callback = function(Value)
        speed = Value / 100
    end,
})

-- SPEED VALUE CHANGER
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if speedEnabled and char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local moveDir = char.Humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (moveDir * speed)
        end
    end
end)
