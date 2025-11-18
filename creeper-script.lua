--// CREEPER SCRIPT - INTERFAZ TIPO EXE

-- Crear ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "CreeperScriptGUI"
gui.ResetOnSpawn = false
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- BOTÓN PRINCIPAL (redondo y pequeño)
local mainButton = Instance.new("ImageButton")
mainButton.Parent = gui
mainButton.Size = UDim2.new(0, 60, 0, 60)
mainButton.Position = UDim2.new(0.05, 0, 0.4, 0)
mainButton.BackgroundTransparency = 0.1
mainButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
mainButton.Image = "rbxassetid://115287400808436"
mainButton.AutoButtonColor = true
mainButton.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = mainButton

local title = Instance.new("TextLabel")
title.Parent = mainButton
title.Size = UDim2.new(1, 0, 0, 20)
title.Position = UDim2.new(0, 0, -0.30, 0)
title.BackgroundTransparency = 1
title.Text = "Creeper Script"
title.Font = Enum.Font.Fantasy
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(30,255,30)

-- MENÚ PRINCIPAL (2DA INTERFAZ) - 110×110 (GRIS)
local menu = Instance.new("Frame")
menu.Parent = gui
menu.Size = UDim2.new(0, 110, 0, 140)
menu.Position = UDim2.new(0.3, 0, 0.35, 0)
menu.BackgroundColor3 = Color3.fromRGB(60,60,60)
menu.BackgroundTransparency = 0.1
menu.BorderSizePixel = 0
menu.Visible = false
menu.Active = true
menu.Draggable = true

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0.25, 0)
corner2.Parent = menu

-- Sin imagen de fondo
local bg = Instance.new("ImageLabel")
bg.Parent = menu
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundTransparency = 1
bg.Image = ""

-- BOTONES
local saveButton = Instance.new("TextButton")
saveButton.Parent = menu
saveButton.Size = UDim2.new(1, 0, 0, 25)
saveButton.Position = UDim2.new(0, 0, 0, 0)
saveButton.Text = "Save"
saveButton.BackgroundColor3 = Color3.fromRGB(100,180,100)
saveButton.TextScaled = true
saveButton.TextColor3 = Color3.new(1,1,1)
saveButton.Font = Enum.Font.Fantasy

local tpButton = Instance.new("TextButton")
tpButton.Parent = menu
tpButton.Size = UDim2.new(1, 0, 0, 25)
tpButton.Position = UDim2.new(0, 0, 0, 25)
tpButton.Text = "TP"
tpButton.BackgroundColor3 = Color3.fromRGB(100,180,100)
tpButton.TextScaled = true
tpButton.TextColor3 = Color3.new(1,1,1)
tpButton.Font = Enum.Font.Fantasy

local speedButton = Instance.new("TextButton")
speedButton.Parent = menu
speedButton.Size = UDim2.new(1, 0, 0, 25)
speedButton.Position = UDim2.new(0, 0, 0, 50)
speedButton.Text = "Speed 60"
speedButton.BackgroundColor3 = Color3.fromRGB(100,180,100)
speedButton.TextScaled = true
speedButton.TextColor3 = Color3.new(1,1,1)
speedButton.Font = Enum.Font.Fantasy

local noclipButton = Instance.new("TextButton")
noclipButton.Parent = menu
noclipButton.Size = UDim2.new(1, 0, 0, 25)
noclipButton.Position = UDim2.new(0, 0, 0, 75)
noclipButton.Text = "Noclip"
noclipButton.BackgroundColor3 = Color3.fromRGB(100,180,100)
noclipButton.TextScaled = true
noclipButton.TextColor3 = Color3.new(1,1,1)
noclipButton.Font = Enum.Font.Fantasy

local antihitButton = Instance.new("TextButton")
antihitButton.Parent = menu
antihitButton.Size = UDim2.new(1, 0, 0, 25)
antihitButton.Position = UDim2.new(0, 0, 0, 100)
antihitButton.Text = "Anti-Hit OFF"
antihitButton.BackgroundColor3 = Color3.fromRGB(180,100,100)
antihitButton.TextScaled = true
antihitButton.TextColor3 = Color3.new(1,1,1)
antihitButton.Font = Enum.Font.Fantasy

-- LÓGICA
local savedPos = nil
local noclipEnabled = false
local antihitEnabled = false
local player = game.Players.LocalPlayer

mainButton.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- Guardar posición
saveButton.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPos = char.HumanoidRootPart.Position
        saveButton.Text = "OK!"
        task.wait(1)
        saveButton.Text = "Save"
    end
end)

-- Teleport
tpButton.MouseButton1Click:Connect(function()
    if savedPos then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(savedPos)
        end
    end
end)

-- Speed 60
speedButton.MouseButton1Click:Connect(function()
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = 60
    end
end)

-- Noclip
noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipButton.Text = noclipEnabled and "Noclip ON" or "Noclip"
end)

game:GetService("RunService").Stepped:Connect(function()
    local char = player.Character
    if char then
        -- Noclip
        if noclipEnabled then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end
        -- Anti-Hit
        if antihitEnabled then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.Health = math.huge
                hum.MaxHealth = math.huge
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end
end)

-- Anti-Hit Toggle
antihitButton.MouseButton1Click:Connect(function()
    antihitEnabled = not antihitEnabled
    antihitButton.Text = antihitEnabled and "Anti-Hit ON" or "Anti-Hit OFF"
end)
