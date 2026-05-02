local currentPlaceId = game.PlaceId
local currentUniverseId = game.GameId
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer -- หรือใช้ game.JobId ในบางกรณี แต่ปกติ UniverseId คือ game.GameId

-- เก็บฟังก์ชันแยกไว้เพื่อให้เรียกซ้ำได้ง่าย (ไม่เปลืองบรรทัด)
local function runSea1()
    print("Running: Sea 1 (Default or Specific)")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kenchi3/KlaKuyLek-Sailorpiece/refs/heads/main/sailorpiece_obfuscated.lua"))()
end

local function runSea2()
    print("Running: Sea 2")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kenchi3/KlaKuyLek-Sailorpiece/refs/heads/main/Sea2.lua"))()
end

local function runAotr()
    print("Running: Aotr")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kenchi3/KlaKuyLek-Sailorpiece/refs/heads/main/AOTR.lua"))()
end

-- รายการ PlaceId เฉพาะเจาะจง
local placeScripts = {
    [77747658251236] = runSea1,
    [130167267952199] = runSea2,
}

-- 1. ตรวจสอบจาก PlaceId ก่อน
if placeScripts[currentPlaceId] then
    placeScripts[currentPlaceId]()
    
-- 2. ถ้าไม่เจอ PlaceId แต่ GameId (UniverseId) ตรงกับที่กำหนด
elseif currentUniverseId == 9186719164 then
    print("Sea1")
    runSea1()
elseif currentUniverseId == 4658598196 then
    print("Aotr")
    runAotr()
else
    -- กรณีไม่เข้าเงื่อนไขอะไรเลย
    localPlayer:Kick("Scrript Not Support")
end