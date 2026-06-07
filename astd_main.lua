-- =========================================================================
-- ⭐ ALL STAR TOWER DEFENSE UNIVERSAL LOADER (NO MAP CHECK) ⭐
-- =========================================================================

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ASTD_LoaderGUI"
screenGui.ResetOnSpawn = false

local success, coreGui = pcall(function()
    return game:GetService("CoreGui")
end)
if success and coreGui then
    screenGui.Parent = coreGui
else
    screenGui.Parent = playerGui
end

-- 2. สร้าง Main Frame หน้าจอโหลด
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 360, 0, 200)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(24, 20, 36)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 16)
frameCorner.Parent = mainFrame

-- 3. หัวข้อสคริปต์
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🌟 All Star Tower Defense Loader"
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- 4. ข้อความสถานะการโหลด
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, -30, 0, 80)
statusLabel.Position = UDim2.new(0, 15, 0, 50)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "กำลังเริ่มระบบการทำงาน..."
statusLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextWrapped = true
statusLabel.Parent = mainFrame

-- 5. ปุ่มปิดหน้าต่าง
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 120, 0, 35)
closeButton.Position = UDim2.new(0.5, -60, 1, -45)
closeButton.BackgroundColor3 = Color3.fromRGB(235, 77, 75)
closeButton.Text = "ปิดหน้านี้"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    local tweenFrame = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tweenFrame:Play()
    tweenFrame.Completed:Wait()
    screenGui:Destroy()
end)

-- 6. ระบบทำงานอัตโนมัติโดยไม่มีการตรวจเช็คแมพ
task.spawn(function()
    task.wait(1.5) -- หน่วงจำลองการโหลดเพื่อให้สวยงาม
    
    statusLabel.Text = "✅ โหลดระบบสำเร็จ!\nยินดีต้อนรับสู่ตัวช่วยเล่นของคุณ"
    statusLabel.TextColor3 = Color3.fromRGB(46, 204, 113) -- สีเขียวแสดงสถานะผ่าน
    
    task.wait(1)
    
    -- [[ ถ้าคุณมีโค้ดช่วยเล่น หรือฟังก์ชันอื่นเพิ่มเติม สามารถนำมาวางรันตรงนี้ได้เลยครับ ]]
end)
