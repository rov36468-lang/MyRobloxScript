-- =========================================================================
-- ⭐ ALL STAR TOWER DEFENSE - MULTI-TAB GUI HACK ⭐
-- =========================================================================
-- สคริปต์นี้จะสร้างหน้าต่างเมนูช่วยเล่น (Hub UI) ที่แบ่งแท็บออกเป็น 5 หน้าหลักตามต้องการ:
-- สามารถคลิกลากหน้าต่าง ย่อ/ขยาย และเปลี่ยนแท็บแบบมีเอฟเฟกต์สมูทได้

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ASTD_PremiumHub"
screenGui.ResetOnSpawn = false

local success, coreGui = pcall(function()
    return game:GetService("CoreGui")
end)
if success and coreGui then
    screenGui.Parent = coreGui
else
    screenGui.Parent = playerGui
end

-- 2. หน้าต่างหลัก (Main Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 560, 0, 360)
mainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(24, 20, 36) -- สีม่วงเข้มโทนสไตล์อนิเมะ
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

-- 3. แถบข้างซ้ายสำหรับปุ่มเมนู (Sidebar)
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 160, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(18, 15, 27) -- สีเข้มกว่าพื้นหลังหลักเล็กน้อยเพื่อมิติ
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 16)
sidebarCorner.Parent = sidebar

-- ตัวบังขอบมนขวาของ Sidebar (เพื่อให้ขอบข้างในตรง แต่ขอบด้านซ้ายมน)
local sidebarPatch = Instance.new("Frame")
sidebarPatch.Name = "Patch"
sidebarPatch.Size = UDim2.new(0, 20, 1, 0)
sidebarPatch.Position = UDim2.new(1, -20, 0, 0)
sidebarPatch.BackgroundColor3 = Color3.fromRGB(18, 15, 27)
sidebarPatch.BorderSizePixel = 0
sidebarPatch.Parent = sidebar

-- หัวข้อโลโก้ใน Sidebar
local logoLabel = Instance.new("TextLabel")
logoLabel.Name = "Logo"
logoLabel.Size = UDim2.new(1, 0, 0, 60)
logoLabel.BackgroundTransparency = 1
logoLabel.Text = "🌟 STAR HUB 🌟"
logoLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- สีทอง
logoLabel.TextSize = 18
logoLabel.Font = Enum.Font.GothamBold
logoLabel.Parent = sidebar

-- 4. พื้นที่แสดงเนื้อหาด้านขวา (Content Area)
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -170, 1, -20)
contentArea.Position = UDim2.new(0, 165, 0, 10)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

-- 5. กลุ่มหน้าเพจต่างๆ (Pages)
local pages = {}
local activePage = nil

local function createPage(pageName)
    local pageFrame = Instance.new("Frame")
    pageFrame.Name = pageName .. "Page"
    pageFrame.Size = UDim2.new(1, 0, 1, 0)
    pageFrame.BackgroundTransparency = 1
    pageFrame.Visible = false
    pageFrame.Parent = contentArea
    
    -- ใส่หัวข้อในหน้านั้นๆ
    local header = Instance.new("TextLabel")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundTransparency = 1
    header.Text = pageName
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.TextSize = 22
    header.Font = Enum.Font.GothamBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = pageFrame
    
    pages[pageName] = pageFrame
    return pageFrame
end

-- สร้างหน้าทั้ง 5 แท็บ
local pageHome = createPage("หน้าหลัก")
local pageMacro = createPage("มาโคร")
local pageRaid = createPage("ลงเรท")
local pageAisen = createPage("ลงไอเซ็น")
local pageSettings = createPage("ตั้งค่า")

-- 6. ระบบสลับแท็บ (Tab Navigation System)
local sidebarButtons = Instance.new("UIListLayout")
sidebarButtons.Parent = sidebar
sidebarButtons.SortOrder = Enum.SortOrder.LayoutOrder
sidebarButtons.Padding = UDim.new(0, 5)

-- เว้นระยะบนสุดใต้โลโก้
local spacer = Instance.new("Frame")
spacer.Size = UDim2.new(1, 0, 0, 55)
spacer.BackgroundTransparency = 1
spacer.LayoutOrder = 0
spacer.Parent = sidebar

local function makeMenuButton(name, layoutOrder)
    local button = Instance.new("TextButton")
    button.Name = name .. "Btn"
    button.Size = UDim2.new(1, -20, 0, 35)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(25, 21, 38)
    button.BackgroundTransparency = 1
    button.Text = "  " .. name
    button.TextColor3 = Color3.fromRGB(180, 180, 180)
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.LayoutOrder = layoutOrder
    button.Parent = sidebar
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    -- ใส่ Padding ซ้ายให้ตัวหนังสือไม่ติดขอบเกินไป
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.Parent = button

    -- ฟังก์ชันเอฟเฟกต์การสลับหน้าเมื่อคลิก
    button.MouseButton1Click:Connect(function()
        -- ลบสถานะแอคทีฟจากปุ่มเก่า
        for _, child in ipairs(sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.2), {
                    BackgroundTransparency = 1,
                    TextColor3 = Color3.fromRGB(180, 180, 180)
                }):Play()
            end
        end
        
        -- ใส่เอฟเฟกต์แอคทีฟให้ปุ่มปัจจุบัน (สว่างและไฮไลท์ขอบขึ้น)
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(45, 36, 68),
            TextColor3 = Color3.fromRGB(255, 215, 0) -- ไฮไลท์ตัวอักษรสีทอง
        }):Play()
        
        -- ซ่อนทุกหน้า แล้วแสดงเฉพาะหน้าที่เลือก
        for pName, pFrame in pairs(pages) do
            if pName == name then
                pFrame.Visible = true
            else
                pFrame.Visible = false
            end
        end
    end)
    
    return button
