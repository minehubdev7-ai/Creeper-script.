--// CREEPER SCRIPT - INTERFAZ TIPO EXE

local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

-- Crear ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "CreeperScriptGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- BOTÓN PRINCIPAL (círculo)
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

-- MENÚ (2DA INTERFAZ)
local menu = Instance.new("Frame")
menu.Parent = gui
menu.Size = UDim2.new(0, 110, 0, 140)
menu.Position = UDim2.new(0.3, 0, 0.35, 0)
menu.BackgroundColor3 = Color3.fromRGB(60,60,60)
menu.BackgroundTransparency = 1
menu.BorderSizePixel = 0
menu.Visible = false
menu.Active = true
menu.Draggable = true

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0.25, 0)
corner2.Parent = menu

local menuScale = Instance.new("UIScale", menu)
menuScale.Scale = 0.7

-- BOTONES
local function createButton(name, posY)
    local b = Instance.new("TextButton")
    b.Parent = menu
    b.Size = UDim2.new(1, 0, 0, 25)
    b.Position = UDim2.new(0, 0, 0, posY)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(100,180,100)
    b.TextScaled = true
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Fantasy
    b.BackgroundTransparency = 1
    b.TextTransparency = 1
    return b
end

local saveButton = createButton("Save", 0)
local tpButton = createButton("TP", 25)
local speedButton = createButton("Speed 60", 50)
local noclipButton = createButton("Noclip", 75)
local antihitButton = createButton("Anti-Hit OFF", 100)

-- VARIABLES
local savedPos = nil
local noclipEnabled = false
local antihitEnabled = false

-- ==============================
-- ANIMACIÓN MENÚ + BOTÓN
-- ==============================

local openTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local closeTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

mainButton.MouseButton1Click:Connect(function()
    local abrir = not menu.Visible

    if abrir then
        menu.Visible = true

        TweenService:Create(menuScale, openTweenInfo, {Scale = 1}):Play()
        TweenService:Create(menu, openTweenInfo, {BackgroundTransparency = 0.05}):Play()

        for _,v in ipairs(menu:GetDescendants()) do
            if v:IsA("GuiObject") then
                TweenService:Create(v, openTweenInfo, {BackgroundTransparency = 0.1}):Play()
            end
            if v:IsA("TextLabel") or v:IsA("TextButton") then
                TweenService:Create(v, openTweenInfo, {TextTransparency = 0}):Play()
            end
        end

        TweenService:Create(mainButton, openTweenInfo, {
            Size = UDim2.new(0, 70, 0, 70)
        }):Play()

    else
        TweenService:Create(menuScale, closeTweenInfo, {Scale = 0.7}):Play()
        TweenService:Create(menu, closeTweenInfo, {BackgroundTransparency = 1}):Play()

        for _,v in ipairs(menu:GetDescendants()) do
            if v:IsA("GuiObject") then
                TweenService:Create(v, closeTweenInfo, {BackgroundTransparency = 1}):Play()
            end
            if v:IsA("TextLabel") or v:IsA("TextButton") then
                TweenService:Create(v, closeTweenInfo, {TextTransparency = 1}):Play()
            end
        end

        TweenService:Create(mainButton, closeTweenInfo, {
            Size = UDim2.new(0, 60, 0, 60)
        }):Play()

        task.wait(0.25)
        menu.Visible = false
    end
end)

-- ==============================
-- FUNCIONES DEL SCRIPT
-- ==============================

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

-- TP
tpButton.MouseButton1Click:Connect(function()
    if savedPos then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(savedPos)
        end
    end
end)

-- Speed
speedButton.MouseButton1Click:Connect(function()
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = 60 end
end)

-- Noclip
noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipButton.Text = noclipEnabled and "Noclip ON" or "Noclip"
end)

-- Anti-hit
antihitButton.MouseButton1Click:Connect(function()
    antihitEnabled = not antihitEnabled
    antihitButton.Text = antihitEnabled and "Anti-Hit ON" or "Anti-Hit OFF"
end)

game:GetService("RunService").Stepped:Connect(function()
    local char = player.Character
    if char then
        if noclipEnabled then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end

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
