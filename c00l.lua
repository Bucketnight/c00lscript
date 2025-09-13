-- c00lgui Recreation v1.0 by Bucketnight (No Rayfield, Pure 2014 Chaos)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InsertService = game:GetService("InsertService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Key system
local keyInput = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
local keyFrame = Instance.new("Frame", keyInput)
keyFrame.Size = UDim2.new(0, 300, 0, 150)
keyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
keyFrame.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Blood red
keyFrame.BorderColor3 = Color3.fromRGB(50, 0, 0) -- Dark red
local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0, 200, 0, 50)
keyBox.Position = UDim2.new(0.5, -100, 0.5, -25)
keyBox.Text = ""
keyBox.PlaceholderText = "Enter Key: C00L2025"
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
local keyLabel = Instance.new("TextLabel", keyFrame)
keyLabel.Size = UDim2.new(0, 200, 0, 30)
keyLabel.Position = UDim2.new(0.5, -100, 0, 10)
keyLabel.Text = "c00lgui Key System by Bucketnight"
keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
keyLabel.BackgroundTransparency = 1
keyLabel.Font = Enum.Font.SourceSansBold
keyLabel.TextSize = 18
local keySubmit = Instance.new("TextButton", keyFrame)
keySubmit.Size = UDim2.new(0, 100, 0, 30)
keySubmit.Position = UDim2.new(0.5, -50, 1, -40)
keySubmit.Text = "Submit"
keySubmit.TextColor3 = Color3.fromRGB(255, 255, 255)
keySubmit.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
keySubmit.MouseButton1Click:Connect(function()
    if keyBox.Text == "C00L2025" then
        keyInput:Destroy()
    else
        keyBox.Text = ""
    end
end)
wait(10) -- Timeout
if keyInput.Parent then
    keyInput:Destroy()
    error("Invalid Key!")
end

-- Main GUI
local gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
gui.Name = "c00lgui"
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Blood red
mainFrame.BorderColor3 = Color3.fromRGB(50, 0, 0) -- Dark red
mainFrame.Active = true
mainFrame.Draggable = true
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "c00lgui by Bucketnight - 2014 Red Chaos"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeButton.MouseButton1Click:Connect(function()
    gui.Enabled = not gui.Enabled
end)

-- Fly vars
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyPosition = nil
local keys = {w=false, a=false, s=false, d=false, space=false, ctrl=false}

-- Fly functions
local function startFly()
    if flying then return end
    flying = true
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 0, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = RootPart
    bodyPosition = Instance.new("BodyPosition")
    bodyPosition.MaxForce = Vector3.new(0, 4000, 0)
    bodyPosition.Position = RootPart.Position
    bodyPosition.Parent = RootPart
    local function onInput(i, g)
        if g then return end
        if i.KeyCode == Enum.KeyCode.W then keys.w = i.UserInputState == Enum.UserInputState.Begin end
        if i.KeyCode == Enum.KeyCode.A then keys.a = i.UserInputState == Enum.UserInputState.Begin end
        if i.KeyCode == Enum.KeyCode.S then keys.s = i.UserInputState == Enum.UserInputState.Begin end
        if i.KeyCode == Enum.KeyCode.D then keys.d = i.UserInputState == Enum.UserInputState.Begin end
        if i.KeyCode == Enum.KeyCode.Space then keys.space = i.UserInputState == Enum.UserInputState.Begin end
        if i.KeyCode == Enum.KeyCode.LeftControl then keys.ctrl = i.UserInputState == Enum.UserInputState.Begin end
    end
    UserInputService.InputBegan:Connect(onInput)
    UserInputService.InputEnded:Connect(onInput)
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not flying then conn:Disconnect() return end
        local mv = Vector3.new(0, 0, 0)
        if keys.w then mv = mv + (workspace.CurrentCamera.CFrame.LookVector * flySpeed) end
        if keys.s then mv = mv - (workspace.CurrentCamera.CFrame.LookVector * flySpeed) end
        if keys.a then mv = mv - (workspace.CurrentCamera.CFrame.RightVector * flySpeed) end
        if keys.d then mv = mv + (workspace.CurrentCamera.CFrame.RightVector * flySpeed) end
        local vel = Vector3.new(mv.X, 0, mv.Z)
        if keys.space then vel = vel + Vector3.new(0, flySpeed, 0) end
        if keys.ctrl then vel = vel - Vector3.new(0, flySpeed, 0) end
        bodyVelocity.Velocity = vel
        bodyPosition.Position = RootPart.Position + Vector3.new(0, 0.5, 0)
    end)
