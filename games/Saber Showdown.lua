-- Services and Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Remotes = game:GetService("ReplicatedStorage").LightsaberRemotes
local swingEnabled = false
local autoBlockEnabled = false
local noSlapConnection
local alwaysWalkThread
local killAllActive = false
local godModeActive = false

-- Function Definitions
local function updateAnimations()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                if swingEnabled then
                    track:AdjustSpeed(30)
                end
            end
        end
    end
end

local function setupCharacter()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator and swingEnabled then
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            track:AdjustSpeed(30)
        end
    end
    if animator then
        animator.AnimationPlayed:Connect(function(track)
            if swingEnabled then
                track:AdjustSpeed(30)
            end
        end)
    end
end

local function speedSwingCallback(Value)
    swingEnabled = Value
    updateAnimations()
end

local function autoPerfectBlockCallback(Value)
    autoBlockEnabled = Value

        local autoPB_RenderConnection
        local autoPB_HeartbeatConnection
        local charConn

        if Value then
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")

            local LocalPlayer = Players.LocalPlayer
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local HRP = Character:WaitForChild("HumanoidRootPart")

            local tracked = {}
            local activeAnimations = {}

            local BlockDirRemote = ReplicatedStorage:WaitForChild("LightsaberRemotes"):WaitForChild("UpdateBlockDirection")

            local BlockDirections = {
                -- Right zone
                [12718502938] = {{1,13,2},1}, [12625839385] = {{1,13,2},1}, [13564880014] = {{1,13,2},1},
                [12734285787] = {{1,13,2},1}, [13453391958] = {{1,13,2},1}, [14167593691] = {{1,13,2},1},
                [13783202348] = {{1,13,2},1}, [13540434005] = {{1,13,2},1}, [15563343338] = {{1,13,2},1},
                [12734468945] = {{1,13,2},1}, [13304774028] = {{1,13,2},1}, [17372041039] = {{1,13,2},1},
                [14329314419] = {{1,13,2},1},

                -- TopRight zone
                [12718504431] = {{2,3,4},8}, [12625848489] = {{2,3,4},8}, [13565725049] = {{2,3,4},8},
                [12734288411] = {{2,3,4},8}, [13453386109] = {{2,3,4},8}, [14167584256] = {{2,3,4},8},
                [13783395464] = {{2,3,4},8}, [13540430226] = {{2,3,4},8}, [15563344914] = {{2,3,4},8},
                [12734471179] = {{2,3,4},8}, [13304781510] = {{2,3,4},8}, [17566657634] = {{2,3,4},8},
                [14329308611] = {{2,3,4},8},

                -- Overhead zone
                [12718501806] = {{4,5,6},3}, [12625841878] = {{4,5,6},3}, [13569466383] = {{4,5,6},3},
                [12734284724] = {{4,5,6},3}, [13453390619] = {{4,5,6},3}, [14167591876] = {{4,5,6},3},
                [13783497920] = {{4,5,6},3}, [15563343960] = {{4,5,6},3}, [12734468200] = {{4,5,6},3},
                [13306520673] = {{4,5,6},3}, [17372039079] = {{4,5,6},3}, [14329312618] = {{4,5,6},3},

                -- TopLeft zone
                [12718500875] = {{6,7,8},6}, [12625853257] = {{6,7,8},6}, [13569308951] = {{6,7,8},6},
                [12734283312] = {{6,7,8},6}, [13453385141] = {{6,7,8},6}, [14167502905] = {{6,7,8},6},
                [13781663786] = {{6,7,8},6}, [13540431378] = {{6,7,8},6}, [15563346027] = {{6,7,8},6},
                [12734467243] = {{6,7,8},6}, [13306517941] = {{6,7,8},6}, [17372038496] = {{6,7,8},6},
                [14329161930] = {{6,7,8},6},

                -- Left zone
                [12718483984] = {{8,9,10},5}, [12625843823] = {{8,9,10},5}, [13568360345] = {{8,9,10},5},
                [12734279804] = {{8,9,10},5}, [13453387454] = {{8,9,10},5}, [14167592684] = {{8,9,10},5},
                [13781621647] = {{8,9,10},5}, [15563342470] = {{8,9,10},5}, [12734465074] = {{8,9,10},5},
                [13304777249] = {{8,9,10},5}, [17372037456] = {{8,9,10},5}, [14355055371] = {{8,9,10},5},

                -- BottomLeft zone
                [12718486016] = {{10,11},4}, [12625846167] = {{10,11},4}, [13568907848] = {{10,11},4},
                [12734282359] = {{10,11},4}, [13453382299] = {{10,11},4}, [14167590501] = {{10,11},4},
                [13781667793] = {{10,11},4}, [15564066873] = {{10,11},4}, [12734466257] = {{10,11},4},
                [13304786458] = {{10,11},4}, [17372036678] = {{10,11},4}, [14329310837] = {{10,11},4},

                -- BottomRight zone
                [12718503706] = {{12,13},2}, [12625851115] = {{12,13},2}, [13566518265] = {{12,13},2},
                [12734286808] = {{12,13},2}, [13453383921] = {{12,13},2}, [14167585544] = {{12,13},2},
                [13783293417] = {{12,13},2}, [15563346564] = {{12,13},2}, [12734470075] = {{12,13},2},
                [13304788013] = {{12,13},2}, [17566667400] = {{12,13},2}, [14329160019] = {{12,13},2},
            }

            local function trackAnimator(animator, model)
                if tracked[model] then return end
                tracked[model] = true

                animator.AnimationPlayed:Connect(function(track)
                    local animId = tonumber(track.Animation.AnimationId:match("%d+$"))
                    local data = BlockDirections[animId]

                    if data and HRP and model:FindFirstChild("HumanoidRootPart") then
                        local targetHRP = model.HumanoidRootPart
                        local distance = (HRP.Position - targetHRP.Position).Magnitude

                        if distance <= 10 then
                            activeAnimations[track] = data[1]
                        end
                    end
                end)
            end

            local function handleModel(model)
                if not model:IsA("Model") or model == Character then return end
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Died:Connect(function()
                        tracked[model] = nil
                    end)
                    local animator = humanoid:FindFirstChildWhichIsA("Animator")
                    if animator then
                        trackAnimator(animator, model)
                    end
                end
            end

            local function bindCharacter(c)
                Character = c
                HRP = c:WaitForChild("HumanoidRootPart")
                tracked = {}
                activeAnimations = {}
            end

            charConn = LocalPlayer.CharacterAdded:Connect(bindCharacter)

            autoPB_RenderConnection = RunService.RenderStepped:Connect(function()
                for track, dirs in pairs(activeAnimations) do
                    if track.IsPlaying then
                        for _, dir in ipairs(dirs) do
                            BlockDirRemote:FireServer(dir)
                        end
                    else
                        activeAnimations[track] = nil
                    end
                end
            end)

            autoPB_HeartbeatConnection = RunService.Heartbeat:Connect(function()
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        handleModel(player.Character)
                    end
                end

                local charFolder = workspace:FindFirstChild("Characters")
                if charFolder then
                    for _, model in ipairs(charFolder:GetChildren()) do
                        handleModel(model)
                    end
                end
            end)

        else
            if autoPB_RenderConnection then
                autoPB_RenderConnection:Disconnect()
                autoPB_RenderConnection = nil
            end
            if autoPB_HeartbeatConnection then
                autoPB_HeartbeatConnection:Disconnect()
                autoPB_HeartbeatConnection = nil
            end
            if charConn then
                charConn:Disconnect()
                charConn = nil
            end
        end
    end

