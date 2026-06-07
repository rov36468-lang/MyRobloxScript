-- =========================================================================
-- ⭐ พี่หล่อไหมน้อง Hub - MULTI-TAB GUI HACK ⭐
-- =========================================================================
-- สคริปต์นี้สร้างหน้าต่างเมนูช่วยเล่น (Hub UI) ที่มาพร้อมกับระบบ Scrollable Page
-- และแสดง "หัวข้อเล็ก" (Sub-Headers) รวมถึงกล่องรายการรายละเอียดด้านขวาในแต่ละแท็บอย่างสวยงาม
-- ปรับเปลี่ยนชื่อโปรเจกต์เป็น: พี่หล่อไหมน้อง

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HandsomeBro_Hub"
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
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 14, 32) -- สีกรมเข้มโทนอนิเมะฟ้า
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
sidebar.BackgroundColor3 = Color3.fromRGB(5, 10, 25)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 16)
sidebarCorner.Parent = sidebar

-- ตัวบังขอบมนขวาของ Sidebar (แยกไว้นอกระบบ Layout เพื่อไม่ให้ดึงปุ่มลงไปด้านล่าง)
local sidebarPatch = Instance.new("Frame")
sidebarPatch.Name = "Patch"
sidebarPatch.Size = UDim2.new(0, 20, 1, 0)
sidebarPatch.Position = UDim2.new(1, -20, 0, 0)
sidebarPatch.BackgroundColor3 = Color3.fromRGB(5, 10, 25)
sidebarPatch.BorderSizePixel = 0
sidebarPatch.Parent = sidebar

-- โลโก้รูปตัวละครอนิเมะ (ImageLabel)
local logoImg = Instance.new("ImageLabel")
logoImg.Name = "LogoImage"
logoImg.Size = UDim2.new(0, 50, 0, 50)
logoImg.Position = UDim2.new(0.5, -25, 0, 5)
logoImg.BackgroundTransparency = 1
logoImg.Image = "rbxassetid://7072706663" -- Anime girl silhouette asset
logoImg.ImageColor3 = Color3.fromRGB(100, 210, 255)
logoImg.Parent = sidebar

local logoLabel = Instance.new("TextLabel")
logoLabel.Name = "Logo"
logoLabel.Size = UDim2.new(1, 0, 0, 60)
logoLabel.Position = UDim2.new(0, 0, 0, 0)
logoLabel.BackgroundTransparency = 1
logoLabel.Text = "💠 พี่หล่อไหมน้อง"
logoLabel.TextColor3 = Color3.fromRGB(100, 210, 255) -- สีฟ้าซีเรียน
logoLabel.TextSize = 13
logoLabel.Font = Enum.Font.GothamBold
logoLabel.TextYAlignment = Enum.TextYAlignment.Bottom
logoLabel.Parent = sidebar

-- 4. คอนเทนเนอร์สำหรับใส่เฉพาะปุ่ม (Button Container)
local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(1, 0, 1, -65)
buttonContainer.Position = UDim2.new(0, 0, 0, 60)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = sidebar

local sidebarButtons = Instance.new("UIListLayout")
sidebarButtons.Parent = buttonContainer
sidebarButtons.SortOrder = Enum.SortOrder.LayoutOrder
sidebarButtons.Padding = UDim.new(0, 6)
sidebarButtons.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- 5. พื้นที่แสดงเนื้อหาด้านขวา (Content Area)
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -180, 1, -20)
contentArea.Position = UDim2.new(0, 170, 0, 10)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

-- 6. ระบบสร้างหน้าเพจแบบเลื่อนขึ้นลงได้ (Scrolling Pages)
local pages = {}

