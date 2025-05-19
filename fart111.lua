-- FINAL WORKING REMOTESPY GUI (ONLY FIRE/INVOKE SERVER)
local player = game:GetService("Players").LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "XoticRemoteSpy"
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 8
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ClipsDescendants = true

local layout = Instance.new("UIListLayout", scroll)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 4)

-- Logging function
local function log(text)
	local label = Instance.new("TextLabel", scroll)
	label.Size = UDim2.new(1, -10, 0, 22)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(0, 255, 0)
	label.Font = Enum.Font.Code
	label.TextSize = 14
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = text
end

-- Format args safely
local function formatArgs(args)
	local parts = {}
	for _, v in ipairs(args) do
		local str = typeof(v) == "string" and ('"%s"'):format(v) or tostring(v)
		table.insert(parts, str)
	end
	return table.concat(parts, ", ")
end

-- Hook __namecall to catch FireServer & InvokeServer
local mt = getrawmetatable(game)
setreadonly(mt, false)

local old = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	if (method == "FireServer" or method == "InvokeServer") and typeof(self) == "Instance" then
		local args = {...}
		local name = self:GetFullName()
		local msg = string.format("[%s] %s(%s)", method, name, formatArgs(args))
		log(msg)
	end
	return old(self, ...)
end)

setreadonly(mt, true)

log("✅ RemoteSpy is active. Perform a trade or collect a plant.")
