-- Make GUI
local player = game:GetService("Players").LocalPlayer
local backpack = player:WaitForChild("Backpack")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "DupeGui"

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 120, 0, 40)
btn.Position = UDim2.new(0.5, -60, 0.8, 0)
btn.Text = "Dupe Tool"
btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
btn.TextColor3 = Color3.new(1,1,1)
btn.Parent = gui

-- Dupe logic
btn.MouseButton1Click:Connect(function()
	local character = player.Character or player.CharacterAdded:Wait()
	local tool = character:FindFirstChildOfClass("Tool")

	if tool then
		local dupe = tool:Clone()
		dupe.Parent = backpack
		print("[XOTIC] Duped:", dupe.Name)
	else
		warn("No tool found to dupe.")
	end
end)