local function noSlapCallback(Value)
    noSlapEnabled = Value

        if Value then
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")

            local LocalPlayer = Players.LocalPlayer
            local Character, HumanoidRootPart

            local function setupCharacter(char)
                Character = char
                HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
            end

            LocalPlayer.CharacterAdded:Connect(setupCharacter)
            if LocalPlayer.Character then
                setupCharacter(LocalPlayer.Character)
            else
                LocalPlayer.CharacterAdded:Wait()
            end

            local BlockRemote    = Remotes:WaitForChild("Block")
            local FinishSwing    = Remotes:WaitForChild("FinishSwingNoBounce")
            local BlockSlap      = Remotes:WaitForChild("BlockSlap")
            local SwingRemote    = Remotes:WaitForChild("Swing")
            local OnHitRemote    = Remotes:WaitForChild("OnHit")
            local tracked = {}
            local checkInterval = 0.01
            local lastCheck = 0

            local function trackAnimator(animator, model)
                if tracked[model] then return end
                tracked[model] = true
            
                animator.AnimationPlayed:Connect(function(track)
                    local animId = track.Animation.AnimationId:match("%d+$")
                    if animId == "12625891544" or animId == "12625897944" or animId == "12625899752" then
                        local enemyHRP = model:FindFirstChild("HumanoidRootPart")
                        if enemyHRP and HumanoidRootPart then
                            local dist = (enemyHRP.Position - HumanoidRootPart.Position).Magnitude
                            if dist <= 7 then
                                BlockSlap:FireServer()
                                BlockRemote:FireServer()
                                SwingRemote:FireServer()
                                OnHitRemote:FireServer(model)
                                FinishSwing:FireServer()
                            end
                        end
                    end
                end)
            end

            local function checkNearbyCharacters()
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local char = player.Character
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp and HumanoidRootPart and (hrp.Position - HumanoidRootPart.Position).Magnitude <= 20 then
                            local humanoid = char:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                local animator = humanoid:FindFirstChildOfClass("Animator")
                                if animator then
                                    trackAnimator(animator, char)
                                end
                            end
                        end
                    end
                end
            end

            noSlapConnection = RunService.RenderStepped:Connect(function()
                if not HumanoidRootPart then return end
                local now = tick()
                if now - lastCheck >= checkInterval then
                    lastCheck = now
                    checkNearbyCharacters()
                end
            end)
        else
            if noSlapConnection then
                noSlapConnection:Disconnect()
                noSlapConnection = nil
            end
        end