end

local function stopFly()
    if not flying then return end
    flying = false
    if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
    if bodyPosition then bodyPosition:Destroy(); bodyPosition = nil end
end

UserInputService.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.F then
        if flying then stopFly() else startFly() end
    end
end)

Player.CharacterAdded:Connect(function(nc)
    Character = nc
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    if flying then wait(1); startFly() end
end)

-- Troll functions
local discoConnection = nil
local stamperSpamConnection = nil
local gearSpamActive = false
local crasherActive = false

local function discoFog()
    Lighting.FogEnd = 50
    Lighting.FogStart = 0
    Lighting.Brightness = 1
    if discoConnection then discoConnection:Disconnect() end
    discoConnection = RunService.Heartbeat:Connect(function()
        Lighting.ColorShift_Bottom = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        Lighting.ColorShift_Top = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        Lighting.Ambient = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        wait(0.5)
    end)
end

local function stopDiscoFog()
    if discoConnection then discoConnection:Disconnect(); discoConnection = nil end
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
    Lighting.Brightness = 2
    Lighting.ColorShift_Bottom = Color3.new()
    Lighting.ColorShift_Top = Color3.new()
    Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
end

local function stamperSpam()
    if stamperSpamConnection then return end
    stamperSpamConnection = RunService.Heartbeat:Connect(function()
        local stamper = InsertService:LoadAsset(165378611) -- Stamper Tool ID
        stamper.Parent = workspace
        stamper:MoveTo(Vector3.new(math.random(-100,100), 50, math.random(-100,100)))
    end)
end

local function stopStamperSpam()
    if stamperSpamConnection then stamperSpamConnection:Disconnect(); stamperSpamConnection = nil end
end

local function gearDropper()
    if gearSpamActive then return end
    gearSpamActive = true
    spawn(function()
        while gearSpamActive do
            local gear = Instance.new("Tool")
            gear.Name = "Troll Gear"
            gear.RequiresHandle = true
            local handle = Instance.new("Part")
            handle.Name = "Handle"
            handle.Size = Vector3.new(1,1,1)
            handle.BrickColor = BrickColor.Random()
            handle.Parent = gear
            gear.Parent = Player.Backpack
            if ReplicatedStorage:FindFirstChild("DefaultStore") and ReplicatedStorage.DefaultStore:FindFirstChild("GiveTool") then
                ReplicatedStorage.DefaultStore.GiveTool:FireServer(gear)
            end
            wait(0.1)
        end
    end)
end

local function stopGearDropper()
    gearSpamActive = false
end

local function serverCrasher()
    if crasherActive then return end
    crasherActive = true
    spawn(function()
        while crasherActive do
            for i = 1, 100 do
                local part = Instance.new("Part")
                part.Size = Vector3.new(10,10,10)
                part.Position = Vector3.new(math.random(-500,500), math.random(0,100), math.random(-500,500))
                part.Parent = workspace
            end
            wait(0.01)
        end
    end)
end

local function stopServerCrasher()
    crasherActive = false
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Part") and obj.Name == "" then obj:Destroy() end
    end
end

local function unanchorAll()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
            obj.Anchored = false
        end
    end
end

local function reanchorAll()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
            obj.Anchored = true
        end
    end
end

local function destroyer()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
            obj:Destroy()
        end
    end
end

local function apply666Theme()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://131961136" -- Spooky sound
    sound.Volume = 0.5
    sound.Looped = true
    sound.Parent = Lighting
    sound:Play()
end

-- Apply theme on load
apply666Theme()

