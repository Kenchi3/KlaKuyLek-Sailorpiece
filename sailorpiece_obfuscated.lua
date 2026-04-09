-- ========================
-- 🔗 Load UI
-- ========================
local Fluent          = loadstring(game:HttpGet("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager     = loadstring(game:HttpGet("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

-- ========================
-- 🪟 Create Window
-- ========================
local Window = Fluent:CreateWindow({
    Title       = "Klakuylek Hub",
    SubTitle    = "by nxnn_nn",
    TabWidth    = 160,
    Size        = UDim2.fromOffset(830, 525),
    Resize      = true,
    Acrylic     = true,
    Theme       = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
})

-- ========================
-- 📑 Tabs
-- ========================
local Tabs = {
    Main     = Window:AddTab({ Title = "Main",     Icon = "house" }),
    Stat     = Window:AddTab({ Title = "Stat",     Icon = "chart-line" }),
    Reroll   = Window:AddTab({ Title = "Reroll",   Icon = "zap"}),
    Boss     = Window:AddTab({ Title = "Boss",     Icon = "swords" }),
    Dungeon  = Window:AddTab({ Title = "Dungeon",  Icon = "shield"}),
    Shop     = Window:AddTab({ Title = "Shop",     Icon = "shopping-cart" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Misc     = Window:AddTab({ Title = "Misc",     Icon = "component" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local Options = Fluent.Options

-- ========================
-- 🧠 Game System
-- ========================
local Players          = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService       = game:GetService("GuiService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local MAIN_PLACE_ID = 77747658251236
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RaceConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RaceConfig"))
local UseItemRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("UseItem")

local player  = Players.LocalPlayer
local mouse   = player:GetMouse()
local userId  = player.UserId
local char    = player.Character or player.CharacterAdded:Wait()
local hrp     = char:WaitForChild("HumanoidRootPart")
local lastEquip = 0
local IsBossActive = false
local RunService = game:GetService("RunService")
local NPCs = workspace:WaitForChild("NPCs")
local StorageName = "Hidden_Map_Storage"
local Storage = game:GetService("Lighting"):FindFirstChild(StorageName) or Instance.new("Folder")
Storage.Name = StorageName
Storage.Parent = game:GetService("Lighting")

Quest  = ""
Enemy  = ""
Island = ""
Title  = ""


-- ========================
-- Execution Logger (Discord Webhook)
-- ========================
local function SendExecuteLog()
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")

    local player = Players.LocalPlayer

    local data = {
        ["username"] = player.Name,
        ["displayName"] = player.DisplayName,
        ["userId"] = player.UserId,
        ["accountAge"] = player.AccountAge,
        ["gameId"] = game.GameId,
        ["placeId"] = game.PlaceId,
        ["jobId"] = game.JobId,
        ["executor"] = identifyexecutor and identifyexecutor() or "Unknown",
        ["time"] = os.date("%Y-%m-%d %H:%M:%S")
    }

    local payload = {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "🚀 Script Executed",
            ["color"] = 65280,
            ["fields"] = {
                {name = "👤 Username", value = data.username, inline = true},
                {name = "📝 DisplayName", value = data.displayName, inline = true},
                {name = "🆔 UserId", value = tostring(data.userId), inline = true},
                {name = "📅 Account Age", value = tostring(data.accountAge).." days", inline = true},
                {name = "🎮 GameId", value = tostring(data.gameId), inline = false},
                {name = "📍 PlaceId", value = tostring(data.placeId), inline = true},
                {name = "🧩 JobId", value = tostring(data.jobId), inline = false},
                {name = "💻 Executor", value = data.executor, inline = true},
                {name = "⏰ Time", value = data.time, inline = false}
            }
        }}
    }

    local webhook = "https://discord.com/api/webhooks/1367840006776950784/HLx3JxvixXeUonVwR0TBvnxtR8-Wn8nuYyw79kjQi2DY23C9gjNA9Z9xpV99RDTQL3vQ"

    pcall(function()
        if syn and syn.request then
            syn.request({
                Url = webhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        elseif http_request then
            http_request({
                Url = webhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        elseif request then
            request({
                Url = webhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        end
    end)
end

SendExecuteLog()

-- ========================
-- Anti AFK
-- ========================
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ========================
-- Auto Rejoin
-- ========================
local function Rejoin()
    local success, err = pcall(function()
        if #Players:GetPlayers() <= 1 then
            TeleportService:Teleport(game.PlaceId, player)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    end)
end

game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if child.Name == "ErrorPrompt" then
        task.wait(2)
        Rejoin()
    end
end)

local function ApplyNoclip()
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

local function IsInDungeon()
    if game.PlaceId == MAIN_PLACE_ID then
        return false
    end
    return not ReplicatedStorage:FindFirstChild("Framework")
end

local DEBUG_MODE = false

local function debugPrint(...)
    -- disabled
end

local function refreshCharacter(newChar)
    char = newChar
    if char then
        hrp = char:WaitForChild("HumanoidRootPart", 10)
    end
end

player.CharacterAdded:Connect(refreshCharacter)
if not player.Character then
    player.CharacterAdded:Wait()
end



-- ========================
-- 🔧 Utility Functions
-- ========================

local function Attack(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end

    ReplicatedStorage
        :WaitForChild("CombatSystem")
        :WaitForChild("Remotes")
        :WaitForChild("RequestHit")
        :FireServer(target.HumanoidRootPart.Position)
end

local function TP(pos)
    hrp.CFrame = pos
end

local function TPIsland(islandName)
    local teleportRemote = game:GetService("ReplicatedStorage")
        :WaitForChild("Remotes")
        :WaitForChild("TeleportToPortal")
    teleportRemote:FireServer(islandName)
end


local function GetLevel()
    if player:FindFirstChild("Data") and player.Data:FindFirstChild("Level") then
        return player.Data.Level.Value
    end
    return 0
end

local Keywords = {"Island", "Map", "Area", "Land"}

local function ToggleMap(state)
    if state then
        -- ลบเกาะ (ย้ายไปเก็บใน Lighting)
        for _, obj in pairs(workspace:GetChildren()) do
            -- เช็คว่าเป็น Folder หรือ Model และไม่ใช่ตัวละครเรา
            if (obj:IsA("Folder") or obj:IsA("Model")) and obj.Name ~= game.Players.LocalPlayer.Name then
                
                -- ลูปเช็ค Keyword
                for _, word in pairs(Keywords) do
                    if string.find(obj.Name:lower(), word:lower()) then
                        obj.Parent = Storage
                        break -- เจอแล้วให้หยุดลูปคำค้นหาแล้วไป Folder ถัดไปเลย
                    end
                end
            end
        end
    else
        -- เอากลับมา (ย้ายจาก Lighting กลับ Workspace)
        for _, obj in pairs(Storage:GetChildren()) do
            obj.Parent = workspace
        end
    end
end
-- ========================
-- 🔧 Velocity Reset Helper
-- ========================
local function ResetVelocity()
    if hrp and hrp.Parent then
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end

-- ========================
-- 🛒 Moveset Buyer Data
-- ========================
local MovesetData = {}

local successMoveset, movesetConfig = pcall(function()
    return require(game:GetService("ReplicatedStorage").Modules.MovesetBuyerConfig)
end)

if successMoveset and type(movesetConfig) == "table" then
    local BuyersTable = movesetConfig.Buyers
    if BuyersTable then
        for _, data in pairs(BuyersTable) do
            if type(data) == "table" and data.npcName then
                table.insert(MovesetData, data.npcName)
            end
        end
    end
end

table.sort(MovesetData)

-- ========================
-- 🌍 Dynamic Island Data
-- ========================
local IslandData = {}

local success, configData = pcall(function()
    local framework = ReplicatedStorage:FindFirstChild("Framework")
    if not framework then return nil end

    local configModule = framework
        :FindFirstChild("Shared")
        and framework.Shared:FindFirstChild("Configs")
        and framework.Shared.Configs:FindFirstChild("IslandsConfig")

    if not configModule then return nil end

    return require(configModule)
end)

if success and type(configData) == "table" then
    for _, data in pairs(configData) do
        if type(data) == "table" and data.PortalId then
            table.insert(IslandData, data.PortalId)
        end
    end
else
    IslandData = {"Starter", "Jungle", "Desert"}
end

table.sort(IslandData)

local BossTable = {
    { Bossname = "Aizen",             Boss = "AizenBoss",           Island = "HollowIsland" },
    { Bossname = "Gojo",              Boss = "GojoBoss",            Island = "Shibuya"      },
    { Bossname = "Jinwoo",            Boss = "JinwooBoss",          Island = "Sailor"       },
    { Bossname = "Strongest Shinobi", Boss = "StrongestShinobiBoss",Island = "Ninja"        },
    { Bossname = "Sukuna",            Boss = "SukunaBoss",          Island = "Shibuya"      },
    { Bossname = "Yuji",              Boss = "YujiBoss",            Island = "Shibuya"      },
    { Bossname = "Yamato",            Boss = "YamatoBoss",          Island = "Judgement"    },
    { Bossname = "Alucard",           Boss = "AlucardBoss",         Island = "Sailor"       },
}

local bossList = {}
for _, data in pairs(BossTable) do
    table.insert(bossList, data.Bossname)
end

local function getBossDataByName(name)
    for _, data in pairs(BossTable) do
        if data.Bossname == name then
            return data
        end
    end
    return nil
end


local EnemyData = {
    {Enemy = "Thief",          Island = "Starter"},
    {Enemy = "ThiefBoss",      Island = "Starter"},
    {Enemy = "Monkey",         Island = "Jungle"},
    {Enemy = "MonkeyBoss",     Island = "Jungle"},
    {Enemy = "DesertBandit",   Island = "Desert"},
    {Enemy = "DesertBoss",     Island = "Desert"},
    {Enemy = "FrostRogue",     Island = "Snow"},
    {Enemy = "SnowBoss",       Island = "Snow"},
    {Enemy = "Sorcerer",       Island = "Shibuya"},
    {Enemy = "PandaMiniBoss",  Island = "Shibuya"},
    {Enemy = "Hollow",         Island = "HollowIsland"},
    {Enemy = "StrongSorcerer", Island = "Shinjuku"},
    {Enemy = "Curse",          Island = "Shinjuku"},
    {Enemy = "Slime",          Island = "Slime"},
    {Enemy = "AcademyTeacher", Island = "Academy"},
    {Enemy = "Swordsman",      Island = "Judgement"},
    {Enemy = "Quincy",         Island = "SoulDominion"},
    {Enemy = "Ninja",          Island = "Ninja"},
    {Enemy = "ArenaFighter",   Island = "Lawless"},
}

local mobList = {}
for _, data in pairs(EnemyData) do
    table.insert(mobList, data.Enemy)
end

local function CheckQuest()
    local level = GetLevel()
    if level <= 99 then
        Quest = "QuestNPC1";  Enemy = "Thief";         Island = "Starter";      Title = "Thief Hunter"
    elseif level <= 249 then
        Quest = "QuestNPC2";  Enemy = "ThiefBoss";     Island = "Starter";      Title = "Thief Boss"
    elseif level <= 499 then
        Quest = "QuestNPC3";  Enemy = "Monkey";        Island = "Jungle";       Title = "Monkey Hunter"
    elseif level <= 749 then
        Quest = "QuestNPC4";  Enemy = "MonkeyBoss";    Island = "Jungle";       Title = "Monkey Boss"
    elseif level <= 999 then
        Quest = "QuestNPC5";  Enemy = "DesertBandit";  Island = "Desert";       Title = "Desert Bandit Hunter"
    elseif level <= 1499 then
        Quest = "QuestNPC6";  Enemy = "DesertBoss";    Island = "Desert";       Title = "Desert Bandit Boss"
    elseif level <= 1999 then
        Quest = "QuestNPC7";  Enemy = "FrostRogue";    Island = "Snow";         Title = "Frost Rogue Hunter"
    elseif level <= 2999 then
        Quest = "QuestNPC8";  Enemy = "SnowBoss";      Island = "Snow";         Title = "Winter Warden Boss"
    elseif level <= 3999 then
        Quest = "QuestNPC9";  Enemy = "Sorcerer";      Island = "Shibuya";      Title = "Sorcerer Hunter"
    elseif level <= 5000 then
        Quest = "QuestNPC10"; Enemy = "PandaMiniBoss"; Island = "Shibuya";      Title = "Panda Sorcerer Boss"
    elseif level <= 6250 then
        Quest = "QuestNPC11"; Enemy = "Hollow";        Island = "HollowIsland"; Title = "Hollow Hunter"
    elseif level <= 7000 then
        Quest = "QuestNPC12"; Enemy = "StrongSorcerer";Island = "Shinjuku";     Title = "Strong Sorcerer Hunter"
    elseif level <= 8000 then
        Quest = "QuestNPC13"; Enemy = "Curse";         Island = "Shinjuku";     Title = "Curse Hunter"
    elseif level <= 9000 then
        Quest = "QuestNPC14"; Enemy = "SlimeWarrior";  Island = "Slime";        Title = "Slime Warrior Hunter"
    elseif level <= 10000 then
        Quest = "QuestNPC15"; Enemy = "AcademyTeacher";Island = "Academy";      Title = "Academy Challenge"
    elseif level <= 10750 then
        Quest = "QuestNPC16"; Enemy = "Swordsman";     Island = "Judgement";    Title = "Blade Masters"
    elseif level <= 11500 then
        Quest = "QuestNPC17"; Enemy = "Quincy";        Island = "SoulDominion"; Title = "Quincy Purge"
    elseif level <= 12000 then
        Quest = "QuestNPC18"; Enemy = "Ninja";         Island = "Ninja";        Title = "Ninja Slayer"
    elseif level <= 13000 then
        Quest = "QuestNPC19"; Enemy = "ArenaFighter";  Island = "Lawless";      Title = "Arena Takedown"
    else
        Quest = "QuestNPC19"; Enemy = "ArenaFighter";  Island = "Lawless";      Title = "Arena Takedown"
    end
end

local function GetEnemy()
    for _, npc in pairs(workspace:WaitForChild("NPCs"):GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") then
            local name = npc.Name:match("^([%a_]+)")
            if name == Enemy then
                return npc
            end
        end
    end
    return nil
end

local function GetDistanceToEnemy(enemy)
    if not enemy or not enemy:FindFirstChild("HumanoidRootPart") or not hrp then
        return math.huge
    end
    return (enemy.HumanoidRootPart.Position - hrp.Position).Magnitude
end

local function GetQuest()
    CheckQuest()

    local playerGui    = player:WaitForChild("PlayerGui")
    local questUIFrame = playerGui:WaitForChild("QuestUI"):WaitForChild("Quest")
    local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
    local QuestAbandon = RemoteEvents:WaitForChild("QuestAbandon")
    local QuestAccept  = RemoteEvents:WaitForChild("QuestAccept")

    local repeatUI = questUIFrame
        :WaitForChild("Quest")
        :WaitForChild("Holder")
        :WaitForChild("QuestRepeat")

    local questTitleUI = questUIFrame
        :WaitForChild("Quest")
        :WaitForChild("Holder")
        :WaitForChild("Content")
        :WaitForChild("QuestInfo")
        :WaitForChild("QuestTitle")
        :WaitForChild("QuestTitle")

    local currentQuestTitle = questTitleUI.Text

    if not questUIFrame.Visible or repeatUI.Visible then
        QuestAccept:FireServer(Quest)
    elseif currentQuestTitle ~= Title then
        QuestAbandon:FireServer()
    end
end

-- ========================
-- 🛠️ Tool Functions
-- ========================
local WeaponModule = require(
    game:GetService("ReplicatedStorage")
    :WaitForChild("Modules")
    :WaitForChild("WeaponClassification")
)

local function getToolName(tool)
    local attrName = tool:GetAttribute("_ToolName")
    if attrName then
        return attrName
    end
    return tool.Name
end

local function getToolByCategory(category)
    if not char then return nil end

    local equipped = char:FindFirstChildOfClass("Tool")
    if equipped then
        local toolName = getToolName(equipped)
        local type = WeaponModule.GetToolStatType(toolName)
        if type == category then
            return equipped
        end
    end

    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local toolName = getToolName(tool)
            local type = WeaponModule.GetToolStatType(toolName)
            if type == category then
                return tool
            end
        end
    end

    return nil
end

local function equipCategory(category)
    local tool = getToolByCategory(category)
    if tool then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:EquipTool(tool)
            lastEquip = tick()
        end
    end
end

-- ========================
-- 🎮 Main Tab UI
-- ========================
local ToolDropdown = Tabs.Main:AddDropdown("ToolSelect", {
    Title   = "Select Weapon Type",
    Values  = {"Melee", "Sword"},
    Multi   = false,
    Default = "Melee"
})
local selectedTool = nil

local selectedCategory = "Melee"

ToolDropdown:OnChanged(function(Value)
    selectedCategory = Value
end)


local SelectedMobs = {}

local MobDropdown = Tabs.Main:AddDropdown("MobSelect", {
    Title = "Select Mob",
    Values = mobList,
    Multi = true,
    Default = {}
})

local SelectedMobs = {}

local function updateSelectedMobs()
    SelectedMobs = {}
    local value = MobDropdown.Value

    if type(value) == "table" then
        for key, val in pairs(value) do
            if val == true and type(key) == "string" then
                table.insert(SelectedMobs, key)
            elseif type(val) == "string" then
                table.insert(SelectedMobs, val)
            end
        end
    elseif type(value) == "string" then
        table.insert(SelectedMobs, value)
    end

    return SelectedMobs
end

MobDropdown:OnChanged(function()
    updateSelectedMobs()
end)

local AutoFarmMobs = Tabs.Main:AddToggle("AutoFarmMobs", { Title = "Auto Farm Mobs", Default = false })
local AutoFarm = Tabs.Main:AddToggle("AutoFarm", { Title = "Auto Farm Levels", Default = false })
Options.AutoFarmMobs:SetValue(false)
Options.AutoFarm:SetValue(false)

-- ========================
-- ⚙️ Farm Settings
-- ========================
local FarmMethod = Tabs.Main:AddDropdown("FarmMethod", {
    Title = "Farm Method",
    Values = {"Behind", "Above", "Below"},
    Multi = false,
    Default = "Behind"
})

local FarmDistance = Tabs.Main:AddSlider("FarmDistance", {
    Title = "Farm Distance",
    Description = "",
    Default = 10,
    Min = 10,
    Max = 190,
    Rounding = 0
})


-- ========================
-- 📍 Farm Position Logic
-- ========================
local function GetFarmPosition(targetHRP)
    local method = Options.FarmMethod.Value or "Behind"
    local dist = Options.FarmDistance.Value or 5
    local character = player.Character
    
    if not character or not targetHRP then return nil end

    if method == "Behind" then
        -- อยู่ด้านหลังมอนสเตอร์
        return targetHRP.CFrame * CFrame.new(0, 0, dist)

    elseif method == "Above" then
        -- อยู่บนหัวมอนสเตอร์ (หันหน้าลง)
        return targetHRP.CFrame 
            * CFrame.new(0, dist, 0) 
            * CFrame.Angles(math.rad(-90), 0, 0)

    elseif method == "Below" then
        -- 🔥 อยู่ใต้เท้ามอนสเตอร์ (หันหน้าขึ้น)
        -- เปิด Noclip ทุกเฟรมเมื่อใช้ท่านี้
        ApplyNoclip()
        
        return targetHRP.CFrame 
            * CFrame.new(0, -dist, 0) 
            * CFrame.Angles(math.rad(90), 0, 0)
    end

    return targetHRP.CFrame
end
-- ========================
-- 🔥 Auto Skill
-- ========================
local section = Tabs.Main:AddSection("Skills")
local SkillDropdown = Tabs.Main:AddDropdown("SkillSelect", {
    Title   = "Select Skill",
    Values  = { "Z", "X", "C", "V" },
    Multi   = true,
    Default = {},
})

local skillKeyToNumber = { Z = 1, X = 2, C = 3, V = 4 }
local selectedSkills   = {}

local function updateSelectedSkills()
    selectedSkills = {}
    local value = SkillDropdown.Value

    if type(value) == "table" then
        for key, val in pairs(value) do
            local skillNum = skillKeyToNumber[val] or skillKeyToNumber[key]
            if skillNum then
                table.insert(selectedSkills, skillNum)
            end
        end
    elseif type(value) == "string" then
        local skillNum = skillKeyToNumber[value]
        if skillNum then
            table.insert(selectedSkills, skillNum)
        end
    end

    return selectedSkills
end

SkillDropdown:OnChanged(function()
    updateSelectedSkills()
    local skillList = table.concat(selectedSkills, " ")
end)


local AutoSkill = Tabs.Main:AddToggle("AutoSkill", { Title = "Auto Skill", Default = false })
local AutoHaki = Tabs.Main:AddToggle("AutoHaki", { Title = "Auto Haki", Default = false })
Options.AutoSkill:SetValue(false)
Options.AutoHaki:SetValue(false)

local attackaurasection = Tabs.Main:AddSection("Attack Aura")

local KillAura = Tabs.Main:AddToggle("KillAura", {
    Title = "DMG Aura",
    Default = false
})

local KillAuraRange = Tabs.Main:AddSlider("KillAuraRange", {
    Title = "DMG Aura Range",
    Description = "",
    Default = 50,
    Min = 50,
    Max = 190,
    Rounding = 0
})

local AscendSection = Tabs.Main:AddSection("Ascend")

local holder = game:GetService("Players").LocalPlayer.PlayerGui.AscendUI.MainFrame.Frame.Content.Holder.RankInfoReqFrame.RankInfoFrame.RequirementsFrame.RequirementsHolder

local AscendConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("AscendConfig"))
local GetAscendData = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("GetAscendData")

local function FormatVal(val)
    if typeof(val) ~= "number" then return tostring(val) end
    if val >= 1e12 then return string.format("%.1fT", val/1e12):gsub("%.0T", "T") end
    if val >= 1e9 then return string.format("%.1fB", val/1e9):gsub("%.0B", "B") end
    if val >= 1e6 then return string.format("%.1fM", val/1e6):gsub("%.0M", "M") end
    if val >= 1e3 then return string.format("%.1fK", val/1e3):gsub("%.0K", "K") end
    return tostring(math.floor(val))
end

-- สร้าง Paragraph ตามเดิม (ถ้ายังไม่ได้สร้าง หรือใช้อันเดิมก็ได้)
local AscendReq = AscendSection:AddParagraph("AscendReq", {
    Title = "Current Requirements",
    Content = "Loading data...",
    TitleAlignment = "Middle",
})

local AutoAscendToggle = AscendSection:AddToggle("AutoAscendToggle", {
    Title = "Auto Ascend",
    Default = false,
})

local Ascendbtn = AscendSection:AddButton({
    Title = "Ascend",
    Description = "Click To Ascend",
    Callback = function ()
        local Ascend = game:GetService("ReplicatedStorage").RemoteEvents.RequestAscend
        Ascend:FireServer()
        Fluent:Notify({
            Title = "Ascend",
            Content = "Ascend Sucessfully",
            Duration = 5
        })
    end
})

local function RefreshAscendUI()
    local success, data = pcall(function() 
        return GetAscendData:InvokeServer() 
    end)

    if success and data then
        -- ใช้ตัวแปรเดียวเก็บทั้งหัวข้อและเนื้อหา
        local fullDisplay = ""
        
        if data.isMaxed then
            fullDisplay = "✨ MAX ASCEND REACHED\nCongratulations! You are at the maximum rank."
            AscendReq:SetValue(fullDisplay)
            return
        end

        -- บรรทัดที่ 1: หัวข้อ Next Rank
        local nextRankName = data.rankName or AscendConfig.GetRankName(data.currentRank + 1)
        fullDisplay = "👑 NEXT RANK: " .. nextRankName:upper() .. " 👑\n" .. string.rep("-", 20) .. "\n"

        -- บรรทัดต่อๆ มา: รายการเงื่อนไข
        if data.requirements then
            for i, req in pairs(data.requirements) do
                local cleanLabel = req.display:gsub("<[^>]+>", ""):gsub("%s+", " "):match("^%s*(.-)%s*$")
                local current = FormatVal(req.current or 0)
                local needed = FormatVal(req.needed or 0)
                local statusIcon = req.completed and "✅" or "⏳"
                
                fullDisplay = fullDisplay .. string.format("%s %s (%s/%s)\n", statusIcon, cleanLabel, current, needed)
            end
        end

        -- [[ อัปเดตผ่าน SetValue โดยเน้นไปที่ Content อย่างเดียว ]]
        AscendReq:SetValue(fullDisplay)
    else
        AscendReq:SetValue("❌ Failed to connect to server data.")
    end
end

local function CheckAndRequestAscend(data)
    -- ใช้ AutoAscendToggle.Value เพื่อเช็คว่าเปิดหรือปิดอยู่
    if AutoAscendToggle.Value and data and data.allMet and not data.isMaxed then
        local RequestAscend = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestAscend")
        
        -- ยิง Remote จุติ
        RequestAscend:FireServer()
        
        print("✅ [Klakuylek Hub] Auto Ascend Success!")
        task.wait(1) -- รอเล็กน้อยป้องกันการยิงซ้ำซ้อน
    end
end
-- เรียกใช้งานครั้งแรกทันที
task.spawn(RefreshAscendUI)

-- วนลูปอัปเดตทุกๆ 5 วินาที เพื่อให้เห็นความคืบหน้า (เช่น ยอด Kill ที่เพิ่มขึ้น)
task.spawn(function()
    while task.wait(5) do
        -- ป้องกัน Error หาก Element ถูกทำลาย
        if not AscendReq or not AutoAscendToggle then break end 

        -- ดึงข้อมูลจาก Server
        local success, data = pcall(function() 
            return game:GetService("ReplicatedStorage").RemoteEvents.GetAscendData:InvokeServer() 
        end)

        if success and data then
            -- 1. อัปเดต Paragraph เสมอ (Paragraph จะรัน RefreshAscendUI ต่อ)
            RefreshAscendUI() 

            -- 2. เช็คเงื่อนไข Auto Ascend จากค่าของ Toggle ในตอนนั้นเลย
            -- ถ้าไม่ได้เปิด (AutoAscendToggle.Value == false) มันจะข้ามบรรทัดนี้ไปเอง
            CheckAndRequestAscend(data)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        local state = AutoHaki.Value
        if player:GetAttribute("AutoArmHaki") ~= state then
            player:SetAttribute("AutoArmHaki", state)
        end
    end
end)

AutoSkill:OnChanged(function(Value)
    if Value then
        updateSelectedSkills()
    end
end)

local MainBossSection = Tabs.Boss:AddSection("Main Boss")
local BossDropdown = MainBossSection:AddDropdown("BossSelect", {
    Title = "Select Boss",
    Values = bossList,
    Multi = true,
    Default = {}
})

local AutoFarmBoss = MainBossSection:AddToggle("AutoFarmBoss", { Title = "Auto Farm Boss", Default = false })
Options.AutoFarmBoss:SetValue(false)

local selectedBosses = {}

local function updateSelectedBosses()
    selectedBosses = {}
    local value = BossDropdown.Value

    if type(value) == "table" then
        for key, val in pairs(value) do
            if val == true and type(key) == "string" then
                table.insert(selectedBosses, key)
            elseif type(val) == "string" then
                table.insert(selectedBosses, val)
            end
        end
    elseif type(value) == "string" then
        table.insert(selectedBosses, value)
    end

    return selectedBosses
end

BossDropdown:OnChanged(function()
    updateSelectedBosses()
end)

-- ========================
-- Summonable boss
-- ========================
local BossModule = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("SummonableBossConfig"))

local SummonBossList = {}
local SummonBossMap = {}

for bossName, data in pairs(BossModule:GetAllBosses()) do
    table.insert(SummonBossList, data.displayName)
    SummonBossMap[data.displayName] = data
end

table.sort(SummonBossList)

local summonsection = Tabs.Boss:AddSection("Summon Boss")

local SummonBossDropdown = summonsection:AddDropdown("SummonBossSelect", {
    Title = "Select Summon Boss",
    Values = SummonBossList,
    Multi = false,
    Default = SummonBossList[1]
})

local DifficultyDropdown = summonsection:AddDropdown("SummonBossDifficulty", {
    Title = "Difficulty",
    Values = {"Normal", "Medium", "Hard", "Extreme"},
    Multi = false,
    Default = "Normal"
})

local AutoSummonBoss = summonsection:AddToggle("AutoSummonBoss", {
    Title = "Auto Summon Boss",
    Default = false
})

local DivineCraft = summonsection:AddInput("DivineCraft", {
    Title = "Craft Divide Grail",
    Default = "",
    Description = "Enter amount to craft",
    Placeholder = "Enter amount",
    Numeric = true,
    Finished = true, -- 🔥 กด Enter เท่านั้นถึงยิง
    Callback = function()
        task.wait()

        local value = Options.DivineCraft.Value
        local num = tonumber(value)

        if not num or num <= 0 then return end

        game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes")
            :WaitForChild("RequestGrailCraft")
            :InvokeServer("DivineGrail", num)
    end
})

local function SummonBoss(bossId, difficulty)
    ReplicatedStorage:WaitForChild("Remotes")
        :WaitForChild("RequestSummonBoss")
        :FireServer(bossId, difficulty)
end

local function FindSummonedBoss(bossId)
    for _, npc in pairs(workspace:WaitForChild("NPCs"):GetChildren()) do
        if npc:FindFirstChild("Humanoid")
        and npc.Humanoid.Health > 0
        and string.find(npc.Name, bossId) then
            return npc
        end
    end
    return nil
end

local function GetBossModel(bossId)
    for _, v in pairs(NPCs:GetChildren()) do
        if v.Name:find(bossId) then
            return v
        end
    end
    return nil
end

local lastSummon = 0

-- ========================
-- 🟣 Rimuru Boss Section
-- ========================
local RimuruSection = Tabs.Boss:AddSection("Rimuru Boss")

local AutoSlimeQuestBtn = RimuruSection:AddButton({
    Title = "Auto Slime Quest",
    Callback = function ()
        TPIsland("Slime")
        task.wait(1)
        local npc = workspace:WaitForChild("ServiceNPCs"):WaitForChild("SlimeCraftNPC")
        for i = 1, 3 do
            TP(npc.HumanoidRootPart.CFrame)
            local prompt = npc.HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
                task.wait(0.5)
            end
        end

        TPIsland("Desert")
        task.wait(1)
        local slime1 = workspace:WaitForChild("DesertIsland"):WaitForChild("SlimePuzzlePiece")
        if slime1 then
            for i = 1, 3 do
                TP(slime1.CFrame)
                local prompt = slime1:FindFirstChildOfClass("ProximityPrompt")
                if prompt then fireproximityprompt(prompt); task.wait(0.5) end
            end
        end

        TPIsland("Snow")
        task.wait(1)
        local slime2 = workspace:WaitForChild("SnowIsland"):WaitForChild("SlimePuzzlePiece")
        if slime2 then
            for i = 1, 3 do
                TP(slime2.CFrame)
                local prompt = slime2:FindFirstChildOfClass("ProximityPrompt")
                if prompt then fireproximityprompt(prompt); task.wait(0.5) end
            end
        end

        TPIsland("Starter")
        task.wait(1)
        local slime3 = workspace:WaitForChild("StarterIsland"):WaitForChild("SlimePuzzlePiece")
        if slime3 then
            for i = 1, 3 do
                TP(slime3.CFrame)
                local prompt = slime3:FindFirstChildOfClass("ProximityPrompt")
                if prompt then fireproximityprompt(prompt); task.wait(0.5) end
            end
        end

        TPIsland("Jungle")
        task.wait(1)
        local slime4 = workspace:WaitForChild("JungleIsland"):WaitForChild("SlimePuzzlePiece")
        if slime4 then
            for i = 1, 3 do
                TP(slime4.CFrame)
                local prompt = slime4:FindFirstChildOfClass("ProximityPrompt")
                if prompt then fireproximityprompt(prompt); task.wait(0.5) end
            end
        end

        TPIsland("Shibuya")
        task.wait(1)
        local slime5 = workspace:WaitForChild("ShibuyaStation"):WaitForChild("SlimePuzzlePiece")
        if slime5 then
            for i = 1, 3 do
                TP(slime5.CFrame)
                local prompt = slime5:FindFirstChildOfClass("ProximityPrompt")
                if prompt then fireproximityprompt(prompt); task.wait(0.5) end
            end
        end

        TPIsland("HollowIsland")
        task.wait(1)
        local slime6 = workspace:WaitForChild("HollowIsland"):WaitForChild("SlimePuzzlePiece")
        if slime6 then
            for i = 1, 3 do
                TP(slime6.CFrame)
                local prompt = slime6:FindFirstChildOfClass("ProximityPrompt")
                if prompt then fireproximityprompt(prompt); task.wait(0.5) end
            end
        end

        TPIsland("Shinjuku")
        task.wait(1)
        local slime7 = workspace:WaitForChild("ShinjukuIsland"):WaitForChild("SlimePuzzlePiece")
        if slime7 then
            for i = 1, 3 do
                TP(CFrame.new(787.80126953125, 64.3216552734375, -2309.12841796875))
                local prompt = slime7:FindFirstChildOfClass("ProximityPrompt")
                if prompt then fireproximityprompt(prompt); task.wait(0.5) end
            end
        end
    end
})

local RimuruDifficultyDropdown = RimuruSection:AddDropdown("RimuruDifficulty", {
    Title = "Difficulty",
    Values = {"Normal", "Medium", "Hard", "Extreme"},
    Multi = false,
    Default = "Normal",
})

local RimuruDifficulty = "Normal"
RimuruDifficultyDropdown:OnChanged(function(value)
    RimuruDifficulty = value
end)

local AutoFarmRimuruToggle = RimuruSection:AddToggle("AutoFarmRimuru", {
    Title = "Auto Farm Rimuru",
    Default = false,
})

local SlimeKeyCraft = RimuruSection:AddInput("SlimeKeyCraft", {
    Title = "Craft Slime Key",
    Default = "",
    Description = "Enter amount to craft",
    Placeholder = "Enter amount",
    Numeric = true,
    Finished = true, -- 🔥 กด Enter เท่านั้นถึงยิง
    Callback = function()
        task.wait()

        local value = Options.SlimeKeyCraft.Value
        local num = tonumber(value)

        if not num or num <= 0 then return end

        game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes")
            :WaitForChild("RequestSlimeCraft")
            :InvokeServer("SlimeKey", num)
    end
})

local function FindRimuruBoss()
    for _, npc in pairs(NPCs:GetChildren()) do
        if npc.Name:find("RimuruBoss") and npc:FindFirstChild("Humanoid") then
            return npc
        end
    end
    return nil
end

-- ========================
-- 🔴 Anos Boss Section
-- ========================
local AnosSection = Tabs.Boss:AddSection("Anos Boss")

AnosSection:AddButton({
    Title = "Auto Demonite Core Quest",
    Callback = function()
        TPIsland("Academy")
        task.wait(1)
        local npc = workspace:WaitForChild("ServiceNPCs"):WaitForChild("AnosQuestNPC")
        for i = 1, 3 do
            TP(npc.HumanoidRootPart.CFrame)
            local prompt = npc.HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
                task.wait(0.5)
            end
        end

        for i = 1, 3 do
            local core1 = workspace:WaitForChild("DemoniteCore1")
            if core1 then
                TP(core1.CFrame)
                local prompt = core1:FindFirstChildOfClass("ProximityPrompt")
                if prompt then fireproximityprompt(prompt); task.wait(0.5) end
            end
        end

        for i = 1, 3 do
            local core2 = workspace:WaitForChild("DemoniteCore2")
            if core2 then
                TP(core2.CFrame)
                local prompt = core2:FindFirstChildOfClass("ProximityPrompt")
                if prompt then fireproximityprompt(prompt); task.wait(0.5) end
            end
        end
    end
})

local AnosDifficulty = "Normal"

local AnosDifficultyDropdown = AnosSection:AddDropdown("AnosDifficulty", {
    Title = "Difficulty",
    Values = {"Normal", "Medium", "Hard", "Extreme"},
    Multi = false,
    Default = "Normal",
})

AnosDifficultyDropdown:OnChanged(function(value)
    AnosDifficulty = value
end)

local AutoFarmAnos = AnosSection:AddToggle("AutoFarmAnos", {
    Title = "Auto Farm Anos",
    Default = false,
})

local function FindAnosBoss()
    for _, npc in pairs(NPCs:GetChildren()) do
        if npc.Name:find("AnosBoss")
        and npc:FindFirstChild("Humanoid")
        and npc.Humanoid.Health > 0 then
            return npc
        end
    end
    return nil
end

-- ========================
-- ⚛️ Atomic Boss Section
-- ========================
local AtomicSection = Tabs.Boss:AddSection("Atomic Boss")

local AtomicDifficulty = "Normal"

local AtomicDifficultyDropdown = AtomicSection:AddDropdown("AtomicDifficulty", {
    Title = "Difficulty",
    Values = {"Normal", "Medium", "Hard", "Extreme"},
    Multi = false,
    Default = "Normal",
})

AtomicDifficultyDropdown:OnChanged(function(value)
    AtomicDifficulty = value
end)

local AutoFarmAtomic = AtomicSection:AddToggle("AutoFarmAtomic", {
    Title = "Auto Farm Atomic",
    Default = false,
})

local function FindAtomicBoss()
    for _, npc in pairs(NPCs:GetChildren()) do
        if npc.Name:find("AtomicBoss")
        and npc:FindFirstChild("Humanoid")
        and npc.Humanoid.Health > 0 then
            return npc
        end
    end
    return nil
end

-- ========================
-- 💪 Strongest Of Today Boss Section
-- ========================
local StrongestSection = Tabs.Boss:AddSection("Strongest Of Today")

local StrongestofTodayDifficulty = "Normal"

local StrongestofTodayDifficultyDropdown = StrongestSection:AddDropdown("StrongestofTodayDifficulty", {
    Title = "Difficulty",
    Values = {"Normal", "Medium", "Hard", "Extreme"},
    Multi = false,
    Default = "Normal",
})

StrongestofTodayDifficultyDropdown:OnChanged(function(value)
    StrongestofTodayDifficulty = value
end)

local AutoFarmStrongestofToday = StrongestSection:AddToggle("AutoFarmStrongestofToday", {
    Title = "Auto Farm Strongest Of Today",
    Default = false,
})

local function FindStrongestofTodayBoss()
    for _, npc in pairs(NPCs:GetChildren()) do
        local name = npc.Name:lower()
        if name:find("strongestoftodayboss")
        and npc:FindFirstChild("Humanoid")
        and npc.Humanoid.Health > 0 then
            return npc
        end
    end
    return nil
end

-- ========================
-- 🏛️ Strongest Of History Boss Section
-- ========================
local HistorySection = Tabs.Boss:AddSection("Strongest Of History")

local HistoryDifficulty = "Normal"

local HistoryDifficultyDropdown = HistorySection:AddDropdown("HistoryDifficulty", {
    Title = "Difficulty",
    Values = {"Normal", "Medium", "Hard", "Extreme"},
    Multi = false,
    Default = "Normal",
})

HistoryDifficultyDropdown:OnChanged(function(value)
    HistoryDifficulty = value
end)

local AutoFarmHistory = HistorySection:AddToggle("AutoFarmHistory", {
    Title = "Auto Farm Strongest In History",
    Default = false,
})

local function FindHistoryBoss()
    for _, npc in pairs(NPCs:GetChildren()) do
        local name = npc.Name:lower()
        if name:find("strongestinhistoryboss")
        and npc:FindFirstChild("Humanoid")
        and npc.Humanoid.Health > 0 then
            return npc
        end
    end
    return nil
end

-- ========================
-- 🏛️ True Aizen Boss Section
-- ========================

local TrueAizenSection = Tabs.Boss:AddSection("True Aizen")

local TrueAizenDifficulty = "Normal"

local TrueAizenDifficultyDropdown = TrueAizenSection:AddDropdown("TrueAizenDifficulty", {
    Title = "Difficulty",
    Values = {"Normal", "Medium", "Hard", "Extreme"},
    Multi = false,
    Default = "Normal",
})

TrueAizenDifficultyDropdown:OnChanged(function(value)
    HistoryDifficulty = value
end)

local AutoFarmTrueAizen = TrueAizenSection:AddToggle("AutoFarmTrueAizen", {
    Title = "Auto Farm True Aizen",
    Default = false,
})

local function FindTrueAizenBoss()
    for _, npc in pairs(NPCs:GetChildren()) do
        local name = npc.Name:lower()
        if name:find("trueaizenboss")
        and npc:FindFirstChild("Humanoid")
        and npc.Humanoid.Health > 0 then
            return npc
        end
    end
    return nil
end

-- ========================
-- Dungeon Tabs
-- ========================
Tabs.Dungeon:AddButton({
    Title       = "Unlock Dungeon",
    Description = "Collect All Dungeon Piece",
    Callback    = function()
        TPIsland("Dungeon")
        task.wait(1)

        local npc = workspace:WaitForChild("ServiceNPCs"):WaitForChild("DungeonPortalsNPC")
        for i = 1, 3 do
            TP(npc.HumanoidRootPart.CFrame)
            local prompt = npc.HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
                task.wait(0.5)
            end
        end

        TPIsland("Starter")
        task.wait(1)
        local piece = workspace:WaitForChild("StarterIsland"):WaitForChild("DungeonPuzzlePiece")
        for i = 1, 3 do
            TP(piece.CFrame)
            local prompt = piece:FindFirstChildOfClass("ProximityPrompt")
            if prompt then fireproximityprompt(prompt); task.wait(0.5) end
        end

        TPIsland("Jungle")
        task.wait(1)
        local piece2 = workspace:WaitForChild("JungleIsland"):WaitForChild("DungeonPuzzlePiece")
        for i = 1, 3 do
            TP(piece2.CFrame)
            local prompt = piece2:FindFirstChildOfClass("ProximityPrompt")
            if prompt then fireproximityprompt(prompt); task.wait(0.5) end
        end

        TPIsland("Desert")
        task.wait(1)
        local piece3 = workspace:WaitForChild("DesertIsland"):WaitForChild("DungeonPuzzlePiece")
        for i = 1, 3 do
            TP(piece3.CFrame)
            local prompt = piece3:FindFirstChildOfClass("ProximityPrompt")
            if prompt then fireproximityprompt(prompt); task.wait(0.5) end
        end

        TPIsland("Snow")
        task.wait(1)
        local piece4 = workspace:WaitForChild("SnowIsland"):WaitForChild("DungeonPuzzlePiece")
        for i = 1, 3 do
            TP(piece4.CFrame)
            local prompt = piece4:FindFirstChildOfClass("ProximityPrompt")
            if prompt then fireproximityprompt(prompt); task.wait(0.5) end
        end

        TPIsland("Shibuya")
        task.wait(1)
        local piece5 = workspace:WaitForChild("ShibuyaStation"):WaitForChild("DungeonPuzzlePiece")
        for i = 1, 3 do
            TP(piece5.CFrame)
            local prompt = piece5:FindFirstChildOfClass("ProximityPrompt")
            if prompt then fireproximityprompt(prompt); task.wait(0.5) end
        end

        TPIsland("HollowIsland")
        task.wait(1)
        local piece6 = workspace:WaitForChild("HollowIsland"):WaitForChild("DungeonPuzzlePiece")
        for i = 1, 3 do
            TP(piece6.CFrame)
            local prompt = piece6:FindFirstChildOfClass("ProximityPrompt")
            if prompt then fireproximityprompt(prompt); task.wait(0.5) end
        end
    end
})

-- ========================
-- 🏰 Dungeon Section
-- ========================
local DungeonSection = Tabs.Dungeon:AddSection("Dungeon")

local DungeonModule = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("DungeonConfig"))

local DungeonList = {}
local DungeonMap = {}

for dungeonId, data in pairs(DungeonModule.Dungeons) do
    if data.Enabled == nil or data.Enabled == true then
        table.insert(DungeonList, data.DisplayName)
        DungeonMap[data.DisplayName] = dungeonId
    end
end

table.sort(DungeonList)

local DungeonDropdown = Tabs.Dungeon:AddDropdown("DungeonSelect", {
    Title = "Select Dungeon",
    Values = DungeonList,
    Multi = false,
    Default = DungeonList[1],
})

local AutoJoinDungeon = Tabs.Dungeon:AddToggle("AutoJoinDungeon", {
    Title = "Auto Join Dungeon",
    Default = false,
})

local AutoStartPortal = Tabs.Dungeon:AddToggle("AutoStartPortal", {
    Title = "Auto Start Portal",
    Default = false,
})

local DungeonDifficultySelect = Tabs.Dungeon:AddDropdown("DungeonDifficultySelect", {
    Title = "Select Dungeon Difficulty",
    Values = {"Easy", "Medium", "Hard", "Extreme"},
    Multi = false,
    Default = "Easy"
})

local AutoVoteDifficulty = Tabs.Dungeon:AddToggle("AutoVoteDifficulty", {
    Title = "Auto Vote Difficulty",
    Default = false
})

local MainDungeonSection = Tabs.Dungeon:AddSection("Main Dungeon Options")

local AutoFarmDungeon = Tabs.Dungeon:AddToggle("AutoFarmDungeon", {
    Title = "Auto Farm Dungeon",
    Default = false,
})

local AutoReplayDungeon = Tabs.Dungeon:AddToggle("AutoReplayDungeon", {
    Title = "Auto Replay Dungeon",
    Default = false,
})

local AutoStartTower = Tabs.Dungeon:AddToggle("AutoStartTower", {
    Title = "Auto Start Tower",
    Default = false,
})

local DungeonResetWave = Tabs.Dungeon:AddInput("DungeonResetWave", {
    Title = "Dungeon Reset Wave",
    Default = "0",
    Description = "Enter 0 to disable auto reset",
    Placeholder = "Enter wave number",
    Numeric = true,
    Finished = true,
    Callback = function()
        task.wait()
        local value = Options.DungeonResetWave.Value
        local num = tonumber(value)
        if not num then return end
        game:GetService("ReplicatedStorage")
            :WaitForChild("RemoteEvents")
            :WaitForChild("SetAutoTowerReset")
            :FireServer(num)
    end
})



-- 🎯 SELECT DIFFICULTY (FIX)
-- ========================
local function SelectDungeonDifficulty()
    local difficulty = Options.DungeonDifficultySelect.Value
    if not difficulty then return end

    local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    local dungeonUI = playerGui and playerGui:FindFirstChild("DungeonUI")
    local actions = dungeonUI and dungeonUI:FindFirstChild("ContentFrame")
        and dungeonUI.ContentFrame:FindFirstChild("Actions")
    if not actions then return end

    local frame, btn

    if difficulty == "Easy" then
        frame = actions:FindFirstChild("EasyDifficultyFrame")
        btn = frame and frame:FindFirstChild("EasyDifficultyButton")

    elseif difficulty == "Medium" then
        frame = actions:FindFirstChild("MediumDifficultyFrame")
        btn = frame and frame:FindFirstChild("MediumDifficultyButton")

    elseif difficulty == "Hard" then
        frame = actions:FindFirstChild("HardDifficultyFrame")
        btn = frame and frame:FindFirstChild("HardDifficultyButton")

    elseif difficulty == "Extreme" then
        frame = actions:FindFirstChild("ExtremeDifficultyFrame")
        btn = frame and frame:FindFirstChild("ExtremeDifficultyButton")
    end

    if frame and btn then
        if frame.Visible then
            if not actions.visible then return end
            game:GetService("GuiService").SelectedObject = btn
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            wait(1)
        end
    end
end

-- ========================
-- 🔄 LOOP
-- ========================
task.spawn(function()
    while true do
        task.wait(1)

        if not AutoVoteDifficulty.Value or not IsInDungeon() then 
            continue 
        end

        SelectDungeonDifficulty()
        task.wait(10)
    end
end)


task.spawn(function()
    local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
    local requestPortal = remotes:WaitForChild("RequestDungeonPortal")

    while true do
        task.wait(1)

        if not AutoJoinDungeon.Value or IsInDungeon() then 
            continue 
        end

        local selectedName = Options.DungeonSelect.Value
        if not selectedName then continue end

        local dungeonId = DungeonMap[selectedName]
        
        if dungeonId then
            requestPortal:FireServer(dungeonId)
            task.wait(3) 
        end
    end
end)


task.spawn(function()
    while true do
        task.wait(0.5)

        if not AutoStartPortal.Value then continue end

        local player = game:GetService("Players").LocalPlayer
        local playerGui = player:FindFirstChild("PlayerGui")
        local ui = playerGui and playerGui:FindFirstChild("DungeonPortalActionUI")

        if ui then
            local container = ui:FindFirstChild("ButtonContainer")
            local button = container and container:FindFirstChild("StartButton")

            if button and button.Visible then
                game:GetService("GuiService").SelectedObject = button
                
                local vim = game:GetService("VirtualInputManager")
                vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

                task.wait(3)
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5) 

        if not AutoStartTower.Value then continue end

        local player = game:GetService("Players").LocalPlayer
        local playerGui = player:FindFirstChild("PlayerGui")
        local ui = playerGui and playerGui:FindFirstChild("DungeonUI")
        
        if ui then
            local contentFrame = ui:FindFirstChild("ContentFrame")
            local peopleVoted = contentFrame and contentFrame:FindFirstChild("PeopleVoted")
            local buttonFrame = peopleVoted and peopleVoted:FindFirstChild("ButtonFrame")
            local button = buttonFrame and buttonFrame:FindFirstChild("StartButton")

            if button and button.Visible then
                game:GetService("GuiService").SelectedObject = button
                
                local vim = game:GetService("VirtualInputManager")
                vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                
                task.wait(3)
            end
        end
    end
end)

-- ========================
-- 🔁 REPLAY
-- ========================
local function ClickReplayDungeon()
    local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return false end

    local dungeonUI = playerGui:FindFirstChild("DungeonUI")
    if not dungeonUI then return false end

    local replayFrame = dungeonUI:FindFirstChild("ReplayDungeonFrameVisibleOnlyWhenClearingDungeon")
    if not replayFrame then return false end

    local holder = replayFrame:FindFirstChild("Holder")
    if not holder then return false end

    local btn = holder:FindFirstChild("Button")
        and holder.Button:FindFirstChild("ReplayDungeonButton")

    if btn then
        if not replayFrame.Visible then return end
        game:GetService("GuiService").SelectedObject = btn
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        wait(1)
        return true
    end

    return false
end

-- ========================
-- 🔄 Replay LOOP
-- ========================
task.spawn(function()
    while true do
        if AutoReplayDungeon.Value and IsInDungeon() then
            ClickReplayDungeon()
            task.wait(1) 
        end
        task.wait(1)
    end
end)
-- ========================
-- Auto Hokyogu Quest
-- ========================
local UnlockHokyogu = Tabs.Misc:AddButton({
    Title = "Unlock Hokyogu Quest",
    Callback = function()
        TPIsland("HollowIsland")
        task.wait(1)
        local npc = workspace:WaitForChild("ServiceNPCs"):WaitForChild("HogyokuQuestNPC")
        for i = 1, 3 do
            TP(CFrame.new(-379.5702819824219, 8.73462963104248, 1529.378173828125))
            local prompt = npc:WaitForChild("HumanoidRootPart"):FindFirstChildOfClass("ProximityPrompt")
            if prompt then fireproximityprompt(prompt); task.wait(0.5) end
        end

        local piece1 = workspace:WaitForChild("HogyokuFragment3")
        if piece1 then
            for i = 1, 3 do
                TP(piece1.CFrame)
                local prompt = piece1:FindFirstChildOfClass("ProximityPrompt")
                if prompt then fireproximityprompt(prompt); task.wait(0.5) end
            end
        end

        TPIsland("Snow")
        task.wait(1)
        local piece2 = workspace:WaitForChild("HogyokuFragment1")
        if piece2 then
            for i = 1, 3 do
                TP(piece2.CFrame)
                local prompt = piece2:FindFirstChildOfClass("ProximityPrompt")
                if prompt then fireproximityprompt(prompt); task.wait(0.5) end
            end
        end

        TPIsland("Shibuya")
        task.wait(1)
        local piece3 = workspace:WaitForChild("HogyokuFragment2")
        if piece3 then
            for i = 1, 3 do
                TP(piece3.CFrame)
                local prompt = piece3:FindFirstChildOfClass("ProximityPrompt")
                if prompt then fireproximityprompt(prompt); task.wait(0.5) end
            end
        end

        TPIsland("Shinjuku")
        task.wait(1)
        local piece4 = workspace:WaitForChild("HogyokuFragment4")
        if piece4 then
            for i = 1, 3 do
                TP(piece4.CFrame)
                local prompt = piece4:FindFirstChildOfClass("ProximityPrompt")
                if prompt then fireproximityprompt(prompt); task.wait(0.5) end
            end
        end

        TPIsland("Slime")
        task.wait(1)
        local piece5 = workspace:WaitForChild("HogyokuFragment5")
        if piece5 then
            for i = 1, 3 do
                TP(piece5.CFrame)
                local prompt = piece5:FindFirstChildOfClass("ProximityPrompt")
                if prompt then fireproximityprompt(prompt); task.wait(0.5) end
            end
        end

        TPIsland("Judgement")
        task.wait(1)
        local piece6 = workspace:WaitForChild("HogyokuFragment6")
        if piece6 then
            for i = 1, 3 do
                TP(piece6.CFrame)
                local prompt = piece6:FindFirstChildOfClass("ProximityPrompt")
                if prompt then fireproximityprompt(prompt); task.wait(0.5) end
            end
        end
    end
})


-- ========================
-- Auto Buso Haki
-- ========================
local AutoBuso = Tabs.Misc:AddToggle("AutoBuso", { Title = "Auto Buso", Default = false })
Options.AutoBuso:SetValue(false)

task.spawn(function()
    local CurrentIsland = nil

    while task.wait() do
        if not AutoBuso.Value then continue end

        if not player.Character or not player.Character.Parent then
            player.CharacterAdded:Wait()
        end

        local char = player.Character
        local hrp = char:WaitForChild("HumanoidRootPart")

        local questUI = player:WaitForChild("PlayerGui")
            :WaitForChild("QuestUI")
            :WaitForChild("Quest")

        local questInfo = questUI
            :WaitForChild("Quest")
            :WaitForChild("Holder")
            :WaitForChild("Content")
            :WaitForChild("QuestInfo")

        local description = questInfo:WaitForChild("QuestDescription").Text

        local isHakiQuest =
            string.find(description, "Kill 150")
            or string.find(description, "Use Z")
            or string.find(description, "Punch 750")

        if questUI.Visible and not isHakiQuest then
            ReplicatedStorage:WaitForChild("RemoteEvents")
                :WaitForChild("QuestAbandon")
                :FireServer()
            task.wait(0.5)
            continue
        end

        if not questUI.Visible then
            ReplicatedStorage:WaitForChild("RemoteEvents")
                :WaitForChild("QuestAccept")
                :FireServer("HakiQuestNPC")
            task.wait(1)
            continue
        end

        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            local equipped = char:FindFirstChildOfClass("Tool")
            if not equipped or equipped.Name ~= "Combat" then
                local tool = player.Backpack:FindFirstChild("Combat")
                if tool then
                    humanoid:EquipTool(tool)
                end
            end
        end

        local function doTP(island)
            local tp = ReplicatedStorage:FindFirstChild("Remotes")
                and ReplicatedStorage.Remotes:FindFirstChild("TeleportToPortal")
            if tp and CurrentIsland ~= island then
                tp:FireServer(island)
                CurrentIsland = island
                task.wait(2)
            end
        end

        if string.find(description, "Kill 150") then
            doTP("Starter")

            local npcs = workspace:WaitForChild("NPCs")
            local target = nil
            local shortest = math.huge

            for _, npc in pairs(npcs:GetChildren()) do
                if npc.Name ~= "TrainingDummy"
                and npc:FindFirstChild("Humanoid")
                and npc.Humanoid.Health > 0
                and npc:FindFirstChild("HumanoidRootPart") then
                    local dist = (npc.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dist <= 500 and dist < shortest then
                        shortest = dist
                        target = npc
                    end
                end
            end

            if target then
                repeat
                    if target.Humanoid.Health <= 0 then break end
                    TP(GetFarmPosition(target.HumanoidRootPart))
                    ReplicatedStorage:WaitForChild("CombatSystem")
                        :WaitForChild("Remotes")
                        :WaitForChild("RequestHit")
                        :FireServer()
                    task.wait(0.05)
                until target.Humanoid.Health <= 0 or not AutoBuso.Value
            end
        end

        if string.find(description, "Use Z") then
            ReplicatedStorage:WaitForChild("AbilitySystem")
                :WaitForChild("Remotes")
                :WaitForChild("RequestAbility")
                :FireServer(1)
            task.wait(0.2)
        end

        if string.find(description, "Punch 750") then
            ReplicatedStorage:WaitForChild("CombatSystem")
                :WaitForChild("Remotes")
                :WaitForChild("RequestHit")
                :FireServer()
            task.wait(0.05)
        end

        if not questUI.Visible then
            doTP("Snow")
            CurrentIsland = nil
            task.wait(2)

            local npc = workspace:WaitForChild("ServiceNPCs"):FindFirstChild("HakiQuestNPC")
            if npc and npc:FindFirstChild("HumanoidRootPart") then
                hrp.CFrame = npc.HumanoidRootPart.CFrame
                task.wait(0.2)
                local prompt = npc.HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    fireproximityprompt(prompt)
                end
            end

            AutoBuso:SetValue(false)

            Fluent:Notify({
                Title = "Haki",
                Content = "Buso Haki Unlocked ✅",
                Duration = 5
            })
        end
    end
end)

local Removeisland = Tabs.Misc:AddToggle("RemoveIslands", {
    Title = "Remove All Islands",
    Default = false,
    Callback = function(Value)
        ToggleMap(Value)
    end
})

local RainbowToggle = Tabs.Misc:AddToggle("RainbowAura", {
    Title = "Rainbow Aura (Client Side)",
    Default = false,
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char then
            if Value then
                char:SetAttribute("RainbowAura", true)
                -- บังคับให้ Particle ทุกอันถูกเปลี่ยนสี
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Beam") then
                        v:SetAttribute("AuraVFX", true)
                    end
                end
            else
                char:SetAttribute("RainbowAura", nil)
            end
        end
    end
})


local discordButton = Tabs.Misc:AddButton({
    Title = "Join Discord",
    Callback = function()
        local success, err = pcall(function()
            return setclipboard("https://discord.gg/TtnFJcgSZY")
        end)

        if success then
            Fluent:Notify({
                Title = "Clipboard",
                Content = "Discord invite link copied to clipboard!",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Failed to copy to clipboard: " .. tostring(err),
                Duration = 5
            })
        end
    end,
})

-- ========================
-- 🌍 Teleport Tab UI
-- ========================
local TeleportSection = Tabs.Teleport:AddSection("Island Teleport")

Tabs.Teleport:AddDropdown("TeleportIslandSelect", {
    Title   = "Select Island",
    Values  = IslandData,
    Multi   = false,
    Default = IslandData[1],
})

Tabs.Teleport:AddButton({
    Title       = "Refresh Island List",
    Description = "",
    Callback    = function()
        local newIslandData = {}
        local s, c = pcall(function()
            return require(ReplicatedStorage.Framework.Shared.Configs.IslandsConfig)
        end)

        if s and type(c) == "table" then
            for _, d in pairs(c) do
                if type(d) == "table" and d.PortalId then
                    table.insert(newIslandData, d.PortalId)
                end
            end
            table.sort(newIslandData)
            Options.TeleportIslandSelect:SetValues(newIslandData)
            Fluent:Notify({Title = "System", Content = "Island Refreshed", Duration = 2})
        end
    end,
})

Tabs.Teleport:AddButton({
    Title       = "Teleport to Island",
    Description = "",
    Callback    = function()
        local selectedIsland = Options.TeleportIslandSelect.Value
        if selectedIsland then
            TPIsland(selectedIsland)
            Fluent:Notify({
                Title    = "Teleport",
                Content  = "Teleporting To: " .. tostring(selectedIsland),
                Duration = 3,
            })
        end
    end,
})

-- ========================
-- 🛍️ Shop / Moveset Tab UI
-- ========================
local ShopSection = Tabs.Shop:AddSection("Moveset Buyer")

local MovesetDropdown = Tabs.Shop:AddDropdown("MovesetSelect", {
    Title   = "Select Moveset NPC",
    Values  = MovesetData,
    Multi   = false,
    Default = MovesetData[1],
})

Tabs.Shop:AddButton({
    Title       = "Buy",
    Description = "Buy Selected",
    Callback    = function()
        local targetNPCName = Options.MovesetSelect.Value
        local npcModel = workspace.ServiceNPCs:FindFirstChild(targetNPCName)

        if npcModel then
            local targetCFrame = npcModel:GetPivot()
            hrp.CFrame = targetCFrame * CFrame.new(0, 0, 3)
            task.wait(0.1)

            local prompt = npcModel:FindFirstChildWhichIsA("ProximityPrompt", true)

            if prompt then
                for i = 1, 5 do
                    fireproximityprompt(prompt)
                    task.wait(0.1)
                end
                Fluent:Notify({
                    Title    = "Success",
                    Content  = "Spammed Interact with " .. targetNPCName .. " (5x)",
                    Duration = 3
                })
            else
                Fluent:Notify({
                    Title    = "Prompt Not Found",
                    Content  = "Found NPC But Not Found Prompt",
                    Duration = 3
                })
            end
        else
            Fluent:Notify({
                Title    = "NPC Not Found",
                Content  = "Not Found " .. tostring(targetNPCName) .."",
                Duration = 3
            })
        end
    end,
})

local ObsBuyer = Tabs.Shop:AddButton({
    Title = "Buy Observation Haki",
    Description = "Req. 250,000 Money & 300 Gems",
    Callback = function ()
        TPIsland("Desert")
        local ObsTrainer = workspace.ServiceNPCs.ObservationBuyer
        local hrm = ObsTrainer:WaitForChild("HumanoidRootPart")
        task.wait(0.2)
        TP(hrm.CFrame)
        for i = 1, 5 do
            fireproximityprompt(hrm:FindFirstChildWhichIsA("ProximityPrompt"))
            task.wait(0.1)
        end
    end
})

-- ========================
-- 📊 Stat Tab UI
-- ========================
local StatDropdown = Tabs.Stat:AddDropdown("StatSelect", {
    Title   = "Select Stat",
    Values  = { "Melee", "Defense", "Sword", "Power" },
    Multi   = true,
    Default = {},
})

local selectedStats = {}

local function updateSelectedStats()
    selectedStats = {}
    local value = StatDropdown.Value

    if type(value) == "table" then
        for key, val in pairs(value) do
            if val == true and type(key) == "string" then
                table.insert(selectedStats, key)
            elseif type(val) == "string" then
                table.insert(selectedStats, val)
            end
        end
    elseif type(value) == "string" then
        table.insert(selectedStats, value)
    end

    return selectedStats
end

StatDropdown:OnChanged(function()
    updateSelectedStats()
end)

local AutoStat = Tabs.Stat:AddToggle("AutoStat", { Title = "Auto Stat", Default = false })

task.spawn(function()
    while task.wait(0.01) do
        if not AutoStat.Value or not char then continue end

        updateSelectedStats()

        local statPoints = 0
        if player:FindFirstChild("Data") and player.Data:FindFirstChild("StatPoints") then
            statPoints = player.Data.StatPoints.Value
        end

        if statPoints <= 0 or #selectedStats == 0 then continue end

        for _, statName in ipairs(selectedStats) do
            if statPoints <= 0 then break end
            ReplicatedStorage
                :WaitForChild("RemoteEvents")
                :WaitForChild("AllocateStat")
                :FireServer(statName, 3)
            statPoints = statPoints - 1
            task.wait(0.2)
        end
    end
end)


-- ========================
-- Reroll
-- ========================
local RaceSection = Tabs.Reroll:AddSection("Race")

local SortedRaces = {}

for raceName, raceData in pairs(RaceConfig.Races) do
    local rarityName = raceData.rarity or "Common"
    -- ดึงค่า Order จาก Rarities Table (Common = 1, Mythical = 6)
    local rarityOrder = RaceConfig.Rarities[rarityName] and RaceConfig.Rarities[rarityName].order or 1
    
    table.insert(SortedRaces, {
        Name = raceName,
        Rarity = rarityName,
        Order = rarityOrder,
        DisplayName = raceName .. " - " .. rarityName -- รูปแบบที่จะโชว์ใน UI
    })
end

-- 2. ทำการ Sort ตารางตามค่า Order
table.sort(SortedRaces, function(a, b)
    return a.Order > b.Order -- เรียงจากน้อยไปมาก (Common -> Mythical)
end)

-- 3. ดึงเฉพาะ DisplayName ออกมาใส่ใน Dropdown Options
local RaceDropdownOptions = {}
for _, item in ipairs(SortedRaces) do
    table.insert(RaceDropdownOptions, item.DisplayName)
end

local RaceDropdown = RaceSection:AddDropdown("RaceSelect", {
    Title = "Select Target Races",
    Values = RaceDropdownOptions,
    Multi = true,
    Default = {},
})

local AutoRollToggle = RaceSection:AddToggle("AutoRollToggle", {
    Title = "Auto Race Reroll", 
    Default = false 
})

task.spawn(function()
    while true do
        if AutoRollToggle.Value then 
            local statsUI = player.PlayerGui:FindFirstChild("StatsPanelUI")
            local statLabel = statsUI and statsUI.MainFrame.Frame.Content.SideFrame.UserStats.RaceEquipped:FindFirstChild("StatName")
            
            if statLabel then
                -- ดึงข้อความดิบจาก UI (เช่น "Race: Fishman")
                local currentRaceText = statLabel.Text
                local isTargetReached = false
                
                -- ลูปเช็คค่าที่ผู้ใช้เลือกไว้ใน Dropdown
                for k, v in pairs(RaceDropdown.Value) do
                    -- ดึงชื่อเผ่าจาก Format "Name - Rarity"
                    local textToSplit = type(k) == "string" and k or v
                    if type(textToSplit) == "string" then
                        local targetName = string.split(textToSplit, " - ")[1]
                        
                        -- ใช้ string.find เช็คว่ามีชื่อเผ่าที่ต้องการ อยู่ในข้อความ UI หรือไม่
                        -- ผลลัพธ์: string.find("Race: Fishman", "Fishman") จะคืนค่าตำแหน่งที่พบ (ไม่เป็น nil)
                        if string.find(currentRaceText, targetName) then
                            isTargetReached = true
                            break
                        end
                    end
                end

                if isTargetReached then
                    -- หยุดสุ่มเมื่อเจอเผ่าที่เลือก
                    AutoRollToggle:SetValue(false) 
                    Fluent:Notify({
                        Title = "Klakuylek Hub",
                        Content = "Target Reached: " .. currentRaceText,
                        Duration = 5
                    })
                else
                    -- ส่ง Remote ไปสุ่มเผ่าใหม่
                    UseItemRemote:FireServer("Use", "Race Reroll", 1, true)
                end
            end
        end
        
        -- ใช้ Delay ตามที่ Module กำหนด หรือ Default ที่ 0.5 วินาที
        task.wait(0.3)
    end
end)

--trait section
do
    local TraitConfig = require(game:GetService("ReplicatedStorage").Modules.TraitConfig)
    local RemoteEvents = game:GetService("ReplicatedStorage").RemoteEvents
    local TraitRerollRemote = RemoteEvents:WaitForChild("TraitReroll")
    local TraitDataUpdate = RemoteEvents:WaitForChild("TraitDataUpdate")

    -- สร้างลำดับ Rarity (เอาไว้ Sort)
    local RarityOrder = {
        ["Common"] = 1, ["Uncommon"] = 2, ["Rare"] = 3, 
        ["Epic"] = 4, ["Legendary"] = 5, ["Mythical"] = 6, ["Secret"] = 7
    }

    local SortedTraits = {}
    for name, data in pairs(TraitConfig.Traits) do
        table.insert(SortedTraits, {
            Name = name,
            Rarity = data.Rarity or "Common",
            Order = RarityOrder[data.Rarity] or 0
        })
    end

    -- เรียงจากน้อยไปมาก
    table.sort(SortedTraits, function(a, b) return a.Order > b.Order end)

    local TraitOptions = {}
    for _, trait in ipairs(SortedTraits) do
        table.insert(TraitOptions, trait.Name .. " - " .. trait.Rarity)
    end

    local TraitSection = Tabs.Reroll:AddSection("Trait")

    -- Paragraph สำหรับแสดงข้อมูลแบบ Real-time
    local TraitInfoLabel = TraitSection:AddParagraph("TraitInfoLabel", {
        Title = "Current Trait Info",
        Content = "Trait: Loading...\nPity: Loading..."
    })

    -- Dropdown เลือก Trait
    local TraitSelectDropdown = TraitSection:AddDropdown("TraitSelect", {
        Title = "Select Target Traits",
        Values = TraitOptions,
        Multi = true,
        Default = {},
    })

    -- Toggle สำหรับเริ่ม/หยุด
    local AutoTraitToggle = TraitSection:AddToggle("AutoTraitToggle", {
        Title = "Auto Trait Reroll", 
        Default = false 
    })

    local CurrentTrait = "None"
    local MythicPity = "0/0"
    local SecretPity = "0/0"

    local function FormatPity(p, mp)
        if p and mp then
            return p .. "/" .. mp
        end
        return "0/0"
    end
    -- ฟังก์ชันอัปเดต Paragraph
    local function UpdateTraitDisplay()
        local content = table.concat({
            "🧬 Current Trait : " .. CurrentTrait,
            "✨ Mythic Pity : " .. MythicPity,
            "🌀 Secret Pity : " .. SecretPity
        }, "\n")
        
        TraitInfoLabel:SetValue(content)
    end

    local function IsTargetReached()
        local selected = TraitSelectDropdown.Value
        for selectedDisplay, _ in pairs(selected) do
            local targetName = string.split(selectedDisplay, " - ")[1]
            if CurrentTrait == targetName then
                return true
            end
        end
        return false
    end

    task.spawn(function()
        while task.wait(0.1) do -- ปรับให้เร็วขึ้นเล็กน้อย
            if AutoTraitToggle.Value then
                -- 1. ตรวจสอบเป้าหมายใน Dropdown
                local hasTarget = false
                for _ in pairs(TraitSelectDropdown.Value) do hasTarget = true break end
                
                if not hasTarget then
                    AutoTraitToggle:SetValue(false)
                    Fluent:Notify({
                        Title = "Klakuylek Hub",
                        Content = "Please select a target trait first!",
                        Duration = 3
                    })
                    continue
                end

                -- 2. เช็คว่าเจอเป้าหมายหรือยัง
                if IsTargetReached() then
                    AutoTraitToggle:SetValue(false)
                    UpdateTraitDisplay()
                    Fluent:Notify({
                        Title = "Klakuylek Hub",
                        Content = "Target Found: " .. CurrentTrait,
                        Duration = 5
                    })
                else
                    -- 3. ถ้ายังไม่เจอ ให้เช็คว่าต้อง Force Skip ไหม?
                    -- เกมจะหยุดถ้าได้ Mythic/Secret เราจึงต้องยิง Confirm เพื่อสุ่มต่อ
                    local TraitConfirmRemote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("TraitConfirm")
                    
                    -- ยิง Confirm เพื่อเคลียร์สถานะการล็อค (Force Skip)
                    TraitConfirmRemote:FireServer(true)
                    
                    -- 4. ส่งคำสั่งสุ่มรอบใหม่
                    TraitRerollRemote:FireServer()
                    
                    -- 5. รอข้อมูลอัปเดตกลับมา
                    local data = TraitDataUpdate.OnClientEvent:Wait()
                    
                    -- 6. อัปเดตข้อมูลและ UI
                    if data then
                        if data.RolledTrait or data.Trait then
                            CurrentTrait = data.RolledTrait or data.Trait
                        end
                        MythicPity = FormatPity(data.MythicPity, data.MaxMythicPity)
                        SecretPity = FormatPity(data.SecretPity, data.MaxSecretPity)
                    end
                    UpdateTraitDisplay()
                end
            end
        end
    end)
    -- สั่งให้ดึงข้อมูลครั้งแรกมาโชว์
    local initialData = RemoteEvents:WaitForChild("TraitGetData"):InvokeServer()
    if initialData then
        CurrentTrait = initialData.Trait or "None"
        MythicPity = FormatPity(initialData.MythicPity, initialData.MaxMythicPity)
        SecretPity = FormatPity(initialData.SecretPity, initialData.MaxSecretPity)
        UpdateTraitDisplay()
    end

end

-- ========================
-- ⚙️ CONFIG
-- ========================
local TP_ISLAND_DISTANCE = 700
local AGGRO_RANGE = 100

local State = "IDLE"

local function GetAllEnemies()
    local list = {}

    for _, npc in pairs(workspace:WaitForChild("NPCs"):GetChildren()) do
        if npc:FindFirstChild("Humanoid")
        and npc.Humanoid.Health > 0
        and npc:FindFirstChild("HumanoidRootPart") then
            local name = npc.Name:match("^([%a_]+)")
            if name == Enemy then
                table.insert(list, npc)
            end
        end
    end

    return list
end

local function GetNearbyEnemies(all)
    local list = {}

    for _, mob in pairs(all) do
        local dist = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
        if dist <= AGGRO_RANGE then
            table.insert(list, mob)
        end
    end

    return list
end

-- ========================
-- 🔍 Check Boss/Mob Spawn
-- ========================
local function CheckBossSpawn()
    updateSelectedBosses()

    if #selectedBosses == 0 then
        return false, nil, nil
    end

    local npcs = workspace:WaitForChild("NPCs")

    for _, selectedName in ipairs(selectedBosses) do
        local data = getBossDataByName(selectedName)
        if data then
            for _, npc in pairs(npcs:GetChildren()) do
                local humanoid = npc:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    if string.find(npc.Name, data.Boss) then
                        return true, npc, data
                    end
                end
            end
        end
    end

    return false, nil, nil
end

local function CheckMobSpawn()
    updateSelectedMobs()

    if #SelectedMobs == 0 then return false, nil, nil end

    local npcs = workspace:WaitForChild("NPCs")

    for _, mobName in ipairs(SelectedMobs) do
        for _, data in pairs(EnemyData) do
            if data.Enemy == mobName then
                for _, npc in pairs(npcs:GetChildren()) do
                    local humanoid = npc:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local cleanName = npc.Name:gsub("%d+$", "")
                        if cleanName == mobName then
                            return true, npc, data
                        end
                    end
                end
            end
        end
    end

    return false, nil, nil
end


-- =======================================================================================
-- 🔥 [REFACTORED] GENERIC BOSS LOOP FACTORY & CONSOLIDATED MAIN HEARTBEAT
-- =======================================================================================

local function CreateBossLoop(config)
    RunService.Heartbeat:Connect(function()
        if not config.Toggle.Value then return end

        if not char or not char.Parent then
            refreshCharacter(player.Character or player.CharacterAdded:Wait())
        end

        if not hrp or not hrp.Parent then
            hrp = char:WaitForChild("HumanoidRootPart")
        end

        ResetVelocity()

        local boss = config.FindBoss()

        if boss then
            local distance = GetDistanceToEnemy(boss)
            if distance > 700 then
                if config.CustomTP then
                    TP(config.CustomTP)
                else
                    TPIsland(config.Island)
                end
            else
                local bossHRP = boss:FindFirstChild("HumanoidRootPart")
                if bossHRP then
                    TP(GetFarmPosition(bossHRP))
                    Attack(boss)
                end
            end
        else
            config.Summon()
        end
    end)
end

-- 🔹 Instantiate All Boss Loops Here
CreateBossLoop({
    Toggle = AutoSummonBoss,
    FindBoss = function()
        local selectedName = Options.SummonBossSelect.Value
        if not selectedName then return nil end
        local bossData = SummonBossMap[selectedName]
        if not bossData then return nil end
        return FindSummonedBoss(bossData.bossId)
    end,
    Summon = function()
        local selectedName = Options.SummonBossSelect.Value
        if not selectedName then return end
        local bossData = SummonBossMap[selectedName]
        if not bossData then return end
        SummonBoss(bossData.bossId, Options.SummonBossDifficulty.Value or "Normal")
    end,
    Island = "Boss"
})

CreateBossLoop({
    Toggle = AutoFarmRimuruToggle,
    FindBoss = FindRimuruBoss,
    Summon = function()
        ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestSpawnRimuru"):FireServer(RimuruDifficulty)
    end,
    Island = "Slime"
})

CreateBossLoop({
    Toggle = AutoFarmAnos,
    FindBoss = FindAnosBoss,
    Summon = function()
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestSpawnAnosBoss"):FireServer("Anos", AnosDifficulty)
    end,
    Island = "Academy"
})

CreateBossLoop({
    Toggle = AutoFarmAtomic,
    FindBoss = FindAtomicBoss,
    Summon = function()
        ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestSpawnAtomic"):FireServer(AtomicDifficulty)
    end,
    Island = "Lawless"
})

CreateBossLoop({
    Toggle = AutoFarmStrongestofToday,
    FindBoss = FindStrongestofTodayBoss,
    Summon = function()
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestSpawnStrongestBoss"):FireServer("StrongestToday", StrongestofTodayDifficulty)
    end,
    Island = "Shinjuku",
    CustomTP = CFrame.new(135.8332061767578, 2.512423038482666, -2433.90673828125)
})

CreateBossLoop({
    Toggle = AutoFarmHistory,
    FindBoss = FindHistoryBoss,
    Summon = function()
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestSpawnStrongestBoss"):FireServer("StrongestHistory", HistoryDifficulty)
    end,
    Island = "Shinjuku",
    CustomTP = CFrame.new(551.7471313476562, 2.511068105697632, -2298.96240234375)
})

CreateBossLoop({
    Toggle = AutoFarmTrueAizen,
    FindBoss = FindTrueAizenBoss,
    Summon = function()
        ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestSpawnTrueAizen"):FireServer(TrueAizenDifficulty)
    end,
    Island = "",
    CustomTP = CFrame.new(-1221.3116455078125, 1603.564697265625, 1760.4005126953125)
    
})

-- 🔹 Consolidated Heartbeat Loop (Kill Aura, Auto Farm Levels, Mobs, Main Boss, Dungeon)
RunService.Heartbeat:Connect(function()
    -- [1] Kill Aura
    if KillAura.Value then
        if not char or not char.Parent then
            refreshCharacter(player.Character or player.CharacterAdded:Wait())
        end
        if not hrp or not hrp.Parent then
            hrp = char:WaitForChild("HumanoidRootPart")
        end

        local range = Options.KillAuraRange.Value or 200
        for _, npc in pairs(workspace:WaitForChild("NPCs"):GetChildren()) do
            local hum = npc:FindFirstChild("Humanoid")
            local root = npc:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and root then
                local dist = (root.Position - hrp.Position).Magnitude
                if dist <= range then
                    Attack(npc)
                end
            end
        end
    end

    -- [2] Auto Farm Levels
    if Options.AutoFarm.Value and not IsBossActive then
        if not char or not char.Parent then
            char = player.Character or player.CharacterAdded:Wait()
        end
        if not hrp or not hrp.Parent then
            hrp = char:WaitForChild("HumanoidRootPart")
        end

        ResetVelocity()

        GetQuest()
        CheckQuest()

        local allEnemies = GetAllEnemies()

        if #allEnemies == 0 then
            TPIsland(Island)
        else
            local closest = math.huge
            for _, mob in pairs(allEnemies) do
                local dist = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < closest then
                    closest = dist
                end
            end

            if closest > TP_ISLAND_DISTANCE then
                TPIsland(Island)
                State = "IDLE"
            elseif closest <= TP_ISLAND_DISTANCE and closest > AGGRO_RANGE then
                local target = nil
                local shortest = math.huge

                for _, mob in pairs(allEnemies) do
                    local hrpMob = mob:FindFirstChild("HumanoidRootPart")
                    if hrpMob then
                        local dist = (hrpMob.Position - hrp.Position).Magnitude
                        if dist < shortest then
                            shortest = dist
                            target = hrpMob
                        end
                    end
                end

                if target then
                    TP(GetFarmPosition(target))
                end
            else
                local mobs = GetNearbyEnemies(allEnemies)
                if #mobs > 0 then
                    if State == "IDLE" then
                        State = "AGGRO"

                        for _, mob in pairs(mobs) do
                            local hrpMob = mob:FindFirstChild("HumanoidRootPart")
                            if hrpMob then
                                local endTime = tick() + 0.2

                                repeat
                                    if not hrp or not hrpMob then break end

                                    hrp.CFrame = GetFarmPosition(hrpMob)
                                    hrp.AssemblyLinearVelocity = Vector3.zero

                                    Attack(mob)
                                    RunService.Heartbeat:Wait()
                                until tick() > endTime
                            end
                        end

                        State = "FARM"
                    end

                    if State == "FARM" then
                        local targetMob = nil

                        for _, mob in pairs(mobs) do
                            if mob
                            and mob.Parent
                            and mob:FindFirstChild("Humanoid")
                            and mob.Humanoid.Health > 0
                            and mob:FindFirstChild("HumanoidRootPart") then
                                targetMob = mob
                                break
                            end
                        end

                        if not targetMob then
                            State = "IDLE"
                        else
                            local hrpMob = targetMob.HumanoidRootPart

                            hrp.CFrame = GetFarmPosition(hrpMob)
                            hrp.AssemblyLinearVelocity = Vector3.zero

                            Attack(targetMob)
                        end
                    end
                end
            end
        end
    end

    -- [3] Auto Farm Mobs
    if AutoFarmMobs.Value and not IsBossActive then
        if not char or not char.Parent then
            refreshCharacter(player.Character or player.CharacterAdded:Wait())
        end
        if not hrp or not hrp.Parent then
            hrp = char:WaitForChild("HumanoidRootPart")
        end

        ResetVelocity()

        local hasMob, mob, data = CheckMobSpawn()
        if hasMob and mob and data then
            local distance = GetDistanceToEnemy(mob)

            if distance > 700 then
                TPIsland(data.Island)
            else
                if mob:FindFirstChild("HumanoidRootPart") then
                    TP(GetFarmPosition(mob.HumanoidRootPart))
                    Attack(mob)
                end
            end
        end
    end

    -- [4] Auto Farm Boss (Main)
    if AutoFarmBoss.Value then
        IsBossActive = true

        if not char or not char.Parent then
            refreshCharacter(player.Character or player.CharacterAdded:Wait())
        end
        if not hrp or not hrp.Parent then
            hrp = char:WaitForChild("HumanoidRootPart")
        end

        ResetVelocity()

        local hasBoss, boss, data = CheckBossSpawn()
        if hasBoss and boss and data then
            local distance = GetDistanceToEnemy(boss)

            if distance > 700 then
                TPIsland(data.Island)
            else
                if boss:FindFirstChild("HumanoidRootPart") then
                    TP(GetFarmPosition(boss.HumanoidRootPart))
                    Attack(boss)
                end
            end
        else
            IsBossActive = false
        end
    else
        IsBossActive = false
    end

    -- [5] Auto Farm Dungeon
    if AutoFarmDungeon.Value and IsInDungeon() then
        if not char or not char.Parent then
            refreshCharacter(player.Character or player.CharacterAdded:Wait())
        end
        if not hrp or not hrp.Parent then
            hrp = char:WaitForChild("HumanoidRootPart")
        end

        ResetVelocity()

        local closest = nil
        local shortest = math.huge

        for _, npc in pairs(workspace:WaitForChild("NPCs"):GetChildren()) do
            local humanoid = npc:FindFirstChild("Humanoid")
            local root = npc:FindFirstChild("HumanoidRootPart")

            if humanoid and humanoid.Health > 0 and root then
                local dist = (root.Position - hrp.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = npc
                end
            end
        end

        if closest and closest:FindFirstChild("HumanoidRootPart") then
            local targetHRP = closest.HumanoidRootPart
            local dist = (targetHRP.Position - hrp.Position).Magnitude
            if dist > 100 then
                local dungeonspawn = game.workspace.DungeonSpawns:WaitForChild("DungeonPlayerSpawn")
                TP(dungeonspawn.CFrame * CFrame.new(0, 2, 0))
                Attack(closest)
            elseif dist < 100 then
                TP(GetFarmPosition(targetHRP))
                Attack(closest)
            end
        else 
            local dungeonspawn = game.workspace.DungeonSpawns:WaitForChild("DungeonPlayerSpawn")
            TP(dungeonspawn.CFrame * CFrame.new(0, 2, 0))
        end
    end
end)


-- ========================
-- 🌀 MOBILE TOGGLE BUTTON
-- ========================
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local MobileGui = Instance.new("ScreenGui")
MobileGui.Name = "MobileToggleGui"
MobileGui.Parent = game:GetService("CoreGui")
MobileGui.IgnoreGuiInset = true
MobileGui.ResetOnSpawn = false

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MobileGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.BorderSizePixel = 0
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
ToggleButton.Position = UDim2.new(0.5, 0, 0.15, 0)
ToggleButton.Image = "rbxassetid://135519443641857"
ToggleButton.ImageColor3 = Color3.fromRGB(255, 255, 255)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = ToggleButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 3
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = ToggleButton

task.spawn(function()
    local speed = 0.15
    while true do
        local hue = tick() * speed % 1
        UIStroke.Color = Color3.fromHSV(hue, 0.8, 1)
        RunService.Heartbeat:Wait()
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    if Window then
        Window:Minimize()
    end
end)

local dragging, dragInput, dragStart, startPos

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        TweenService:Create(ToggleButton, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    end
end)


-- ========================
-- 🧰 Auto Equip Tool Loop
-- ========================
task.spawn(function()
    while task.wait() do
        if not (
            Options.AutoFarm.Value or
            Options.AutoFarmBoss.Value or
            Options.AutoFarmMobs.Value or
            AutoSummonBoss.Value or
            AutoFarmRimuruToggle.Value or
            AutoFarmAnos.Value or
            AutoFarmAtomic.Value or
            AutoFarmDungeon.Value or
            AutoFarmStrongestofToday.Value or
            AutoFarmHistory.Value or
            AutoFarmTrueAizen.Value
        ) or not char then continue end

        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end

        task.wait(0.5)

        local selectedCategory = ToolDropdown.Value
        if not selectedCategory then continue end

        local equippedTool = char:FindFirstChildOfClass("Tool")

        if equippedTool then
            local currentType = WeaponModule.GetToolStatType(equippedTool.Name)
            if currentType ~= selectedCategory then
                equipCategory(selectedCategory)
            end
        else
            equipCategory(selectedCategory)
        end
    end
end)

-- 🔹 Loop Auto-Skill
task.spawn(function()
    local skillIndex = 1
    while task.wait(0.05) do
        if not AutoSkill.Value or (
            not Options.AutoFarm.Value and
            not AutoFarmBoss.Value and
            not AutoFarmMobs.Value and
            not AutoSummonBoss.Value and
            not AutoFarmRimuruToggle.Value and
            not AutoFarmAnos.Value and
            not AutoFarmAtomic.Value and
            not AutoFarmDungeon.Value and
            not AutoFarmStrongestofToday.Value and
            not AutoFarmHistory.Value and
            not AutoFarmTrueAizen.Value
        ) then continue end

        if not char or not char.Parent then
            refreshCharacter(player.Character or player.CharacterAdded:Wait())
        end

        if not char then continue end

        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end

        updateSelectedSkills()

        if #selectedSkills > 0 then
            local skillToUse = selectedSkills[skillIndex]
            ReplicatedStorage
                :WaitForChild("AbilitySystem")
                :WaitForChild("Remotes")
                :WaitForChild("RequestAbility")
                :FireServer(skillToUse)

            skillIndex = skillIndex + 1
            if skillIndex > #selectedSkills then
                skillIndex = 1
            end
        end
    end
end)

-- ========================
-- ⚙️ Save / UI Manager
-- ========================
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("NonnyHub/game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

local function getAutoSaveFile()
    return "autosave_" .. tostring(player.Name)
end

task.spawn(function()
    local autosaveName = getAutoSaveFile()
    local autosaveFile = SaveManager.Folder .. "/settings/" .. autosaveName .. ".json"

    if isfile(autosaveFile) then
        local success = SaveManager:Load(autosaveName)
        if success then
            Fluent:Notify({
                Title    = "Config",
                Content  = "Auto-loaded settings ✅",
                Duration = 3,
            })
        end
    end
end)

local function autoSave()
    SaveManager:Save(getAutoSaveFile())
end

for _, option in pairs(SaveManager.Options) do
    if option.OnChanged then
        option:OnChanged(autoSave)
    end
end

Window:SelectTab(1)
-- ========================
-- 🔔 Ready Notification
-- ========================
Fluent:Notify({
    Title    = "Loaded",
    Content  = "Auto Farm Ready 🔥",
    Duration = 5,
})

SaveManager:LoadAutoloadConfig()
