-- // Carregar a interface Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Eazvy/UILibs/main/Librarys/Orion/Example')))()

-- // Criar a janela
local Window = OrionLib:MakeWindow({Name = "Raid Winter - Teste Laruda", HidePremium = false, SaveConfig = true, ConfigFolder = "AriseTest"})

-- // Variáveis
local autoFarming = false
local monitoring = false
local autoExecute = false

-- // Função para detectar Laruda
local function findLaruda()
    return workspace:FindFirstChild("Laruda")
end

-- // Função para teleportar e atacar
local function teleportAndAttack()
    local laruda = findLaruda()
    if laruda and laruda:FindFirstChild("HumanoidRootPart") then
        local player = game.Players.LocalPlayer
        player.Character.HumanoidRootPart.CFrame = laruda.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)

        OrionLib:MakeNotification({
            Name = "Laruda encontrado!",
            Content = "Teleportado e iniciando ataques!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })

        while autoFarming and laruda.Parent do
            local tool = player.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
            task.wait(0.2)
        end
    else
        OrionLib:MakeNotification({
            Name = "Erro",
            Content = "Laruda não encontrado!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
end

-- // Função para monitorar horário fixo
local function monitorLaruda()
    monitoring = true
    OrionLib:MakeNotification({
        Name = "Monitoramento",
        Content = "Aguardando horário (11 ou 41)...",
        Image = "rbxassetid://4483345998",
        Time = 5
    })

    while monitoring do
        local time = os.date("*t")
        local minute = time.min
        local second = time.sec

        if (minute == 11 or minute == 41) and second <= 10 then
            OrionLib:MakeNotification({
                Name = "Hora do Spawn!",
                Content = "Procurando Laruda...",
                Image = "rbxassetid://4483345998",
                Time = 5
            })

            autoFarming = true
            teleportAndAttack()

            local laruda = findLaruda()
            while laruda and laruda.Parent and monitoring do
                task.wait(1)
            end

            OrionLib:MakeNotification({
                Name = "Laruda",
                Content = "Laruda derrotado ou sumiu!",
                Image = "rbxassetid://4483345998",
                Time = 5
            })

            autoFarming = false
            task.wait(120)
        end

        task.wait(1)
    end
end

-- // Função para preparar auto execução em teleporte
local function setupAutoExecute()
    if autoExecute then
        local scriptSource = [[
            loadstring(game:HttpGet('https://yourserver.com/your_script.lua'))()
        ]]
        -- (Substituir depois pelo seu link real onde você hospedará o script)

        queue_on_teleport(scriptSource)
        OrionLib:MakeNotification({
            Name = "Auto Execute",
            Content = "Preparado para próximo servidor!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
end

-- // Criar aba principal
local Tab = Window:MakeTab({
    Name = "Laruda Raid",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- // Botão para teleportar manualmente
Tab:AddButton({
    Name = "Teleportar & Atacar (Manual)",
    Callback = function()
        autoFarming = true
        teleportAndAttack()
    end
})

-- // Botão para iniciar monitoramento automático
Tab:AddButton({
    Name = "Iniciar Auto Farm (Horários fixos)",
    Callback = function()
        if not monitoring then
            task.spawn(monitorLaruda)
        else
            OrionLib:MakeNotification({
                Name = "Aviso",
                Content = "Já está monitorando!",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

-- // Botão para parar
Tab:AddButton({
    Name = "Parar Tudo",
    Callback = function()
        autoFarming = false
        monitoring = false
        OrionLib:MakeNotification({
            Name = "Parado",
            Content = "Auto Farm desligado!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
})

-- // Toggle de Auto Execute
Tab:AddToggle({
    Name = "Auto Execute ao trocar servidor",
    Default = false,
    Callback = function(Value)
        autoExecute = Value
        if autoExecute then
            setupAutoExecute()
        end
    end
})

OrionLib:Init()
