-- Carregar a UI Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Criar a Janela Principal com minimização via tecla Q
local Window = Rayfield:CreateWindow({
    Name = "Saldanha Hub",
    LoadingTitle = "Saldanha Hub",
    LoadingSubtitle = "por ChatGPT",
    ConfigurationSaving = {
        Enabled = false,
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
    Keybind = Enum.KeyCode.Q, -- Tecla para minimizar a interface
})

-- Criar uma aba principal
local MainTab = Window:CreateTab("Principal", 4483362458)

-- Criar um botão de teste
MainTab:CreateButton({
    Name = "Botão de Teste",
    Callback = function()
        print("Botão de Teste clicado!")
    end,
})
