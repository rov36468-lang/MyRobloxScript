-- =========================================================================
-- ⭐ สคริปต์ฝึกเขียนพื้นฐาน (Roblox Lua GUI) ⭐
-- =========================================================================
-- โค้ดนี้จะสร้างหน้าต่าง GUI เล็กๆ กลางจอภาพขึ้นมา ซึ่งคุณสามารถลากไปมาและกดปิดได้
-- เหมาะสำหรับการเริ่มต้นเรียนรู้วิธีการเขียน UI ใน Roblox

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. สร้าง ScreenGui (ตัวครอบ UI ทั้งหมด)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyFirstPracticeGUI"
screenGui.ResetOnSpawn = false -- ตายแล้ว UI ไม่หาย

-- ตรวจสอบและเลือกใส่ใน CoreGui (สำหรับ Executor) หรือ PlayerGui (ทั่วไป)
local success, coreGui = pcall(function()
    return game:GetService("CoreGui")
end)
if success and coreGui then
    screenGui.Parent = coreGui
else
    screenGui.Parent = playerGui
end

-- 2. สร้าง Main Frame (พื้นหลังหน้าต่างสีเข้มสวยงาม)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 180) -- กว้าง 320, สูง 180 พิกเซล
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -90) -- วางตรงกลางจอพอดี
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35) -- สีเทาเข้มโทนโมเดิร์น
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- ทำให้สามารถคลิกลากไปมาบนหน้าจอได้
mainFrame.Parent = screenGui

-- ใส่ขอบมน (UICorner) ให้หน้าต่างหลักดูพรีเมียมขึ้น
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12) -- ความมน 12 พิกเซล
frameCorner.Parent = mainFrame

-- 3. สร้าง Title Text (หัวข้อการใช้งาน)
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundTransparency = 1 -- พื้นหลังโปร่งใส
titleLabel.Text = "⭐ Star Hub | Practice UI"
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- สีทอง
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- 4. สร้างข้อความแนะนำเนื้อหา (Description)
local descLabel = Instance.new("TextLabel")
descLabel.Name = "Description"
descLabel.Size = UDim2.new(1, -30, 0, 60)
descLabel.Position = UDim2.new(0, 15, 0, 45)
descLabel.BackgroundTransparency = 1
descLabel.Text = "ยินดีด้วย! คุณรันสคริปต์นี้สำเร็จแล้ว\nนี่คือหน้าต่าง UI แรกของคุณ ลองจับลากไปมาได้เลย!"
descLabel.TextColor3 = Color3.fromRGB(230, 230, 230) -- สีขาวสว่าง
descLabel.TextSize = 14
descLabel.Font = Enum.Font.Gotham
descLabel.TextWrapped = true -- เปิดการจัดบรรทัดอัตโนมัติ
descLabel.Parent = mainFrame

-- 5. สร้างปุ่มสำหรับกดปิดสคริปต์ (Close Button)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 120, 0, 35)
closeButton.Position = UDim2.new(0.5, -60, 1, -50) -- จัดให้อยู่ด้านล่างตรงกลาง
closeButton.BackgroundColor3 = Color3.fromRGB(235, 77, 75) -- สีแดง
closeButton.Text = "ปิดหน้าต่างนี้"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

-- ใส่ขอบมนให้ปุ่มปิด
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = closeButton

-- 6. การกำหนดการทำงานเมื่อกดปุ่ม (Event Listener)
closeButton.MouseButton1Click:Connect(function()
    -- เอฟเฟกต์ค่อยๆ จางหายก่อนจะปิดจริง (Fade Out)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenFrame = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
    
    tweenFrame:Play()
    tweenFrame.Completed:Wait() -- รอให้เอฟเฟกต์ทำเสร็จก่อนค่อยลบ UI ทิ้ง
    screenGui:Destroy()
end)

-- 7. แจ้งเตือนผ่านระบบของเกมเมื่อสคริปต์ทำงานสำเร็จ
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "✨ Star Hub",
        Text = "โหลดสคริปต์สำเร็จ!",
        Duration = 3
    })
end)

print("[Star Hub] Practice script loaded successfully!")