end

local function invisibleWalkCallback(Value)
    alwaysWalkEnabled = Value

        if alwaysWalkThread then
            alwaysWalkThread:Disconnect()
            alwaysWalkThread = nil
        end

        if Value then
            local Players = game:GetService("Players")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local player = Players.LocalPlayer

            local function getRemotes()
                local remotes = ReplicatedStorage:WaitForChild("LightsaberRemotes", 10)
                local walk = remotes and remotes:FindFirstChild("Walk")
                return walk
            end

            local function startWalkLoop()
                return game:GetService("RunService").Heartbeat:Connect(function()
                    local char = player.Character
                    local walkRemote = getRemotes()
                    
                    if walkRemote and char and char:FindFirstChild("HumanoidRootPart") then
                        pcall(function()
                            walkRemote:FireServer()
                        end)
                    end
                end)
            end

            alwaysWalkThread = startWalkLoop()
        end
end

local function walkSpeedSliderCallback(val)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = val
    end
end

local function jumpPowerSliderCallback(val)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.JumpPower = val
    end
end

local function GetPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(names, player.Name)
    end
    return names
end

local function teleportToPlayerButton()
    local targetPlayer = Players:FindFirstChild(SelectedPlayer)
    if targetPlayer and targetPlayer.Character and LocalPlayer.Character then
        local targetCFrame = targetPlayer.Character:GetPivot()
        LocalPlayer.Character:PivotTo(targetCFrame)
    else
        warn("Teleport Failed: Cannot find the selected player or character.")
    end
end

local function flingPlayerButton()
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character
    local targetPlayer = Players:FindFirstChild(SelectedPlayer2)
    local targetChar = targetPlayer and targetPlayer.Character

    if not (character and targetChar) then
        warn("Fling Failed: Cannot find characters.")
        return
    end

    local myHRP = character:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not (myHRP and targetHRP) then
        warn("Fling Failed: Missing HumanoidRootPart.")
        return
    end

    -- YEET
    local existingThrust = myHRP:FindFirstChild("YeetForce")
    if existingThrust then
        existingThrust:Destroy()
    end

    local thrust = Instance.new("BodyThrust")
    thrust.Name = "YeetForce"
    thrust.Force = Vector3.new(99999, 99999, 99999)
    thrust.Parent = myHRP

    task.spawn(function()
        while targetChar:FindFirstChild("Head") and character:FindFirstChild("HumanoidRootPart") do
            local offset = targetHRP.CFrame.LookVector * 1 + Vector3.new(0, 1, 0)
            myHRP.CFrame = CFrame.lookAt(targetHRP.Position + offset, targetHRP.Position)

            thrust.Location = myHRP.Position

            task.wait(0.03)
        end

        if thrust then
            thrust:Destroy()
        end
    end)
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function teleportToPosition(positionCFrame)
    local root = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart
    if not root then
        LocalPlayer.CharacterAdded:Wait()
        root = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    end
    local orientation = root.CFrame - root.CFrame.Position
    root.CFrame = CFrame.new(positionCFrame.Position) * orientation
