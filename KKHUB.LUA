-- ==========================================
-- [0] 키 시스템 (Key System) UI 및 자동 저장 인증 로직
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- PC 및 모바일 실행기 호환을 위한 보호 설정 (gethui / protectgui 지원)
local ProtectedGui = (gethui and gethui()) or CoreGui

local function protectAndParent(gui)
    if protectgui then
        protectgui(gui)
    elseif syn and syn.protect_gui then
        syn.protect_gui(gui)
    end
    gui.Parent = ProtectedGui
end

-- 사용 가능한 인증 키 목록
local VALID_KEYS = {
    "KK_HUB_2026DH38DJEH2",
    "KK_HUB_2026FH48DJ3JS",
    "KK_HUB_2026DH38DBEJX",
    "KK_HUB_20263UR73UDIE",
    "KK_HUB_2026DJRUNR3C",
    "KK_HUB_2026DJ3LD03JD",
    "KK_HUB_2026CVDBLDNCE",
    "KK_HUB_2026RYFBEOS89",
    "KK_HUB_20263GDO3ND7EO",
    "KK_HUB_2026K8W3N7P2X",
    "KK_HUB_2026R4J9V6M1Q",
    "KK_HUB_2026T7C2Y8L5N",
    "KK_HUB_2026P3X6K9D4W",
    "KK_HUB_2026H9M2R7V5C",
    "KK_HUB_2026N6Q4T8J1K",
    "KK_HUB_2026V2L7P5X9R",
    "KK_HUB_2026C8D3W6N4Y",
    "KK_HUB_2026J5K9M2Q7T",
    "KK_HUB_2026Q7M2K9X4P"
}

-- 인증 성공 여부 대기 변수 및 자동 저장 파일 이름
local keyVerified = false
local SAVE_FILE = "KKHub_KeyData.txt"

-- 저장된 키가 있는지 확인하여 자동 인증 처리 (공백 제거 적용으로 안정성 강화)
if isfile and readfile then
    local success, content = pcall(function()
        if isfile(SAVE_FILE) then
            return readfile(SAVE_FILE)
        end
    end)
    if success and content then
        content = content:gsub("%s+", "")
        for _, k in ipairs(VALID_KEYS) do
            if content == k then
                keyVerified = true
                break
            end
        end
    end
end

-- 저장된 올바른 키가 없을 때만 키 시스템 UI 생성
if not keyVerified then
    if ProtectedGui:FindFirstChild("KKHub_KeySystem") then
        ProtectedGui.KKHub_KeySystem:Destroy()
    end
    if CoreGui:FindFirstChild("KKHub_KeySystem") then
        CoreGui.KKHub_KeySystem:Destroy()
    end

    local KeyScreenGui = Instance.new("ScreenGui")
    KeyScreenGui.Name = "KKHub_KeySystem"
    KeyScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    KeyScreenGui.ResetOnSpawn = false
    protectAndParent(KeyScreenGui)

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = KeyScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainFrame.BorderColor3 = Color3.fromRGB(100, 100, 255)
    MainFrame.BorderSizePixel = 2
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
    MainFrame.Size = UDim2.new(0, 350, 0, 200)

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = MainFrame
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 0, 0, 15)
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "KK HUB - Key System"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Parent = MainFrame
    DescLabel.BackgroundTransparency = 1
    DescLabel.Position = UDim2.new(0, 20, 0, 50)
    DescLabel.Size = UDim2.new(1, -40, 0, 25)
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = "키를 입력하고 인증 버튼을 눌러주세요."
    DescLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    DescLabel.TextSize = 13

    local KeyTextBox = Instance.new("TextBox")
    KeyTextBox.Name = "KeyTextBox"
    KeyTextBox.Parent = MainFrame
    KeyTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    KeyTextBox.BorderColor3 = Color3.fromRGB(80, 80, 100)
    KeyTextBox.Position = UDim2.new(0, 25, 0, 85)
    KeyTextBox.Size = UDim2.new(1, -50, 0, 40)
    KeyTextBox.Font = Enum.Font.Gotham
    KeyTextBox.PlaceholderText = "Enter your key here..."
    KeyTextBox.Text = ""
    KeyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyTextBox.TextSize = 14

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 6)
    BoxCorner.Parent = KeyTextBox

    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Name = "SubmitButton"
    SubmitButton.Parent = MainFrame
    SubmitButton.BackgroundColor3 = Color3.fromRGB(60, 100, 255)
    SubmitButton.BorderSizePixel = 0
    SubmitButton.Position = UDim2.new(0, 25, 0, 135)
    SubmitButton.Size = UDim2.new(1, -50, 0, 40)
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.Text = "Verify Key"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.TextSize = 14

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = SubmitButton

    SubmitButton.MouseButton1Click:Connect(function()
        local enteredKey = KeyTextBox.Text:gsub("%s+", "")
        local isMatch = false
        
        for _, k in ipairs(VALID_KEYS) do
            if enteredKey == k then
                isMatch = true
                break
            end
        end
        
        if isMatch then
            if writefile then
                pcall(function()
                    writefile(SAVE_FILE, enteredKey)
                end)
            end

            SubmitButton.Text = "인증 성공! 허브를 불러오는 중..."
            SubmitButton.TextColor3 = Color3.fromRGB(0, 255, 0)
            SubmitButton.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
            task.wait(1)
            keyVerified = true
            KeyScreenGui:Destroy()
        else
            SubmitButton.Text = "다시 시도하세요"
            SubmitButton.TextColor3 = Color3.fromRGB(255, 60, 60)
            SubmitButton.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
            task.wait(1.5)
            SubmitButton.Text = "Verify Key"
            SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            SubmitButton.BackgroundColor3 = Color3.fromRGB(60, 100, 255)
        end
    end)
