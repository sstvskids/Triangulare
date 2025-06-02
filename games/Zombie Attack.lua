while task.wait(1) do
for _, enemy in pairs(workspace.enemies:GetChildren()) do
local args = {
    [1] = {
        ["Normal"] = Vector3.new(0.8710253238677979, -0.06031331047415733, -0.4875214695930481),
        ["Direction"] = Vector3.new(-773.612548828125, -542.2489013671875, 327.8561706542969),
        ["Name"] = "Uzi",
        ["Hit"] = enemy.Head,
        ["Origin"] = Vector3.new(189.92919921875, 25.162551879882812, -15.067889213562012),
        ["Pos"] = Vector3.new(160.70860290527344, 4.680932998657227, -2.6842336654663086)
    }
}

game:GetService("ReplicatedStorage").Gun:FireServer(unpack(args))
end
end
1240123653/504035427