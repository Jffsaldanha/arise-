if getgenv().LarudaFarmRunning then return end
getgenv().LarudaFarmRunning = true

-- Aguarda o jogo carregar totalmente
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Protege contra travamentos em loops
local safeTask = function(callback)
    return task.spawn(function()
        while true do
            task.wait(1)
            local success, err = pcall(callback)
            if not success then warn("[LarudaFarm Error]:", err) end
        end
    end)
end

-- Auto Execute persistente
local function setupAutoExecute()
    if isfile and writefile then
        writefile("laruda_autoexec.lua", 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Jffsaldanha/arise-/main/laruda_farm.lua"))()')
    end
end
setupAutoExecute()

-- Carregar OrionLib com segurança
local OrionLib = nil
pcall(function()
    OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Eazvy/UILibs/main/Librarys/Orion/OrionLib.lua"))()
end)

if not OrionLib then
    warn("Falha ao carregar OrionLib. Encerrando script.")
    return
end

-- Criar Janela
local Window = OrionLib:MakeWindow({Name = "Laruda AutoFarm", HidePremium = false, SaveConfig = true, ConfigFolder = "LarudaFarm"})

-- Variáveis
local autoClick = false
local autoMonitor = false

-- AutoClick seguro
safeTask(function()
    if autoClick then
        local tool = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
    end
end)

-- Teleportar com verificação
local function teleportToLaruda()
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(Vector3.new(123, 15, 456)) -- Ajuste essa posição
    end
end

-- Verificar horário
local function checkLarudaSpawn()
    local m = os.date("*t").min
    return m == 11 or m == 41
end

-- Monitorar horário seguro
safeTask(function()
    if autoMonitor and checkLarudaSpawn() then
        teleportToLaruda()
        autoClick = true
    end
end)

-- Interface
local Tab = Window:MakeTab({Name = "Laruda", Icon = "rbxassetid://4483345998", PremiumOnly = false})

Tab:AddButton({
    Name = "Teleportar para Laruda",
    Callback = function()
        teleportToLaruda()
        OrionLib:MakeNotification({
            Name = "Teleportado",
            Content = "Você foi movido ao local do Laruda",
            Time = 3
        })
    end
})

Tab:AddToggle({
    Name = "AutoClicker",
    Default = false,
    Callback = function(v) autoClick = v end
})

Tab:AddToggle({
    Name = "Monitorar Spawn (Horário)",
    Default = false,
    Callback = function(v) autoMonitor = v end
})

OrionLib:Init()
