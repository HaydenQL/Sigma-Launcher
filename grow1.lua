local button = script.Parent
local player = game:GetService("Players").LocalPlayer
local backpack = player:WaitForChild("Backpack")

button.MouseButton1Click:Connect(function()
	local character = player.Character or player.CharacterAdded:Wait()
	local tool = character:FindFirstChildOfClass("Tool")

	if tool then
		local dupe = tool:Clone()
		dupe.Parent = backpack
		print("[XOTIC] Duped tool:", dupe.Name)
	else
		warn("No tool found to duplicate.")
	end
end)
