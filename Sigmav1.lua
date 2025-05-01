--// Flashback Rewind (No GUI Version)

-- Settings
local Keybind = Enum.KeyCode.C -- Hold C to rewind
local RewindSpeed = 1.7 -- How fast to rewind
local FlashbackLength = 95 -- How long history stores (seconds)

-- Services
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Flashback frames storage
local frames = {}

-- Advance function (store frames)
local function Advance()
    if #frames > FlashbackLength * 60 then
        table.remove(frames, 1)
    end

    table.insert(frames, {
        humanoidRootPart.CFrame,
        humanoidRootPart.Velocity,
        humanoid:GetState(),
        humanoid.PlatformStand
    })
end

-- Revert function (rewind frames)
local function Revert()
    local frameCount = #frames
    if frameCount == 0 then
        Advance()
        return
    end

    for _ = 1, RewindSpeed do
        if frameCount == 0 then break end
        table.remove(frames, frameCount)
        frameCount = frameCount - 1
    end

    local lastFrame = frames[frameCount]
    table.remove(frames, frameCount)

    if lastFrame then
        humanoidRootPart.CFrame = lastFrame[1]
        humanoidRootPart.Velocity = -lastFrame[2]
        humanoid:ChangeState(lastFrame[3])
        humanoid.PlatformStand = lastFrame[4]
    end
end

-- Main loop
runService:BindToRenderStep("FlashbackRewind", Enum.RenderPriority.Camera.Value, function()
    if not character or not humanoidRootPart or not humanoid then return end

    if uis:IsKeyDown(Keybind) then
        Revert()
    else
        Advance()
    end
end)

-- Auto update on character respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    frames = {}
end)
