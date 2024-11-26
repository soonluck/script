local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = game.Workspace.CurrentCamera
local flying = false
local speed = 50
local bodyVelocity
local Clipon = false
local xrayActive = false

--[[
local function sendmss(message) 
    local player = game.Players.LocalPlayer
    if player then
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:Fireserver(message, "All")
    end
end

if player.UserId ~= 525935860 then
    sendmss("I love stealing with a cheat")
    task.wait(1)
    while True do
        print("⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠟⠉⠀⠙⢷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠇⠀⠀⠀⠀⠀⠹⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡟⠀⠀⠀⠀⠀⠀⠀⢹⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣁⣤⣤⡤⠤⠤⠤⢤⣼⣷⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡞⠉⠉⠀⢀⣀⣀⣀⣀⡀⠀⠀⠀⠙⢷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⢠⡴⠒⢶⣄⣤⣀⣀⣀⡀⠀⠀⠀⣸⣧⠶⠞⠛⠉⠉⠉⠉⠉⠙⠛⠳⢦⣤⣼⠃⠀⠀⠀⠀⢀⣀⠀⢀⣀⡀⠀⠀⠀
⠀⠀⢠⡟⠀⠀⠀⠉⠉⠙⠉⠉⢻⢀⣤⠞⠋⣁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠈⠙⢷⣄⠀⠀⢰⡟⠙⣿⠟⠉⠻⣆⠀⠀
⠀⣠⠾⢷⡄⠀⠀⠀⠀⠀⠀⠀⣸⡟⠁⠀⢠⠋⢧⡀⠀⠀⠀⠀⠀⠀⠀⣰⠋⢳⡀⠀⠀⠙⣷⡴⠟⠃⠀⠀⠀⠀⢀⣿⠀⠀
⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⣴⠟⠋⠁⠀⠀⠘⢂⣈⣁⠀⠀⠀⠀⠀⠀⠀⣋⣉⣛⢃⠀⠀⠀⣿⡄⠀⠀⠀⠀⠀⠀⠛⠛⢻⣄
⠸⣧⣀⠀⠀⠀⠀⠀⠀⢠⣿⠀⠀⠀⠀⠀⢾⢻⣷⡟⢳⠀⠀⠀⠀⠀⣼⢻⣿⠟⡟⠀⠀⠀⢹⡷⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿
⠀⢸⡃⠀⠀⠀⠀⠀⠀⠀⢹⣧⠖⠚⠒⢄⠘⢷⣤⡴⠟⣣⡤⠤⣤⣄⠿⢦⣥⡴⢣⠖⠉⠑⢺⡷⣦⡄⠀⠀⠀⠀⢀⣠⡾⠃
⠀⠈⠛⣶⠆⠀⠀⠀⠀⠰⣿⡇⠀⠀⠀⢈⠀⠀⠀⡴⠋⠁⠀⠀⠀⠈⠻⣦⠀⠀⢦⠀⠀⠀⠀⣿⣟⠀⠀⠀⠀⠀⠀⠈⣿⠀
⠀⠀⠀⢻⣄⣠⡀⠀⠀⢀⣾⠙⠦⠤⢤⣮⣤⣄⢰⠁⠀⠀⠀⠀⠀⠀⠀⢸⡆⢀⣈⣶⣤⠤⠊⠀⢹⡇⠀⠀⢀⣀⣠⡴⠟⠀
⠀⠀⠀⠀⠈⠙⠳⠦⠶⠿⣇⠀⠀⠀⡞⣡⠀⠈⠻⡄⠀⠀⠀⠀⠀⠀⠀⢸⡷⠛⢱⣄⠹⡆⠀⠀⠈⣿⠶⠶⠛⠉⠉⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡄⠀⠀⣇⠘⢧⡀⠀⠳⣄⡀⠀⠀⠀⢀⣴⠏⠀⣠⠞⠁⢸⠇⠀⠀⢰⠏⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⡄⠀⠙⣦⡀⠻⢦⣀⠀⠉⠓⠒⠛⠉⢀⣠⠞⠁⠀⣰⠏⠀⠀⣠⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣆⠀⠈⠳⣤⡀⠈⠙⠓⠒⠒⠒⠚⠉⠀⢀⣴⠞⠁⠀⢀⣴⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣦⡀⠀⠙⠳⢤⣀⣀⣀⣀⣠⡴⠞⠋⠀⠀⣀⣴⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠳⢦⣤⣀⣀⣉⠉⠁⣀⣀⣀⣤⡶⠞⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠙⠛⠛⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀")
        sendmss("Diddy's Party was fun")
    end
end
]]--


local function toggleFly()
    if flying then
        flying = false
        humanoid.PlatformStand = false
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
    else
        flying = true
        humanoid.PlatformStand = true

        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(500000, 500000, 500000) 
        bodyVelocity.Velocity = Vector3.new(0, 0, 0) 
        bodyVelocity.Parent = character.HumanoidRootPart
    end
end


local function toggleNoclip()
    if Clipon then
        Clipon = false
        for _, v in pairs(character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    else
        Clipon = true
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


local function toggleXRay()
    xrayActive = not xrayActive
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if xrayActive then
                obj.LocalTransparencyModifier = 0.7
            else
                obj.LocalTransparencyModifier = 0
            end
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end 
    if input.KeyCode == Enum.KeyCode.X then
        toggleFly()
        toggleNoclip()
        toggleXRay()
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if flying then
        local moveDirection = Vector3.new(0, 0, 0)

        local cameraForward = camera.CFrame.LookVector
        local cameraRight = camera.CFrame.RightVector
        local cameraUp = camera.CFrame.UpVector
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + cameraForward
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - cameraForward 
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - cameraRight
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + cameraRight
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + cameraUp
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - cameraUp
        end

        bodyVelocity.Velocity = moveDirection * speed
    end
end)
