
-- รหัสหลักของเกม All Star Tower Defense (ห้องล็อบบี้)
local mainPlaceId = 1908611568 
local currentPlaceId = game.PlaceId
local isASTD = false

if currentPlaceId == mainPlaceId then
    isASTD = true
else
    -- สแกนชื่อแมพปัจจุบัน หากมีคำว่า All Star Tower Defense หรือ ASTD ให้ผ่าน
    local successScan, placeInfo = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(currentPlaceId)
    end)
    if successScan and placeInfo and placeInfo.Name then
        if string.find(placeInfo.Name, "All Star Tower Defense") or string.find(placeInfo.Name, "ASTD") then
            isASTD = true
        end
    end
end

if isASTD then
    statusLabel.Text = "✅ ตรวจพบแมพ: All Star Tower Defense\nกำลังเชื่อมต่อคลังสคริปต์หลัก..."
    statusLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
    
    task.wait(1.5)
    
    -- ⚠️ [[ นำลิงก์สคริปต์หลักของคุณมาใส่แทนจุดนี้เพื่อรันจริง ]]
    -- loadstring(game:HttpGet("https://raw.githubusercontent.com/..."))()
    
    statusLabel.Text = "🎉 โหลดสคริปต์สำเร็จ! คุณสามารถเริ่มใช้งานได้ทันที"
else
    statusLabel.Text = "❌ ตรวจพบแมพอื่น! สคริปต์นี้รองรับเฉพาะ All Star Tower Defense เท่านั้น\n(รหัสแมพปัจจุบัน: " .. tostring(currentPlaceId) .. ")"
    statusLabel.TextColor3 = Color3.fromRGB(231, 76, 60)
end
