local button = script.Parent
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

button.MouseButton1Click:Connect(function()
	local character = player.Character
	if not character then return end

	local tool = character:FindFirstChildOfClass("Tool")
	if tool then
		local dupe = tool:Clone()
		dupe.Parent = backpack
		print("[XOTIC] Duplicated:", dupe.Name)
	else
		warn("No tool found to duplicate.")
	end
end)
