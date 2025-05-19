-- [Xotic RemoteSpy GUI - FINAL WORKING VERSION]
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "XoticRemoteSpy"
gui.ResetOnSpawn = false

local frame = Instance.new("ScrollingFrame", gui)
frame.Size = UDim2.new(0, 500, 0, 300)
frame.Position = UDim2.new(0.5, -250, 0.05, 0)
frame.CanvasSize = UDim2.new(0, 0, 1, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
frame.ScrollBarThickness = 8
frame.ClipsDescendants = true

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 3)

-- Logging function
local function log(msg)
	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, -10, 0, 22)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(0, 255, 0)
	label.Font = Enum.Font.Code
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextWrapped = true
	label.Text = msg
end

-- Format args
local function formatArgs(args)
	local out = {}
	for i, v in ipairs(args) do
		local s = typeof(v) == "string" and ('"%s"'):format(v) or tostring(v)
		table.insert(out, s)
	end
	return table.concat(out, ", ")
end

-- Hook __namecall to capture FireServer/InvokeServer
local mt = getrawmetatable(game)
setreadonly(mt, false)

local old = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	if method == "FireServer" or method == "InvokeServer" then
		local args = {...}
		local path = self:GetFullName()
		local call = ("[%s] %s(%s)"):format(method, path, formatArgs(args))
		log(call)
	end
	return old(self, ...)
end)

setreadonly(mt, true)
log("✅ RemoteSpy is now capturing FireServer/InvokeServer calls.")
