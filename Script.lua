--[[
    BesAI V2.0.1.2 - PRIVATE MENU FOR ITACHII
    CHỨC NĂNG: FULL AUTO FARM, ESP, TELEPORT, ANTI-BAN
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("ITACHII HUB - BLOX FRUIT", "DarkTheme")

-- TỰ ĐỘNG CHẶN SERVER GỬI DỮ LIỆU BÁO CÁO (ANTI-BAN)
local old; old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and (self.Name:find("Admin") or self.Name:find("Cheat")) then
        return nil
    end
    return old(self, ...)
end)

-- TAB CHÍNH
local Main = Window:NewTab("Auto Farm")
local FarmSection = Main:NewSection("Cày Cấp Siêu Tốc")

FarmSection:NewToggle("Auto Farm Level", "Tự động nhận nhiệm vụ và đánh quái", function(state)
    _G.AutoFarm = state
    spawn(function()
        while _G.AutoFarm do task.wait()
            pcall(function()
                -- Thuật toán di chuyển đến quái (Tween)
                local Target = game:GetService("Workspace").Enemies:FindFirstChildOfClass("Model")
                if Target and Target:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Target.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1,1)) -- Tự đánh
                end
            end)
        end
    end)
end)

-- TAB TIỆN ÍCH
local Misc = Window:NewTab("Tiện Ích")
local VisualSection = Misc:NewSection("Hiển Thị")

VisualSection:NewToggle("ESP Player", "Nhìn xuyên tường người chơi", function(state)
    _G.ESP = state
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character then
            if not v.Character:FindFirstChild("Highlight") then
                local hl = Instance.new("Highlight", v.Character)
                hl.FillTransparency = 0.5
                hl.OutlineColor = Color3.fromRGB(255, 0, 0)
                hl.Enabled = state
            else
                v.Character.Highlight.Enabled = state
            end
        end
    end
end)

-- NÚT ĐÓNG MENU DÀNH CHO ĐIỆN THOẠI
local Setting = Window:NewTab("Cài Đặt")
Setting:NewSection("Quản lý UI"):NewButton("Đóng Menu (Tạm thời)", function()
    Library:ToggleUI()
end)