end

-- สร้างปุ่มที่ Sidebar
local btnHome = makeMenuButton("หน้าหลัก", 1)
local btnMacro = makeMenuButton("มาโคร", 2)
local btnRaid = makeMenuButton("ลงเรท", 3)
local btnAisen = makeMenuButton("ลงไอเซ็น", 4)
local btnSettings = makeMenuButton("ตั้งค่า", 5)

-- ตั้งค่าเริ่มต้นที่หน้าแรก (หน้าหลัก)
btnHome.BackgroundTransparency = 0
btnHome.BackgroundColor3 = Color3.fromRGB(45, 36, 68)
btnHome.TextColor3 = Color3.fromRGB(255, 215, 0)
pageHome.Visible = true

-- 7. ปุ่มปิดเมนูทั้งหมด
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(235, 77, 75)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tween:Play()
    tween.Completed:Wait()
    screenGui:Destroy()
end)

-- 8. คำอธิบายตัวอย่างแต่ละหน้าเพจ (ตรงนี้เอาไว้ใส่ปุ่ม/สวิตช์เปิดปิดฟังก์ชันในอนาคตครับ)

-- หน้าหลัก (หน้าแรก)
local homeDesc = Instance.new("TextLabel")
homeDesc.Size = UDim2.new(1, 0, 0, 200)
homeDesc.Position = UDim2.new(0, 0, 0, 40)
homeDesc.BackgroundTransparency = 1
homeDesc.Text = "ยินดีต้อนรับสู่ Star Hub (ASTD Edition)\n\nผู้ใช้งาน: " .. player.Name .. "\nสถานะสคริปต์: พร้อมทำงาน\n\nกรุณาเลือกแท็บเมนูข้างซ้ายเพื่อเลือกใช้ฟังก์ชันช่วยเล่นที่คุณต้องการครับ"
homeDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
homeDesc.TextSize = 15
homeDesc.Font = Enum.Font.Gotham
homeDesc.TextWrapped = true
homeDesc.TextXAlignment = Enum.TextXAlignment.Left
homeDesc.TextYAlignment = Enum.TextYAlignment.Top
homeDesc.Parent = pageHome

-- หน้ามาโคร
local macroDesc = Instance.new("TextLabel")
macroDesc.Size = UDim2.new(1, 0, 0, 100)
macroDesc.Position = UDim2.new(0, 0, 0, 40)
macroDesc.BackgroundTransparency = 1
macroDesc.Text = "ระบบบันทึกและรัน มาโคร (Macro Auto Play)\n(ฟังก์ชันการบันทึกตำแหน่งคลิกวางตัวละครอัตโนมัติ)"
macroDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
macroDesc.TextSize = 14
macroDesc.Font = Enum.Font.Gotham
macroDesc.TextWrapped = true
macroDesc.TextXAlignment = Enum.TextXAlignment.Left
macroDesc.Parent = pageMacro

-- หน้าลงเรท
local raidDesc = Instance.new("TextLabel")
raidDesc.Size = UDim2.new(1, 0, 0, 100)
raidDesc.Position = UDim2.new(0, 0, 0, 40)
raidDesc.BackgroundTransparency = 1
raidDesc.Text = "ระบบช่วยลงเรทอัตโนมัติ (Auto Raid)\n- ออโต้เลือกห้องเรท\n- ออโต้กดพร้อมเล่น\n- ระบบลูปฟาร์มเรท"
raidDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
raidDesc.TextSize = 14
raidDesc.Font = Enum.Font.Gotham
raidDesc.TextWrapped = true
raidDesc.TextXAlignment = Enum.TextXAlignment.Left
raidDesc.Parent = pageRaid

-- หน้าลงไอเซ็น
local aisenDesc = Instance.new("TextLabel")
aisenDesc.Size = UDim2.new(1, 0, 0, 100)
aisenDesc.Position = UDim2.new(0, 0, 0, 40)
aisenDesc.BackgroundTransparency = 1
aisenDesc.Text = "ระบบออโต้ฟาร์ม ลงไอเซ็น (Aizen Raid Auto Farm)\n- ฟาร์มด่านไอเซ็นเพื่อรับของรางวัลระดับสูง\n- ตั้งค่าเวฟที่ต้องการกดยอมแพ้ (Auto Rejoin)"
aisenDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
aisenDesc.TextSize = 14
aisenDesc.Font = Enum.Font.Gotham
aisenDesc.TextWrapped = true
aisenDesc.TextXAlignment = Enum.TextXAlignment.Left
aisenDesc.Parent = pageAisen

-- หน้าตั้งค่า
local settingsDesc = Instance.new("TextLabel")
settingsDesc.Size = UDim2.new(1, 0, 0, 100)
settingsDesc.Position = UDim2.new(0, 0, 0, 40)
settingsDesc.BackgroundTransparency = 1
settingsDesc.Text = "การตั้งค่าระบบทั่วไป\n- ออโต้ข้ามเวฟ (Auto Skip Wave)\n- เปิด/ปิด แสงและเอฟเฟกต์เพื่อลดอาการแลค (FPS Booster)"
settingsDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
settingsDesc.TextSize = 14
settingsDesc.Font = Enum.Font.Gotham
settingsDesc.TextWrapped = true
settingsDesc.TextXAlignment = Enum.TextXAlignment.Left
settingsDesc.Parent = pageSettings

-- 9. แจ้งเตือนสคริปต์โหลดเสร็จสิ้น
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "✨ Star Hub UI",
        Text = "โหลด UI เมนูแท็บเสร็จเรียบร้อย!",
        Duration = 3
    })
end)

print("[Star Hub] Multi-tab Premium UI loaded successfully!")
