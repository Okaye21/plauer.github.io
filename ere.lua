local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local function randomName(length)
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local name = ""
    for i = 1, length do
        local rand = math.random(1, #charset)
        name = name .. charset:sub(rand, rand)
    end
    return name
end

local function destroyESPFromCharacter(character)
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Highlight") then
            child:Destroy()
        end
    end
    local head = character:FindFirstChild("Head")
    if head then
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("BillboardGui") then
                child:Destroy()
            end
        end
    end
end

local function applyESPToCharacter(player, character)
    if player == localPlayer then return end
    if not character then return end
    local head = character:FindFirstChild("Head") or character:FindFirstChildWhichIsA("BasePart")
    if not head then return end
    destroyESPFromCharacter(character)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = randomName(math.random(8, 16))
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 1.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = player.DisplayName
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Parent = billboard
    local highlight = Instance.new("Highlight")
    highlight.Name = randomName(math.random(8, 16))
    highlight.Adornee = character
    highlight.FillColor = Color3.new(1, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.new(0, 0, 0)
    highlight.OutlineTransparency = 0.2
    highlight.Parent = character
end

local espConnections = {}

local function trackPlayer(player)
    if player == localPlayer then return end
    if player.Character then
        applyESPToCharacter(player, player.Character)
    end
    espConnections[player] = player.CharacterAdded:Connect(function(character)
        applyESPToCharacter(player, character)
    end)
end

local function untrackPlayer(player)
    if espConnections[player] then
        espConnections[player]:Disconnect()
        espConnections[player] = nil
    end
    if player ~= localPlayer and player.Character then
        destroyESPFromCharacter(player.Character)
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    trackPlayer(plr)
end

espConnections._PlayerAdded = Players.PlayerAdded:Connect(function(plr)
    trackPlayer(plr)
end)
espConnections._PlayerRemoving = Players.PlayerRemoving:Connect(function(plr)
    untrackPlayer(plr)
end)
