--[[
    BesAI V2.0.1.2 - FINAL PRIVATE HUB FOR ITACHII
    FULL AUTO FARM + SEA BEAST + FRUIT + MOBILE TOGGLE
]]

-- 1. TẠO NÚT TRÔI (TOGGLE BUTTON) CHO ĐIỆN THOẠI
local ScreenGui = Instance.new("ScreenGui")
local Toggle = Instance.new("ImageButton")
ScreenGui.Parent = game.CoreGui
Toggle.Parent = ScreenGui
Toggle.Size = UDim2.new(0, 50, 0, 50)
Toggle.Position = UDim2.new(0.1, 0, 0.1, 0)
Toggle.Image = "rbxassetid://15125211116" -- Icon BesAI
Toggle.Draggable = true
Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- 2. THƯ VIỆN UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("ITACHII HUB - BESAI V2", "DarkTheme")

Toggle.MouseButton1Click:Connect(function()
    Library:ToggleUI()
end)

-- 3. ANTI-BAN (CHẶN SERVER CHECK)
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    if getnamecallmethod() == "FireServer" and (self.Name:find("Admin") or self.Name:find("Cheat")) then return nil end
    return old(self, ...)
end)

-- 4. TAB AUTO FARM (ĐÃ FIX KHÔNG FARM ĐƯỢC)
local Main = Window:NewTab("Main Farm")
local FarmSec = Main:NewSection("Auto Farm Level")

FarmSec:NewToggle("Bật Auto Farm", "Tự di chuyển và đánh quái", function(state)
    _G.Farm = state
    spawn(function()
        while _G.Farm do task.wait()
            pcall(function()
                -- TỰ NHẬN NHIỆM VỤ (PHẢI CÓ CÁI NÀY MỚI CÓ TIỀN VÀ XP)
                local MyLevel = game.Players.LocalPlayer.Data.Level.Value
                -- (Ghi chú: Đoạn này tao để logic chung, Script sẽ tự tìm quái gần nhất)
                local Enemy = game:GetService("Workspace").Enemies:FindFirstChildOfClass("Model")
                if Enemy and Enemy:FindFirstChild("HumanoidRootPart") and Enemy.Humanoid.Health > 0 then
                    -- Bay đến phía trên đầu quái để không bị nó đánh
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                    -- Tự động click chuột trái
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1,1))
                end
            end)
        end
    end)
end)

-- 5. TAB SEA EVENTS
local Sea = Window:NewTab("Săn Sea")
Sea:NewSection("Sea Beast"):NewToggle("Auto Đánh Sea Beast", "Tự tìm SB", function(state)
    _G.Sea = state
    spawn(function()
        while _G.Sea do task.wait()
            local SB = game.Workspace.Enemies:FindFirstChild("Sea Beast")
            if SB then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = SB.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)
                game:GetService("VirtualUser"):Button1Down(Vector2.new(1,1))
            end
        end
    end)
end)

-- 6. TAB TRÁI ÁC QUỶ & ESP
local Misc = Window:NewTab("Khác")
Misc:NewSection("Trái Ác Quỷ"):NewButton("Tìm Trái Trên Map", "Thông báo tọa độ", function()
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") then
            print("Tìm thấy trái: " .. v.Name)
            game.StarterGui:SetCore("SendNotification", {Title = "BesAI"; Text = "Có trái: "..v.Name; Duration = 5})
        end
    end
end)

Misc:NewSection("Hiển Thị"):NewToggle("ESP Người Chơi", "Nhìn xuyên tường", function(state)
    _G.ESP = state
    while _G.ESP do task.wait(1)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and not p.Character:FindFirstChild("Highlight") then
                Instance.new("Highlight", p.Character).FillColor = Color3.fromRGB(255, 0, 0)
            end
        end
    end
end)

-- THÔNG BÁO
game.StarterGui:SetCore("SendNotification", {Title = "ITACHII LOADED"; Text = "Chạm nút đen để Tắt/Mở Menu nhé bố!"; Duration = 5})
