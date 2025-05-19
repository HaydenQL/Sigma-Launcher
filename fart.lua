-- [XOTIC RemoteSpy GUI] by ErrayKing
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "XoticRemoteSpy"

local frame = Instance.new("ScrollingFrame", gui)
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.1, 0)
frame.CanvasSize = UDim2.new(0, 0, 2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.ScrollBarThickness = 6

local UIList = Instance.new("UIListLayout", frame)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Function to add log
local function logRemote(txt)
	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, -10, 0, 20)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(0, 255, 0)
	label.Font = Enum.Font.Code
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = txt
end

-- Format args cleanly
local function formatArgs(args)
	local str = ""
	for i, v in ipairs(args) do
		local val = typeof(v) == "string" and '"'..v..'"' or tostring(v)
		str = str .. val .. (i < #args and ", " or "")
	end
	return str
end

-- Hook all remote calls (FireServer / InvokeServer)
for _, v in pairs(getgc(true)) do
	if typeof(v) == "function" and islclosure(v) and not isexecutorclosure(v) then
		local info = debug.getinfo(v)
		if info.name == "FireServer" or info.name == "InvokeServer" then
			hookfunction(v, function(self, ...)
				local args = {...}
				local msg = "[RemoteSpy] "..tostring(self)..":"..info.name.."("..formatArgs(args)..")"
				logRemote(msg)
				return v(self, ...)
			end)
		end
	end
end

logRemote("✅ RemoteSpy GUI Loaded — click a plant or trade to capture.")