local function createPage(pageName)
    local pageFrame = Instance.new("ScrollingFrame")
    pageFrame.Name = pageName .. "Page"
    pageFrame.Size = UDim2.new(1, 0, 1, 0)
    pageFrame.BackgroundTransparency = 1
    pageFrame.Visible = false
    pageFrame.ScrollBarThickness = 4
    pageFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 70, 100)
    pageFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    pageFrame.Parent = contentArea
    
    -- จัดเรียงอัตโนมัติแนวตั้ง
    local layout = Instance.new("UIListLayout")
    layout.Parent = pageFrame
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 5)
    pad.PaddingRight = UDim.new(0, 12)
    pad.PaddingTop = UDim.new(0, 5)
    pad.PaddingBottom = UDim.new(0, 15)
    pad.Parent = pageFrame
    
    -- ปรับขนาดความยาวหน้าเพจตามจำนวนหัวข้อย่อยอัตโนมัติ
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pageFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)

    -- หัวข้อเพจขนาดใหญ่
    local header = Instance.new("TextLabel")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BackgroundTransparency = 1
    header.Text = pageName
    header.TextColor3 = Color3.fromRGB(150, 225, 255)
    header.TextSize = 22
    header.Font = Enum.Font.GothamBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.LayoutOrder = 0
    header.Parent = pageFrame
    
    pages[pageName] = pageFrame
    return pageFrame
end

-- ฟังก์ชันสร้าง "หัวข้อเล็ก" (Sub-Header) ในแต่ละหน้า
local function createSubHeader(pageFrame, text, layoutOrder)
    local subHeader = Instance.new("TextLabel")
    subHeader.Name = "SubHeader_" .. text
    subHeader.Size = UDim2.new(1, 0, 0, 24)
    subHeader.BackgroundTransparency = 1
    subHeader.Text = "📌 " .. text
    subHeader.TextColor3 = Color3.fromRGB(80, 200, 255) -- สีฟ้าซีเรียนไฮไลท์
    subHeader.TextSize = 14
    subHeader.Font = Enum.Font.GothamBold
    subHeader.TextXAlignment = Enum.TextXAlignment.Left
    subHeader.LayoutOrder = layoutOrder
    subHeader.Parent = pageFrame
    return subHeader
end

-- ฟังก์ชันสร้างกล่องข้อความย่อย/ป้ายรายการใต้หัวข้อเล็ก
local function createListItem(pageFrame, text, layoutOrder)
    local item = Instance.new("TextLabel")
    item.Name = "Item_" .. text
    item.Size = UDim2.new(1, 0, 0, 32)
    item.BackgroundColor3 = Color3.fromRGB(10, 20, 48) -- พื้นหลังกล่องย่อยโทนฟ้า
    item.Text = "   " .. text
    item.TextColor3 = Color3.fromRGB(180, 225, 255)
    item.TextSize = 13
    item.Font = Enum.Font.GothamMedium
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.LayoutOrder = layoutOrder
    item.Parent = pageFrame
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 6)
    itemCorner.Parent = item
    
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.Parent = item
    
    return item
end

-- 7. สร้างหน้าทั้ง 5 แท็บ
local pageHome = createPage("หน้าหลัก")
local pageMacro = createPage("มาโคร")
local pageRaid = createPage("ลงเรท")
local pageAisen = createPage("ลงไอเซ็น")
local pageSettings = createPage("ตั้งค่า")

-- 8. ออกแบบหัวข้อเล็กและปุ่มย่อยภายในแต่ละหน้า

-- หน้าหลัก (หน้าแรก)
createSubHeader(pageHome, "ข้อมูลผู้เล่น", 1)
local levelValue = "454"
pcall(function()
    if player:FindFirstChild("Data") and player.Data:FindFirstChild("Level") then
        levelValue = tostring(player.Data.Level.Value)
    end
end)
createListItem(pageHome, "ชื่อผู้เล่น: " .. player.Name, 2)
createListItem(pageHome, "ระดับเลเวล: " .. levelValue, 3)

createSubHeader(pageHome, "สถานะการเชื่อมต่อ", 4)
createListItem(pageHome, "เวอร์ชันสคริปต์: พี่หล่อไหมน้อง Hub v1.0.0", 5)
createListItem(pageHome, "ระบบตรวจจับแมพ: ปิดใช้งาน (รันได้ทุกห้อง)", 6)


