local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 60

local bv, bg

-- ================= UI =================
local gui = Instance.new("ScreenGui")
gui.Name = "TIENZ_FLY_GUI"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 200)
frame.Position = UDim2.new(0.5, -90, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = frame

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.Text = "TIENZ FLY"
title.TextColor3 = Color3.fromRGB(0,170,255)
title.BackgroundTransparency = 1
title.TextScaled = true
title.Parent = frame

-- BUTTON FLY
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.8,0,0,40)
btn.Position = UDim2.new(0.1,0,0.25,0)
btn.Text = "FLY OFF"
btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.Parent = btn

-- SPEED TEXT
local speedText = Instance.new("TextLabel")
speedText.Size = UDim2.new(1,0,0,20)
speedText.Position = UDim2.new(0,0,0.55,0)
speedText.Text = "Speed: 60"
speedText.TextColor3 = Color3.fromRGB(255,255,255)
speedText.BackgroundTransparency = 1
speedText.Parent = frame

-- SLIDER BAR
local bar = Instance.new("Frame")
bar.Size = UDim2.new(0.8,0,0,10)
bar.Position = UDim2.new(0.1,0,0.7,0)
bar.BackgroundColor3 = Color3.fromRGB(70,70,70)
bar.Parent = frame

local barCorner = Instance.new("UICorner")
barCorner.Parent = bar

local knob = Instance.new("Frame")
knob.Size = UDim2.new(0,14,0,14)
knob.BackgroundColor3 = Color3.fromRGB(0,170,255)
knob.Position = UDim2.new(0,0,-0.2,0)
knob.Parent = bar

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1,0)
knobCorner.Parent = knob

-- ================= FLY SYSTEM =================
local function startFly()
	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(9e9,9e9,9e9)
	bv.Parent = hrp

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
	bg.P = 9e4
	bg.CFrame = hrp.CFrame
	bg.Parent = hrp

	flying = true
	btn.Text = "FLY ON"
	btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
end

local function stopFly()
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end

	flying = false
	btn.Text = "FLY OFF"
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
end

btn.MouseButton1Click:Connect(function()
	if flying then
		stopFly()
	else
		startFly()
	end
end)

-- ================= MOVE =================
RunService.RenderStepped:Connect(function()
	if flying then
		local cam = workspace.CurrentCamera
		local move = Vector3.new()

		if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end

		if move.Magnitude > 0 then
			bv.Velocity = move.Unit * speed
		else
			bv.Velocity = Vector3.zero
		end

		bg.CFrame = cam.CFrame
	end
end)

-- ================= SLIDER =================
local dragging = false

local function updateSlider(x)
	local pos = bar.AbsolutePosition.X
	local size = bar.AbsoluteSize.X

	local p = math.clamp((x - pos) / size, 0, 1)

	knob.Position = UDim2.new(p, -7, -0.2, 0)

	speed = math.floor(20 + p * 200)
	speedText.Text = "Speed: " .. speed
end

knob.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or
	   i.UserInputType == Enum.UserInputType.Touch then
		dragging = true
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		updateSlider(i.Position.X)
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
