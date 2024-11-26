-- Variables globales
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = game.Workspace.CurrentCamera
local flying = false
local speed = 50 -- Vitesse de vol
local bodyVelocity -- Variable pour la vélocité du vol
local Clipon = false
local xrayActive = false

-- Fonction pour démarrer ou arrêter le vol
local function toggleFly()
    if flying then
        -- Arrêter le vol
        flying = false
        humanoid.PlatformStand = false
        if bodyVelocity then
            bodyVelocity:Destroy()  -- Supprimer la vélocité pour arrêter le vol
        end
    else
        -- Démarrer le vol
        flying = true
        humanoid.PlatformStand = true

        -- Créer un BodyVelocity pour contrôler le vol
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(500000, 500000, 500000) -- Permet de forcer les déplacements dans toutes les directions
        bodyVelocity.Velocity = Vector3.new(0, 0, 0) -- Initialiser la vélocité à 0
        bodyVelocity.Parent = character.HumanoidRootPart
    end
end

-- Fonction qui active ou désactive le noclip
local function toggleNoclip()
    if Clipon then
        Clipon = false
        -- Réactive la collision des parties
        for _, v in pairs(character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    else
        Clipon = true
        -- Désactive la collision des parties
        game:GetService("RunService").Stepped:Connect(function()
            if Clipon then
                for _, v in pairs(character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end

-- Fonction pour activer/désactiver l'effet X-ray
local function toggleXRay()
    xrayActive = not xrayActive
    -- On boucle à travers tous les objets dans le Workspace
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if xrayActive then
                -- Rend l'objet transparent et désactive les collisions (optionnel)
                obj.LocalTransparencyModifier = 0.7  -- 0 pour complètement opaque, 1 pour totalement transparent
            else
                -- Restaure la transparence des objets à leur état normal
                obj.LocalTransparencyModifier = 0
            end
        end
    end
end

-- Détecter la touche X pour alterner entre les différentes actions
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- Ignore si l'entrée est déjà traitée par le jeu
    if input.KeyCode == Enum.KeyCode.X then
        toggleFly()      -- Active/désactive le vol
        toggleNoclip()   -- Active/désactive le noclip
        toggleXRay()     -- Active/désactive l'effet X-ray
    end
end)

-- Déplacement du joueur quand il vole
game:GetService("RunService").Heartbeat:Connect(function()
    if flying then
        -- Déplacement libre en vol
        local moveDirection = Vector3.new(0, 0, 0)
        
        -- Calculer la direction de la caméra
        local cameraForward = camera.CFrame.LookVector
        local cameraRight = camera.CFrame.RightVector
        local cameraUp = camera.CFrame.UpVector
        
        -- Ajouter les entrées de mouvement pour les touches W, A, S, D, etc.
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + cameraForward -- Avancer selon la direction de la caméra
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - cameraForward -- Reculer selon la direction de la caméra
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - cameraRight -- Déplacer à gauche selon la direction de la caméra
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + cameraRight -- Déplacer à droite selon la direction de la caméra
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + cameraUp -- Voler vers le haut
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - cameraUp -- Voler vers le bas
        end

        -- Appliquer le mouvement
        bodyVelocity.Velocity = moveDirection * speed
    end
end)
