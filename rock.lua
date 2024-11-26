-- LocalScript (place this in the StarterGui)
local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
    else
        warn("Clipboard functionality is not supported.")
    end
end

local function getBiggestRockPlayer()
    local biggestRockPlayer = nil
    local biggestRockValue = -math.huge -- Start with a very low value

    -- Iterate over all players
    for _, player in ipairs(game.Players:GetPlayers()) do
        local rockAge = player:FindFirstChild("RockAge") -- Assuming "RockAge" is a NumberValue under the player

        if rockAge and rockAge.Value > biggestRockValue then
            biggestRockPlayer = player
            biggestRockValue = rockAge.Value
            copyToClipboard(biggestRockPlayer.Name)
        end
    end

    return biggestRockPlayer, biggestRockValue
end

local function createPopup(playerName, rockAgeInSeconds)
    -- Convert RockAge value (in seconds) to days
    local rockAgeInDays = rockAgeInSeconds / 86400 -- 86400 seconds in a day

    -- Create the pop-up GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BiggestRockPopup"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0.5, -50)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.Parent = screenGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = playerName .. " Got the biggest rock with " .. math.floor(rockAgeInDays) .. " days"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.BackgroundTransparency = 1
    label.Parent = frame

    -- Automatically remove the pop-up after 5 seconds
    wait(1)
    screenGui:Destroy()
end

-- When the game starts, show the pop-up
local biggestRockPlayer, biggestRockValue = getBiggestRockPlayer()
if biggestRockPlayer then
    createPopup(biggestRockPlayer.Name, biggestRockValue)
end


local Players = game:GetService("Players")

-- Function to create or update a BillboardGui above each player's head
local function updateRockAgeDisplay(player)
    -- Check if the player has a "RockAge" value
    local rockAge = player:FindFirstChild("RockAge")
    if rockAge and rockAge:IsA("NumberValue") then
        -- Find existing BillboardGui or create a new one
        local billboardGui = player.Character:FindFirstChild("RockAgeDisplay")
        if not billboardGui then
            billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = "RockAgeDisplay"
            billboardGui.Adornee = player.Character:WaitForChild("Head")
            billboardGui.Parent = player.Character:WaitForChild("Head")
            billboardGui.Size = UDim2.new(0, 100, 0, 50)
            billboardGui.StudsOffset = Vector3.new(0, 3, 0)  -- Offset above the head

            -- Create a TextLabel inside the BillboardGui
            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "RockAgeLabel"
            textLabel.Parent = billboardGui
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text
            textLabel.TextScaled = true
            textLabel.TextStrokeTransparency = 0.5  -- Slight stroke for better visibility
        end

        -- Function to update the display dynamically
        local function refreshDisplay()
            local days = math.floor(rockAge.Value / 86400)  -- 86400 seconds in a day
            billboardGui.RockAgeLabel.Text = "RockAge: " .. tostring(days) .. " Day(s)"
            
            -- Change the text color to red if the RockAge is 30 days or more
            if days >= 1000 then
                billboardGui.RockAgeLabel.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Red
            elseif days < 1000 and days >= 100 then
                billboardGui.RockAgeLabel.TextColor3 = Color3.fromRGB(0, 255, 0) 
            else
                billboardGui.RockAgeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White
            end
        end

        -- Update initially and connect to RockAge.Changed
        refreshDisplay()
        rockAge.Changed:Connect(refreshDisplay)
    end
end

-- When a player joins, set up their BillboardGui
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        -- Wait for the character to fully load
        character:WaitForChild("Head")
        updateRockAgeDisplay(player)
    end)
end)

-- For existing players in the game
for _, player in pairs(Players:GetPlayers()) do
    if player.Character then
        updateRockAgeDisplay(player)
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- GUI Creation
local gui = Instance.new("ScreenGui")
gui.Name = "TeleportGui"
gui.Parent = player:WaitForChild("PlayerGui")

