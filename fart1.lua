-- [Xotic GUI RemoteSpy - Fixed Edition]
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")

-- Setup GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "XoticRemoteSpy"
gui.ResetOnSpawn = false

local frame = Instance.new("ScrollingFrame", gui)
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.05, 0)
frame.CanvasSize = UDim2.new(0, 0, 0, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.ScrollBarThickness = 8
frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
frame.ClipsDescendants = true

local list = Instance.new("UIListLayout", frame)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Padding = UDim.new(0, 2)

-- Add label to log
local function log(msg)
	local label = Instance.new("TextLabel")
	label.Parent = frame
	label.Size = UDim2.new(1, -10, 0, 20)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(0, 255, 0)
	label.Font = Enum.Font.Code
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = msg
end

-- Format args safely
local function formatArgs(args)
	local str = ""
	for i, v in ipairs(args) do
		local val = typeof(v) == "string" and '"'..v..'"' or tostring(v)
		str = str .. val .. (i < #args and ", " or "")
	end
	return str
end

-- Hook known remote folders
local function spyRemoteEvent(remote)
	if not remote:IsA("RemoteEvent") and not remote:IsA("RemoteFunction") then return end

	local name = remote:GetFullName()
	if remote:IsA("RemoteEvent") then
		remote.OnClientEvent:Connect(function(...)
			log("[ClientEvent] " .. name .. ":FireClient(" .. formatArgs({...}) .. ")")
		end)
		hookfunction(remote.FireServer, function(self, ...)
			log("[FireServer] " .. name .. "(" .. formatArgs({...}) .. ")")
			return self:FireServer(...)
		end)
	elseif remote:IsA("RemoteFunction") then
		hookfunction(remote.InvokeServer, function(self, ...)
			log("[InvokeServer] " .. name .. "(" .. formatArgs({...}) .. ")")
			return self:InvokeServer(...)
		end)
	end
end

-- Scan game for all remotes (including deep)
for _, v in pairs(game:GetDescendants()) do
	spyRemoteEvent(v)
end

-- Watch for new ones
game.DescendantAdded:Connect(function(v)
	spyRemoteEvent(v)
end)

log("✅ RemoteSpy Loaded — click a plant or trade to capture remotes.")
