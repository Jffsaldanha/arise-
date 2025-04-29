--[[
    Laruda AutoFarm Script
    Roblox Game: Arise Crossover
    Autor: Jffsaldanha + ChatGPT
    Descrição: Ferramenta para testes do evento Raid Winter (Laruda), com interface, horário e autoclick.
--]]

-- Proteção contra múltiplas execuções
if getgenv().LarudaFarmRunning then return end
getgenv().LarudaFarmRunning = true

-- Auto Execute: Reexecuta após troca de servidor
local function setupAutoExecute()
    if isfile and writefile then
        writefile("laruda_autoexec.lua", 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Jffsaldanha/arise-/main/laruda_farm.lua"))()')
    end
end
setupAutoExecute()

-- Carregar OrionLib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Eazvy/UILibs/main/Librarys/Orion/OrionLib.lua"))()

-- Criar Janela
local Window = OrionLib:MakeWindow({Name = "Laruda AutoFarm", HidePremium = false, IntroText = "Laruda Sniper", SaveConfig = true, ConfigFolder = "LarudaFarm"})

-- Auto Clicker
local autoClick = false
task.spawn(function()
    while true do
        task.wait(0.1)
        if autoClick then
            pcall(function()
                local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end)
        end
    end
end)

-- Teleportar até o Laruda (posição estimada, altere conforme necessário)
local function teleportToLaruda()
    local lp = game.Players.LocalPlayer
    if lp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(123, 15, 456)) -- ⬅️ Altere para a posição exata do Laruda
    end
end

-- Verificar horário de spawn
local function checkLarudaSpawn()
    local currentTime = os.date("*t")
    local minute = currentTime.min
    return minute == 11 or minute == 41
end

-- Monitorar automaticamente o horário
local autoMonitor = false
task.spawn(function()
    while true do
        task.wait(5)
        if autoMonitor and checkLarudaSpawn() then
            teleportToLaruda()
            autoClick = true
        end
    end
end)

-- Interface com botões
local Tab = Window:MakeTab({Name = "Principal", Icon = "rbxassetid://4483345998", PremiumOnly = false})

Tab:AddButton({
    Name = "Teleportar para Laruda",
    Callback = function()
        teleportToLaruda()
        OrionLib:MakeNotification({
            Name = "Teleportado",
            Content = "Você foi movido até o local do Laruda.",
            Time = 3
        })
    end
})

Tab:AddToggle({
    Name = "AutoClicker",
    Default = false,
    Callback = function(v)
        autoClick = v
    end
})

Tab:AddToggle({
    Name = "Monitorar Horário (Auto TP)",
    Default = false,
    Callback = function(v)
        autoMonitor = v
    end
})

OrionLib:Init()