-- Draggable Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
title.Text = "Teleport Tool GUI"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.FredokaOne
title.TextScaled = true
title.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.8, 0, 0, 40)
textBox.Position = UDim2.new(0.1, 0, 0.3, 0)
textBox.PlaceholderText = "Enter player name"
textBox.Text = ""
textBox.Font = Enum.Font.SourceSans
textBox.TextScaled = true
textBox.BackgroundColor3 = Color3.new(1, 1, 1)
textBox.TextColor3 = Color3.new(0, 0, 0)
textBox.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.5, 0, 0, 40)
button.Position = UDim2.new(0.25, 0, 0.7, 0)
button.Text = "Confirm"
button.Font = Enum.Font.SourceSansBold
button.TextScaled = true
button.BackgroundColor3 = Color3.new(0.3, 0.7, 0.3)
button.TextColor3 = Color3.new(1, 1, 1)
button.Parent = frame

-- Floating and Teleport Logic
local tool = nil
local targetPlayer = nil
local floating = false
local floatConnection = nil

-- Function to find a player by partial name
local function findPlayerByPartialName(partialName)
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if string.lower(targetPlayer.Name):find(string.lower(partialName)) then
            return targetPlayer
        end
    end
    return nil
end

-- Function to smoothly move the character to the target position
local function smoothMove(targetPosition)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        -- Create a tween for smooth movement (very fast like teleport)
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local tweenInfo = TweenInfo.new(
            0.1, -- Duration of the movement (0.1 seconds for fast transition)
            Enum.EasingStyle.Sine, -- Easing style for smooth transition
            Enum.EasingDirection.Out, -- Easing direction
            0, -- RepeatCount (no repeat)
            false, -- Reverses
            0 -- DelayTime
        )
        local tweenGoal = {CFrame = CFrame.new(targetPosition)} -- Target position
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, tweenGoal)
        tween:Play() -- Play the tween
    end
end

-- Start floating function
local function startFloating(character)
    -- Ensure floating if not already floating
    if not floating then
        floating = true
        -- Start following the model
        floatConnection = RunService.RenderStepped:Connect(function()
            if targetPlayer and targetPlayer.Character then
                local character = targetPlayer.Character
                local tool = character:FindFirstChildOfClass("Tool")

                if tool and tool.Name == "Rock" and tool:FindFirstChild("Handle") then
                    -- If holding Rock, float 2 studs below the Handle (for "Rock")
                    local handle = tool.Handle
                    local newPosition = handle.Position + Vector3.new(0, -2, 0)
                    smoothMove(newPosition) -- Fast transition to the new position
                else
                    -- Otherwise, always follow the character 10 studs below it
                    if character.PrimaryPart then
                        local newPosition = character.PrimaryPart.Position + Vector3.new(0, -15, 0)
                        smoothMove(newPosition) -- Fast transition to the new position
                    end
                end
            end
        end)
    end
end

-- Stop floating function
local function stopFloating()
    if floatConnection then
        floatConnection:Disconnect()
        floatConnection = nil
    end
    floating = false
    if targetPlayer and targetPlayer.Character and targetPlayer.Character.PrimaryPart then
        -- Go back to 10 studs below the model's primary part
        local returnPosition = targetPlayer.Character.PrimaryPart.Position + Vector3.new(0, -20, 0)
        smoothMove(returnPosition) -- Fast transition to the new position
    end
end

-- Button click logic
button.MouseButton1Click:Connect(function()
    local partialName = textBox.Text
    targetPlayer = findPlayerByPartialName(partialName)

    if targetPlayer and targetPlayer.Character then
        -- Target player and start following
        startFloating(targetPlayer.Character)
        
        -- Monitor tool holding changes
        targetPlayer.Character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and child.Name == "Rock" then
                startFloating(targetPlayer.Character) -- Start following when "Rock" is equipped
            end
        end)

        targetPlayer.Character.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") and child.Name == "Rock" then
                -- Continue following at -10 below if "Rock" is unequipped
                startFloating(targetPlayer.Character) 
            end
        end)
        
    else
        warn("Player not found or not in game")
    end
end)