-- Create buttons
local function createButton(parent, name, yOffset, callback)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(0, 180, 0, 40)
    button.Position = UDim2.new(0, 10, 0, yOffset)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    button.BorderColor3 = Color3.fromRGB(50, 0, 0)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 16
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Tabs (Frames for Fly and c00lgui)
local flyFrame = Instance.new("Frame", mainFrame)
flyFrame.Size = UDim2.new(0.5, -10, 1, -50)
flyFrame.Position = UDim2.new(0, 5, 0, 45)
flyFrame.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
flyFrame.BorderColor3 = Color3.fromRGB(50, 0, 0)
local flyLabel = Instance.new("TextLabel", flyFrame)
flyLabel.Size = UDim2.new(1, 0, 0, 30)
flyLabel.Text = "Fly Controls"
flyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flyLabel.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
flyLabel.Font = Enum.Font.SourceSansBold
flyLabel.TextSize = 18

local c00lFrame = Instance.new("Frame", mainFrame)
c00lFrame.Size = UDim2.new(0.5, -10, 1, -50)
c00lFrame.Position = UDim2.new(0.5, 5, 0, 45)
c00lFrame.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
c00lFrame.BorderColor3 = Color3.fromRGB(50, 0, 0)
local c00lLabel = Instance.new("TextLabel", c00lFrame)
c00lLabel.Size = UDim2.new(1, 0, 0, 30)
c00lLabel.Text = "c00lgui Troll Tools"
c00lLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
c00lLabel.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
c00lLabel.Font = Enum.Font.SourceSansBold
c00lLabel.TextSize = 18
local devLabel = Instance.new("TextLabel", c00lFrame)
devLabel.Size = UDim2.new(1, 0, 0, 30)
devLabel.Position = UDim2.new(0, 0, 1, -30)
devLabel.Text = "by Bucketnight, Roblox Dev Extraordinaire"
devLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
devLabel.BackgroundTransparency = 1
devLabel.Font = Enum.Font.SourceSans
devLabel.TextSize = 14

-- Fly buttons
createButton(flyFrame, "Toggle Fly (F)", 40, function()
    if flying then stopFly() else startFly() end
end)
local speedSlider = Instance.new("TextBox", flyFrame)
speedSlider.Size = UDim2.new(0, 180, 0, 40)
speedSlider.Position = UDim2.new(0, 10, 0, 90)
speedSlider.Text = tostring(flySpeed)
speedSlider.PlaceholderText = "Fly Speed (16-200)"
speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
speedSlider.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
speedSlider.BorderColor3 = Color3.fromRGB(50, 0, 0)
speedSlider.TextChanged:Connect(function()
    local val = tonumber(speedSlider.Text)
    if val and val >= 16 and val <= 200 then
        flySpeed = val
    else
        speedSlider.Text = tostring(flySpeed)
    end
end)

-- c00lgui buttons
createButton(c00lFrame, "Disco Fog", 40, discoFog)
createButton(c00lFrame, "Stop Disco Fog", 90, stopDiscoFog)
createButton(c00lFrame, "Stamper Spam", 140, stamperSpam)
createButton(c00lFrame, "Stop Stamper Spam", 190, stopStamperSpam)
createButton(c00lFrame, "Gear Dropper", 240, gearDropper)
createButton(c00lFrame, "Stop Gear Dropper", 290, stopGearDropper)
createButton(c00lFrame, "Server Crasher", 340, serverCrasher)
createButton(c00lFrame, "Stop Crasher", 390, stopServerCrasher)
createButton(c00lFrame, "Unanchor All Parts", 440, unanchorAll)
createButton(c00lFrame, "Reanchor All Parts", 490, reanchorAll)
createButton(c00lFrame, "Destroyer", 540, destroyer)

-- Notify (basic)
local notify = Instance.new("TextLabel", gui)
notify.Size = UDim2.new(0, 300, 0, 50)
notify.Position = UDim2.new(0.5, -150, 0, 10)
notify.Text = "c00lgui Loaded! Bucketnight’s Chaos Unleashed!"
notify.TextColor3 = Color3.fromRGB(255, 255, 255)
notify.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
notify.BorderColor3 = Color3.fromRGB(50, 0, 0)
notify.Font = Enum.Font.SourceSansBold
notify.TextSize = 16
game:GetService("TweenService"):Create(notify, TweenInfo.new(5), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
spawn(function() wait(5) notify:Destroy() end)