end

local function teleportToPlayer(inputText)
    local targetPlayer
    local inputLower = inputText:lower()
    if inputLower == "random" then
        local list = Players:GetPlayers()
        if #list > 1 then
            repeat
                targetPlayer = list[math.random(#list)]
            until targetPlayer ~= LocalPlayer
        end
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if p.Name:lower():find(inputLower,1,true) or p.DisplayName:lower():find(inputLower,1,true) then
                    targetPlayer = p
                    break
                end
            end
        end
    end
    if not targetPlayer then return end
local char = targetPlayer.Character
if char then
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    while not rootPart do
        local root = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart or LocalPlayer.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")
        local y = root.Position.Y
        if y >= 4967 then
            teleportToPosition(CFrame.new(-12, 0, 1))
        else
            teleportToPosition(CFrame.new(-12, 5200, 1))
        end
        game:GetService("RunService").Heartbeat:Wait()
        char = targetPlayer.Character
        rootPart = char and char:FindFirstChild("HumanoidRootPart")
    end
    if rootPart then
        teleportToPosition(rootPart.CFrame * CFrame.new(0, 0, -2))
    end
end

end

local function SwingSaber(targetCharacter)
    if not targetCharacter then return end
    local args1 = {nil, 1, nil, nil}
    Remotes:WaitForChild("Attack"):FireServer(unpack(args1))
    Remotes:WaitForChild("Swing"):FireServer()
    Remotes:WaitForChild("OnHit"):FireServer(targetCharacter)
    Remotes:WaitForChild("FinishSwingNoBounce"):FireServer()
end

local function isAlive(character)
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end


local function teleportAndAttack(target)
    local char = target.Character
    if char then
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        while not rootPart do
            game:GetService("RunService").Heartbeat:Wait()
            char = target.Character
            rootPart = char and char:FindFirstChild("HumanoidRootPart")
        end
        if rootPart then
            teleportToPosition(CFrame.new(rootPart.Position))
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myHRP then
                local attackPos = CFrame.new(rootPart.Position)
                for i = 1, 3 do
                myHRP.CFrame = attackPos
                SwingSaber(target.Character)
                end
            end
        end
    end
end

local function noclip(state)
    for _, child in ipairs(LocalPlayer.Character:GetDescendants()) do
        if child:IsA("BasePart") and child.CanCollide then
            child.CanCollide = not state
        end
    end
    LocalPlayer.Character.Humanoid:ChangeState(state and Enum.HumanoidStateType.Physics or Enum.HumanoidStateType.GettingUp)
end


local function killUser(inputText)
    local inputLower = inputText:lower()
    local targets = {}
    
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char = p.Character
                local ff = char:FindFirstChildWhichIsA("ForceField")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local duel = hrp and hrp:FindFirstChild("Dueling")
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 and not ff and not duel then
                    if p.Name:lower():find(inputLower,1,true) or p.DisplayName:lower():find(inputLower,1,true) then
                        targets = { p }
                        break
                    end
                end
            end
        end

    if #targets == 0 then return end
    noclip(true)
    local orig = LocalPlayer.Character.PrimaryPart.CFrame
    for _, target in ipairs(targets) do
    local hrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    local killTimeLimit = hrp and hrp.Position.Y < 4966 and 1.5 or 0.3
    local startTime = tick()
    while isAlive(target.Character) and tick() - startTime < killTimeLimit do
        teleportAndAttack(target)
        task.wait()
    end
    LocalPlayer.Character.PrimaryPart.CFrame = orig
    noclip(false)
end

end

local function killAll()
    local orig = LocalPlayer.Character.PrimaryPart.CFrame
    local below, above = {}, {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local c = p.Character
            local hrp = c:FindFirstChild("HumanoidRootPart")
            local ff = c:FindFirstChildWhichIsA("ForceField")
            local duel = hrp and hrp:FindFirstChild("Dueling")
            local hum = c:FindFirstChildOfClass("Humanoid")
            
            local hasModel = false
            for _, v in pairs(c:GetChildren()) do
                if v:IsA("Model") then
                    hasModel = true
                    break
                end
            end

            if not hasModel then
                continue
            end

            if hum and hum.Health > 0 and not ff and not duel then
                if hrp and hrp.Position.Y < 4967 then
                    table.insert(below, p)
                else
                    table.insert(above, p)
                end
            end
        end
    end
    for _, group in ipairs({below, above}) do
        for _, p in ipairs(group) do
            if killAllActive and p and p.Character then
                teleportToPlayer(p.Name)
                game:GetService("RunService").Stepped:Wait()
                killUser(p.Name)
                game:GetService("RunService").Stepped:Wait()
            end
        end
    end
    if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
        LocalPlayer.Character.PrimaryPart.CFrame = orig
    end
end

local function godMode()
    if godModeActive then return end

    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end

    godModeActive = true

    local orig = LocalPlayer.Character.PrimaryPart.CFrame
    local hasSaber = false
    for _, obj in pairs(workspace[LocalPlayer.Name]:GetChildren()) do
        if obj.Name:find("Saber") then
            hasSaber = true
            break
        end
    end
    if hasSaber then
        local ff = LocalPlayer.Character:FindFirstChildWhichIsA("ForceField")
        if ff then ff:Destroy() end
        Remotes.Equip:FireServer()
        Remotes.Ignite:FireServer()
        local map = workspace:FindFirstChild("Map")
        local mapModel = map and map:FindFirstChild("MapModel")
        local killParts = mapModel and mapModel:FindFirstChild("KillParts")
        while killParts and #killParts:GetChildren() == 0 do
            teleportToPosition(CFrame.new(-12, -400, 1))
            game:GetService("RunService").Heartbeat:Wait()
            killParts = mapModel and mapModel:FindFirstChild("KillParts")
        end
        if killParts then
            for _, part in ipairs(killParts:GetChildren()) do
                part.CanTouch = false
            end
        end
        LocalPlayer.Character.PrimaryPart.CFrame = orig

        local loopActive = true
        local steppedConn
        steppedConn = game:GetService("RunService").Stepped:Connect(function()
            if not loopActive or humanoid.Health <= 0 then
                loopActive = false
                if steppedConn then steppedConn:Disconnect() end
                if killParts then
                    for _, part in ipairs(killParts:GetChildren()) do
                        part.CanTouch = true
                    end
                end
                return
            end
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    for _, part in ipairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanTouch = false
                        end
                    end
                end
            end
        end)

        while not LocalPlayer.PlayerGui:FindFirstChild("KillCamUI") do
            Remotes.Attack:FireServer(3, 1, false, false)
            Remotes.Swing:FireServer()
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    Remotes.OnHit:FireServer(player.Character)
                end
            end
            Remotes.FinishSwingNoBounce:FireServer()
            Remotes.ResetSwingDirection:FireServer()
            task.wait()
        end

        local killCamUI = LocalPlayer.PlayerGui:FindFirstChild("KillCamUI")
        if killCamUI then
            killCamUI.Background.Visible = false
            for _, child in ipairs(LocalPlayer.PlayerGui:FindFirstChild("KillFeed").Background:GetChildren()) do
                if child.Name == "Template" then
                    child.Visible = false
                end
            end
        end
    end
end

local function killAllKeybindCallback()
    killAllActive = not killAllActive

    local function hasModelInside(character)
            for _, v in pairs(character:GetChildren()) do
                if v:IsA("Model") then
                    return true
                end
            end
            return false
        end

        local myCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if not hasModelInside(myCharacter) then
            killAllActive = false
            return
        end

        orig = myCharacter.PrimaryPart and myCharacter.PrimaryPart.CFrame

        task.spawn(function()
            while killAllActive do
                if not godModeActive then
                    godMode()
                end
                killAll()

                local function checkTargetAndKill(target)
                    local humanoid = target:FindFirstChild("Humanoid")
                    local root = target:FindFirstChild("HumanoidRootPart")
                    
                    if humanoid and humanoid.Health > 0 and root then
                        repeat
                            killAll()
                            task.wait(0.1)
                        until not killAllActive or humanoid.Health <= 0
                    end
                end

                for _, player in pairs(Players:GetPlayers()) do
                    if player.Character and player.Character ~= LocalPlayer.Character then
                        checkTargetAndKill(player.Character)
                    end
                end

                game:GetService("RunService").Stepped:Wait()
            end

            if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and orig then
                LocalPlayer.Character.PrimaryPart.CFrame = orig
            end
        end)
end

-- Setup Character Events
LocalPlayer.CharacterAdded:Connect(setupCharacter)
setupCharacter()

-- Tabs
local Tabs = {
  Combat = Window:Tab({ Title = "Combat", Icon = "swords" }),
  Player = Window:Tab({ Title = "Player", Icon = "user" }),
  Troll = Window:Tab({ Title = "Troll", Icon = "drama" }),
}
Window:SelectTab(1)

-- Combat Section
Tabs.Combat:Section({ Title = "Saber" })
Tabs.Combat:Toggle({ Title = "Speed Swing", Desc = "Speeds up your swings.", Value = false, Callback = speedSwingCallback })
Tabs.Combat:Toggle({ Title = "Auto Perfect Block", Desc = "Perfect blocks attacks automatically.", Value = false, Callback = autoPerfectBlockCallback })
Tabs.Combat:Toggle({ Title = "No Slap", Desc = "Automatically defend against slap attacks.", Value = false, Callback = noSlapCallback })
Tabs.Combat:Toggle({ Title = "Invisible Walk", Desc = "Force walk loop.", Value = false, Callback = invisibleWalkCallback })
Tabs.Combat:Section({ Title = "Auto Farm" })
Tabs.Combat:Button({ Title = "Kill All (OFF/ON)", Desc = "Press to kill all players.", Callback = killAllKeybindCallback })

-- Player Section
Tabs.Player:Section({ Title = "Movement" })
Tabs.Player:Slider({ Title = "WalkSpeed", Desc = "Adjust WalkSpeed", Value = { Min = 16, Max = 500, Default = 16 }, Callback = walkSpeedSliderCallback })
Tabs.Player:Slider({ Title = "JumpPower", Desc = "Adjust JumpPower", Value = { Min = 38, Max = 350, Default = 38 }, Callback = jumpPowerSliderCallback })

-- Teleport Section
Tabs.Player:Section({ Title = "Teleport" })
SelectedPlayer = LocalPlayer.Name
local Dropdown = Tabs.Player:Dropdown({ Title = "Choose a Player", Desc = "Player to teleport to", Options = GetPlayerNames(), Value = SelectedPlayer, Callback = function(option) SelectedPlayer = option end })
Players.PlayerAdded:Connect(function() Dropdown:Refresh(GetPlayerNames()) end)
Players.PlayerRemoving:Connect(function() Dropdown:Refresh(GetPlayerNames()) end)
Tabs.Player:Button({ Title = "Teleport to Player", Desc = "Teleport to selected player.", Callback = teleportToPlayerButton })

-- Troll Section
Tabs.Troll:Section({ Title = "Fling" })
SelectedPlayer2 = LocalPlayer.Name
local Dropdown2 = Tabs.Troll:Dropdown({ Title = "Choose a Player", Desc = "Player to fling", Options = GetPlayerNames(), Value = SelectedPlayer2, Callback = function(option) SelectedPlayer2 = option end })
Players.PlayerAdded:Connect(function() Dropdown2:Refresh(GetPlayerNames()) end)
Players.PlayerRemoving:Connect(function() Dropdown2:Refresh(GetPlayerNames()) end)
Tabs.Troll:Button({ Title = "Fling Player", Desc = "Fling the selected player using parts.", Callback = flingPlayerButton })

Dropdown:Refresh(GetPlayerNames())
Dropdown2:Refresh(GetPlayerNames())