end

repeat task.wait(0.1) until keyVerified

-- ==========================================
-- [1] 원본 스크립트 실행 (인증 완료 후)
-- ==========================================
loadstring(game:HttpGet("https://raw.githubusercontent.com/v889rfdv7z-lang/robloxrival-kkhub/refs/heads/main/robloxrival-kkhub.lua"))()

-- ==========================================
-- [1.5] UI 'knife' -> '근접무기' 변경 및 랙 없는 최적화 Melee 패치
-- ==========================================
task.spawn(function()
    task.wait(3)
    pcall(function()
        for _, root in ipairs({ProtectedGui, CoreGui, LocalPlayer:WaitForChild("PlayerGui")}) do
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    if obj.Text == "knife" or obj.Text == "Knife" then
                        obj.Text = "근접무기"
                    end
                end
            end
        end
    end)

    local VirtualUser = game:GetService("VirtualUser")
    while task.wait(0.2) do
        pcall(function()
            local character = LocalPlayer.Character
            if not character then return end
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local tool = character:FindFirstChildOfClass("Tool")
            
            if tool and humanoidRootPart then
                local isMelee = false
                local lowerName = tool.Name:lower()
                if lowerName:find("melee") or lowerName:find("knife") or lowerName:find("sword") or lowerName:find("bat") or lowerName:find("fists") or lowerName:find("hammer") or not tool:FindFirstChild("Ammo") then
                    isMelee = true
                end
                
                if isMelee then
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            local enemyHRP = player.Character:FindFirstChild("HumanoidRootPart")
                            local enemyHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if enemyHRP and enemyHumanoid and enemyHumanoid.Health > 0 then
                                local dist = (humanoidRootPart.Position - enemyHRP.Position).Magnitude
                                if dist <= 22 then
                                    if mouse1press and mouse1release then
                                        mouse1press()
                                        task.wait(0.04)
                                        mouse1release()
                                    elseif VirtualUser then
                                        VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                                        task.wait(0.04)
                                        VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                                    else
                                        tool:Activate()
                                    end
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- ==========================================
-- [2] 'UI ON / UI OFF' 토글 (위치 고정형, 랙 최적화)
-- ==========================================
task.spawn(function()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    if ProtectedGui:FindFirstChild("KKHub_FixedToggle") then
        ProtectedGui.KKHub_FixedToggle:Destroy()
    end
    if CoreGui:FindFirstChild("KKHub_FixedToggle") then
        CoreGui.KKHub_FixedToggle:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KKHub_FixedToggle"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    protectAndParent(ScreenGui)

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = ScreenGui
    ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    ToggleButton.BorderColor3 = Color3.fromRGB(100, 100, 255)
    ToggleButton.BorderSizePixel = 2
    ToggleButton.Position = UDim2.new(0.01, 0, 0.42, 0)
    ToggleButton.Size = UDim2.new(0, 110, 0, 38)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = "UI OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 13
    ToggleButton.AutoButtonColor = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = ToggleButton

    -- (드래그 이동 코드를 완전히 제거하여 버튼이 움직이지 않고 고정되도록 처리함)

    local targetGuis = {}
    local function getLionUIElements()
        if #targetGuis > 0 then return targetGuis end
        for _, root in ipairs({ProtectedGui, CoreGui, PlayerGui}) do
            local success, descendants = pcall(function()
                return root:GetDescendants()
            end)
            if success and descendants then
                for _, obj in ipairs(descendants) do
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                        if obj.Text == "Lion UI" then
                            obj.Text = "KK HUB"
                            local parent = obj.Parent
                            while parent and parent ~= root do
                                if parent:IsA("Frame") and parent.Size.X.Offset > 150 then
                                    table.insert(targetGuis, parent)
                                    break
                                elseif parent:IsA("ScreenGui") and parent.Name ~= "KKHub_FixedToggle" then
                                    table.insert(targetGuis, parent)
                                    break
                                end
                                parent = parent.Parent
                            end
                        end
                    end
                end
            end
        end
        return targetGuis
    end

    task.wait(1.5)
    targetGuis = getLionUIElements()
    local uiVisible = true

    ToggleButton.MouseButton1Click:Connect(function()
        uiVisible = not uiVisible
        
        if #targetGuis == 0 then
            targetGuis = getLionUIElements()
        end

        for _, gui in ipairs(targetGuis) do
            if gui and gui.Parent then
                gui.Visible = uiVisible
            end
        end

        if uiVisible then
            ToggleButton.Text = "UI OFF"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        else
            ToggleButton.Text = "UI ON"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        end
    end)
end)
