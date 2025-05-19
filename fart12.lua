-- [XOTIC REMOTESPY - CLEAN RESIZEABLE VERSION]
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "XoticRemoteSpy"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Make it resizable
local resizeHandle = Instance.new("Frame", frame)
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -20, 1, -20)
resizeHandle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
resizeHandle.BorderSizePixel = 0
resizeHandle.ZIndex = 10
resizeHandle.Active = true

local UIS = game:GetService("UserInputService")
local resizing = false

resizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = true
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
		local mouse = UIS:GetMouseLocation()
		local guiPos = frame.AbsolutePosition
		local newSize = Vector2.new(mouse.X - guiPos.X, mouse.Y - guiPos.Y)
		frame.Size = UDim2.new(0, math.clamp(newSize.X, 200, 1000), 0, math.clamp(newSize.Y, 150, 1000))
	end
end)

-- ScrollingFrame + Logs
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 6
scroll.ClipsDescendants = true

local layout = Instance.new("UIListLayout", scroll)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 3)

-- Log Entry Generator
local function log(msg)
	local label = Instance.new("TextLabel", scroll)
	label.Size = UDim2.new(1, -10, 0, 24)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(0, 255, 0)
	label.Font = Enum.Font.Code
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextWrapped = true
	label.Text = msg
	label.TextScaled = false
end

-- Format args
local function formatArgs(args)
	local str = ""
	for i, v in ipairs(args) do
		local val = typeof(v) == "string" and '"'..v..'"' or tostring(v)
		str = str .. val .. (i < #args and ", " or "")
	end
	return str
end

-- Only hook FireServer and InvokeServer
local function spyRemoteEvent(remote)
	if remote:IsA("RemoteEvent") then
		hookfunction(remote.FireServer, function(self, ...)
			local msg = "[FireServer] "..self:GetFullName().."("..formatArgs({...})..")"
			log(msg)
			return self:FireServer(...)
		end)
	elseif remote:IsA("RemoteFunction") then
		hookfunction(remote.InvokeServer, function(self, ...)
			local msg = "[InvokeServer] "..self:GetFullName().."("..formatArgs({...})..")"
			log(msg)
			return self:InvokeServer(...)
		end)
	end
end

-- Scan all current remotes
for _, obj in pairs(game:GetDescendants()) do
	spyRemoteEvent(obj)
end

-- Watch for new remotes
game.DescendantAdded:Connect(function(obj)
	spyRemoteEvent(obj)
end)

log("✅ RemoteSpy loaded. Do a plant collect/trade to see calls.")
