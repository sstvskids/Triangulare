-- noobs must die rewritten

local run = function(func) func() end
local cloneref = cloneref or function(val) return val end
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer

local settings = {
    distance = 30,
    selected = 'Armor',
    fighter = 'Telamon',
    times = 1
}

getgenv().AutoKill = false
--getgenv().AutoRevive = false
getgenv().KillAura = false
getgenv().AutoSkip = false
getgenv().InfDamage = false

local function getItem()
    for i = 1, settings.times do
        ReplicatedStorage.PlrMan.Items.PickupItem:FireServer(settings.selected)
    end
end

local function ReturnListOf(what)
    local names = {}

    if what == 'Items' then
        for _, v in pairs(ReplicatedStorage.PlrMan.Items:GetChildren()) do
            if v:IsA('Part') then
                table.insert(names, v.name)
            end
        end
    elseif what == 'Characters' then
        for _, v in pairs(ReplicatedStorage.Fighters:GetChildren()) do
            table.insert(names, v.name)
        end
    end

    return names
end

local function KillAll()
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:IsA('Model') then
            ReplicatedStorage.HurtEnemy:FireServer(v, lplr.Character.Humanoid:GetAttribute('Damage'))
        end
    end
end

local function AutoKill()
    repeat
        KillAll()
        task.wait()
    until getgenv().AutoKill == false
end

local function AutoSkip()
    repeat
        lplr.PlayerGui.HUD.RoundTimeUI.RoundTimeUI.VoteSkip:FireServer()
        task.wait()
    until getgenv().AutoSkip == false
end

local function KillAura()
    local function GetNearby()
        local detected = {}
        for _, v in pairs(workspace:GetPartBoundsInBox(lplr.Character.HumanoidRootPart.CFrame, Vector3.new(settings.distance, 20, settings.distance), nil)) do
            local model = v:FindFirstAncestorWhichIsA('Model')
            if model:IsDescendantOf(workspace.Enemies) then
                table.insert(detected, model)
            end
        end

        return detected
    end
    repeat
        for _, v in pairs(GetNearby()) do
            ReplicatedStorage.HurtEnemy:FireServer(v, lplr.Character.Humanoid:GetAttribute('Damage'))
        end
        task.wait()
    until getgenv().KillAura == false
end

-- me when autorevive doesn't work (rewrite soon)
--[[local function AutoRevive()
    while getgenv().AutoRevive and task.wait(1) do
        if not eu.Character:GetAttribute("Connected") then
            eu.Character:SetAttribute("Connected", true)
            eu.Character:GetAttributeChangedSignal("Downed"):Connect(function()
                if getgenv().AutoRevive and eu.Character:GetAttribute("Downed") then
                    eu.PlayerGui.ScreenUI.StartGame:FireServer()
                end
            end)
        end
    end
end]]

local tabs = {
    BlatantTab = Window:Tab({Title = 'Blatant', Icon = 'swords'}),
    ItemsTab = Window:Tab({Title = 'Items', Icon = 'box'}),
    FightersTab = Window:Tab({Title = 'Fighters', Icon = 'person-standing'}),
    GodsTab = Window:Tab({Title = 'Invincibility', Icon = 'sparkles'})
}

Window:SelectTab(1)

tabs.BlatantTab:Section({Title = 'Detectable'})

run(function()
    local InfDamage
    local oldDamage = lplr.Character.Humanoid:GetAttribute('Damage')
    InfDamage = tabs.BlatantTab:Toggle({
        Title = 'Inf Damage',
        Desc = 'Gives you Infinite Damage',
        Value = false,
        Callback = function(state)
            if state then
                repeat
                    lplr.Character.Humanoid:SetAttribute('Damage', math.huge)
                    task.wait()
                until not state
            else
                lplr.Character.Humanoid:SetAttribute('Damage', oldDamage)
            end
        end
    })
end)

run(function()
    local KilllAll
    KilllAll = tabs.BlatantTab:Button({
        Title = 'Kill All',
        Desc = 'Kills all noobs alive',
        Callback = function()
            KillAll()
        end
    })
end)

run(function()
    local KillAllAuto
    KillAllAuto = tabs.BlatantTab:Toggle({
        Title = 'Auto Kill All',
        Desc = 'Automatically kills all noobs',
        Value = false,
        Callback = function(state)
            getgenv().AutoKill = state
            AutoKill()
        end
    })
end)

tabs.BlatantTab:Section({Title = "Helpful"})
run(function()
    local Aura
    local AuraDist
    Aura = tabs.BlatantTab:Toggle({
        Title = 'Aura',
        Desc = 'Kills all closer noobs',
        Value = false,
        Callback = function(state)
            getgenv().KillAura = state
            KillAura()
        end
    })
    AuraDist = tabs.BlatantTab:Input({
        Title = 'Aura Distance',
        Value = tostring(settings.distance / 2),
        Placeholder = 'Numbers only, ex.: 15',
        Callback = function(input)
            settings.distance = (tonumber(input) * 2) or 1
        end
    })
end)

tabs.BlatantTab:Section({Title = "Undetectable"})
run(function()
    local FinishQuests
    FinishQuests = tabs.BlatantTab:Button({
        Title = 'Finish All Quests',
        Desc = 'Finishes all active quests.',
        Callback = function()
            for i = 1, 9 do
                ReplicatedStorage.PlrMan.LogQuestProgress:FireServer(i, math.huge)
            end
        end
    })
end)

run(function()
    local AutooSkip
    AutooSkip = tabs.BlatantTab:Toggle({
        Title = "AutoSkip",
        Desc = 'Auto votes to skip interval.',
        Value = false,
        Callback = function(state)
            getgenv().AutoSkip = state
            AutoSkip()
        end
    })
end)