-- หน้ามาโคร
createSubHeader(pageMacro, "เครื่องมือบันทึกมาโคร", 1)
createListItem(pageMacro, "🔴 เริ่มการบันทึกการวางตัวละคร", 2)
createListItem(pageMacro, "⏹️ หยุดการบันทึก", 3)

createSubHeader(pageMacro, "จัดการไฟล์มาโคร", 4)
createListItem(pageMacro, "📁 โหลดมาโครที่บันทึกไว้", 5)
createListItem(pageMacro, "▶️ รันมาโครช่วยเหลือ", 6)


-- หน้าลงเรท
createSubHeader(pageRaid, "โหมดลงเรทอัตโนมัติ (Auto Raid)", 1)
createListItem(pageRaid, "⚔️ เริ่มต้นระบบช่วยเหลือลงเรทอัตโนมัติ", 2)

createSubHeader(pageRaid, "การตั้งค่าเป้าหมาย", 3)
createListItem(pageRaid, "🗺️ เลือกด่านเรท: (ค่าเริ่มต้น: ล่าสุด)", 4)
createListItem(pageRaid, "🔁 ระบบวนซ้ำฟาร์มแบบไม่จำกัด", 5)


-- หน้าลงไอเซ็น
createSubHeader(pageAisen, "ช่วยลงด่านไอเซ็น (Aizen Raid)", 1)
createListItem(pageAisen, "🏯 เปิดใช้งานออโต้ฟาร์มไอเซ็น", 2)

createSubHeader(pageAisen, "การควบคุมด่าน", 3)
createListItem(pageAisen, "⏩ ตั้งค่าข้ามเวฟเมื่อพร้อมเล่น", 4)
createListItem(pageAisen, "🏳️ ยอมแพ้และย้ายห้องอัตโนมัติเมื่อถึงเวฟ 15", 5)


-- หน้าตั้งค่า
createSubHeader(pageSettings, "ระบบตัวช่วยทั่วไป", 1)
createListItem(pageSettings, "⚡ ข้ามเวฟอัตโนมัติ (Auto Skip Wave)", 2)

createSubHeader(pageSettings, "ประสิทธิภาพสคริปต์", 3)
createListItem(pageSettings, "🚀 ลบเอฟเฟกต์และเพิ่ม FPS (Lag Reducer)", 4)
createListItem(pageSettings, "🎨 ย่อหน้าจอเมนู (Hide GUI Bind: RightControl)", 5)

-- 9. ฟังก์ชันสร้างปุ่มเมนูสลับแท็บที่แถบข้าง
local function makeMenuButton(name, layoutOrder)
    local button = Instance.new("TextButton")
    button.Name = name .. "Btn"
    button.Size = UDim2.new(1, -20, 0, 36)
    button.BackgroundColor3 = Color3.fromRGB(20, 60, 130)
    button.BackgroundTransparency = 1
    button.Text = "  " .. name
    button.TextColor3 = Color3.fromRGB(120, 170, 220)
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.LayoutOrder = layoutOrder
    button.Parent = buttonContainer
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.Parent = button

    -- ฟังก์ชันสลับหน้าเพจเมื่อกดปุ่ม
    button.MouseButton1Click:Connect(function()
        for _, child in ipairs(buttonContainer:GetChildren()) do
            if child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.2), {
                    BackgroundTransparency = 1,
                    TextColor3 = Color3.fromRGB(120, 170, 220)
                }):Play()
            end
        end
        
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0,
            TextColor3 = Color3.fromRGB(100, 220, 255)
        }):Play()
        
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
btnHome.TextColor3 = Color3.fromRGB(100, 220, 255)
pageHome.Visible = true

-- 10. ปุ่มปิดเมนูหลัก (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 100, 200)
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

-- 11. แจ้งเตือนสคริปต์โหลดเสร็จสิ้น
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "✨ พี่หล่อไหมน้อง Hub",
        Text = "โหลด UI เมนูแท็บเสร็จเรียบร้อย!",
        Duration = 3
    })
end)

print("[HandsomeBro Hub] Multi-tab Premium UI loaded successfully!")
