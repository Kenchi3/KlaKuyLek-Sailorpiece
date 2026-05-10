-- Ken's Hardened V2 Fix

local b64_0x1lI1l1 = {}
local char_0xl1I1ll='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
for i_0xllIllI=1,#char_0xl1I1ll do b64_0x1lI1l1[char_0xl1I1ll:sub(i_0xllIllI,i_0xllIllI)] = i_0xllIllI - 1 end

function b64_0x1lI1l1.dec_0xllIlII(d_0x11II1I)
    d_0x11II1I = string.gsub(d_0x11II1I, '[^'..char_0xl1I1ll..'=]', '')
    local r_0xll1Ill = {}
    for i_0xllIllI=1, #d_0x11II1I, 4 do
        local c_0xII11lI = b64_0x1lI1l1[d_0x11II1I:sub(i_0xllIllI,i_0xllIllI)] or 0
        local c_0xII1Il1 = b64_0x1lI1l1[d_0x11II1I:sub(i_0xllIllI+1,i_0xllIllI+1)] or 0
        local c_0xIlllII, c_0xlIII1l = 0, 0
        local has3 = true
        local has4 = true
        local ch3 = d_0x11II1I:sub(i_0xllIllI+2,i_0xllIllI+2)
        if ch3 == "=" then has3 = false else c_0xIlllII = b64_0x1lI1l1[ch3] or 0 end
        local ch4 = d_0x11II1I:sub(i_0xllIllI+3,i_0xllIllI+3)
        if ch4 == "=" then has4 = false else c_0xlIII1l = b64_0x1lI1l1[ch4] or 0 end
        local b_0xlIllll = c_0xII11lI * (2^18) + c_0xII1Il1 * (2^12) + c_0xIlllII * (2^6) + c_0xlIII1l
        local b_0x1l1lI1 = math.floor(b_0xlIllll / (2^16)) % (2^8)
        local b_0xIl1IIl = math.floor(b_0xlIllll / (2^8)) % (2^8)
        local b_0xl1IIll = b_0xlIllll % (2^8)
        table.insert(r_0xll1Ill, string.char(b_0x1l1lI1))
        if has3 then table.insert(r_0xll1Ill, string.char(b_0xIl1IIl)) end
        if has4 then table.insert(r_0xll1Ill, string.char(b_0xl1IIll)) end
    end
    return table.concat(r_0xll1Ill)
end


local function bxor_0xlIlIlI(a_0xlIlIl1,b_0x111lI1)
    if bit32 then return bit32.bxor(a_0xlIlIl1,b_0x111lI1) end
    local r_0x1llIlI = 0
    for i_0xlIl1ll = 0, 7 do
        local x_0xlll1II = a_0xlIlIl1 % 2
        local y_0xI1lIl1 = b_0x111lI1 % 2
        if x_0xlll1II ~= y_0xI1lIl1 then r_0x1llIlI = r_0x1llIlI + (2^i_0xlIl1ll) end
        a_0xlIlIl1 = math.floor(a_0xlIlIl1 / 2)
        b_0x111lI1 = math.floor(b_0x111lI1 / 2)
    end
    return r_0x1llIlI
end


local function bxor_str_0xI1IIIl(s_0x1111Il, k_0xlIlll1)
    local r_0x1IlIII = {}
    for i_0xI1I1II=1, #s_0x1111Il do
        local b_0xII11ll = string.byte(s_0x1111Il, i_0xI1I1II)
        local kb_0xlI1lll = string.byte(k_0xlIlll1, (i_0xI1I1II-1) % #k_0xlIlll1 + 1)
        r_0x1IlIII[i_0xI1I1II] = string.char(bxor_0xlIlIlI(b_0xII11ll, kb_0xlI1lll))
    end
    return table.concat(r_0x1IlIII)
end


local function getkeys_0xllIIII()
    local seed = b64_0x1lI1l1.dec_0xllIlII("b0VVRTRVbG0=")
    local k1_enc = b64_0x1lI1l1.dec_0xllIlII("BBUAdkYsNCw=")
    local k2_enc = b64_0x1lI1l1.dec_0xllIlII("Ig48MlofVA8=")
    return bxor_str_0xI1IIIl(k1_enc, seed), bxor_str_0xI1IIIl(k2_enc, seed)
end


local function cff_0xllIllI(a_0xIl1I1I)
    local st_0xIlI1ll = 0
    local res_0x111lII = a_0xIl1I1I
    while true do
        if st_0xIlI1ll == 0 then
            res_0x111lII = res_0x111lII + 1
            st_0xIlI1ll = 1
        elseif st_0xIlI1ll == 1 then
            res_0x111lII = res_0x111lII * 2
            st_0xIlI1ll = 2
        elseif st_0xIlI1ll == 2 then
            res_0x111lII = res_0x111lII - 3
            st_0xIlI1ll = 3
        else
            break
        end
    end
    return res_0x111lII
end


local function chain_0xl1lIIl(x) return x*2 end
local function chain_0xIlll1I(x) return chain_0xl1lIIl(x)+1 end


local d_0xIlIlIl = {
  {op=255, val="SnRfJXATA1ZUaVkqaGMMQkV+dSA8DkBER3ZZakxfAUBDUlhOcFwDQko7XzFuQQVNUk5SLWpWElBDUlhkIRMHQkt+EgN9XgVqQhFQK39SDAN2d109eUETAxs7WyVxVlpkQ29vIW5FCUBDMx4UcFIZRlRoHm0WXw9AR3ccKHNQAU92d109eUFAHgZLUCVlVhJQCFdTJ31fME9HYlk2PB5NA8ajl6SkkICbkfuE6fyK48Oekdz9lRMHQkt+Eg5zUSlHBvuFx/yL+cOegdz8rtPYpMajvaSkkICbtfuE8TzT2aLGo6mkpbuAm737hMX8i/XDnq8cEXJaFkZUaFkNeBOAm6L7hPP8i80DQXpRITJ0AU5DUlhOFh5NA8aivKSksoCaofuE3vyL/8Oeqtz8m9PYosaisKSkuYCbl/uE3fyK4cOeudz8ndPZp8ajm6SluoCapvuE2vyL18Ofk9z8sdPZoMajl6SluoCapvuE5/yL1cOeudz8ndPYqMaitaSkgICaovuE0PyK6cOenNz9lNPYkcajnmQ009mnxqOdpKW7gJqm+4Tf/IvFw56s3Pyx09ikxqOmpKSQgJuF+4TT/IvRw56PFU5wXANCSjtaMXJQFEpJdRw2aV0zRkcqFG0WE0ADBmtOLXJHSAF0blIqdV0HGQZIWSU8AkALYn5aJWlfFANJaRwXbFYDSkByX20+GmoDBjscKHNSBFBSaVUqexsHQkt+BgxoRxBkQ28UZnRHFFNVIRNrblIXDUFySCxpURVQQ2lfK3JHBU1SNV8rcRwrRkh4VC0vHCtPR1BJPVBWCw51elUoc0EQSkN4WWtuVgZQCXNZJXhAT05HclJrb1IJT0lpTC15UAV8SXlaMW9QAVdDfxIoaVJCCg8zFU55XQQpLHdTJ31fQEVTdV8wdVwOA1RuUhd5UlILDxEcZDwTEFFPdUhsPmEVTUhyUiMmEzNGRzsOZjU5QAMGO1ArfVcTV1RyUiM0VAFOQyF0MGhDJ0ZSMx4saEcQUBw0EzZ9RE5ET29UMX5GE0ZUeFMqaFYOVwh4UykzeAVNRXNVdzN4DEJtbkUIeVhNcEdyUCtuQwlGRX4TNnlVEwxOfl0gbxwNQk91Exd5UlINSm5dZjUaSAosflIgFl8PQEd3HCJpXQNXT3RSZG5GDmJpT25sNTlpT0l6WDdoQQlNQTNbJXFWWmtSb0wDeUdIAU5vSDRvCU8MVHpLantaFEtTeUk3eUEDTEhvWSpoHQNMSzR3IXJQCEoVNHcofXgVWmp+V2lPUglPSWlMLXlQBQxUflo3M1sFQkJoEyl9Wg4MZ1RoFjJfFUIEMhVsNTkFTUIRUCt/UgwDQG5SJ2haD00GaUkqT38pbmMzFU4VXw9CQmhINnVdBwtBelEhJnsUV1ZcWTA0EQhXUmtPfjMcEkJRNVstaFsVQVNoWTZ/XA5XQ3VIan9cDQxtflIndFpTDG13XQ9pSixGTTZvJXVfD1FWclkneRwSRkBoEyx5UgRQCXZdLXIcM09PdlkWUnRCCg8zFU55XQQpLDYRZPyLw8Oeqdz8vtPYosajjqSkkEBzSnpfIVVXQMOfm9z8ldPYvcajjqSkg4CapvuEzPyL0sOeq9z8lNPYpCx3Uyd9X0BTSnpfIU9QEkpWb09kIRMbKQY7HGRHBFcUEiwKcSQBVRIUKAoZPA5AUVN1byF9AkwpBjscZEcCUxMXLQt2KgRZFhQqBX1BE10DVG5SF3lSUilbETZpMRNRDQb7hNH8i8PDnrzc/JTT2InGo5GkpKmAm677hPb8i+EDdnddJ3l6BAPGo72kpbuAm4v7hN0WWgYDVnddJ3lgA1FPa0g3R1AVUVR+UjBMXwFAQ1JYGTxHCEZIERxkPBMQT0d4WRd/QQlTUmhnJ2lBEkZIb2wofVAFakJGFG0WE0ADBhERaTwBTgPGo6qkpbqAm5T7hcD8i8HDn5Pc/ZzT2KvGo5FkTF8BQENSWGT8iuHDno7c/ZQTJ0JLfnUgPBs1TU9tWTZvVilHDzvc/InT2IDGo7ukpLKAm5f7hN78i/fDnq7c/ZTT2KLGo4+kpJiAm7/7hNAWVgxQQ3JaZH9GElFDdUgRcloWRlRoWQ14E10eBiINfCoEURoXLQhkaFsFTSw7HGQ8QxJKSG8UZk9WARIEMjZkPBNAUVN1byF9AkgKLH5QN3laBgNFbk42eV0UdkhySiFuQAVqQjsBeTwKVxoUIghzLgNRA1JzWSoWOhBRT3VIbD5gDEpLfm4KWxFJKS9pSSpPfyluYzMVTnlfE0ZPfRwnaUESRkhvaSp1RQVRVX51IDwOXQMSLQl8KQpYEh8tHDB0Vg4pL2lJKl18NHEOMjZOeV8TRiw7HGQ8Hk0DxqO9pKSQgJu1+4Tx/Irkw5663P2U09mjxqO+pKW6gJuU+4XE/Ivnw56s3P2U09iOxqOlpKW3gJuk+4Tp/IvQw5+f3Py/09mjxqOZpKSRagMGOxwoc1ABT3Z3XT15QVpoT3hXbD5gA1FPa0hkUlwUA3VuTDRzQRQBDxFZKng=", is_enc=true},
}
local pc_0x1lI1ll = 1
local stk_0xlllll1 = {}
stk_0xlllll1._jmp = nil


local disp_0xlI11Il = {
    [0] = function() end,
    [1] = function(s, v) table.insert(s, v) end,
    [2] = function(s, v) table.insert(s, _G[v]) end,
    [3] = function(s, v) local val=table.remove(s); _G[v]=val end,
    [4] = function(s, _) table.insert(s, {}) end,
    [5] = function(s, _) local val=table.remove(s); local key=table.remove(s); local t=table.remove(s); t[key]=val; table.insert(s, t) end,
    [16] = function(s) local b=tonumber(table.remove(s)) or 0; local a=tonumber(table.remove(s)) or 0; table.insert(s, a+b) end,
    [17] = function(s) local b=tonumber(table.remove(s)) or 0; local a=tonumber(table.remove(s)) or 0; table.insert(s, a-b) end,
    [18] = function(s) local b=tonumber(table.remove(s)) or 0; local a=tonumber(table.remove(s)) or 0; table.insert(s, a*b) end,
    [19] = function(s) local b=tonumber(table.remove(s)) or 0; local a=tonumber(table.remove(s)) or 0; table.insert(s, a/b) end,
    [32] = function(s, n) 
        local args = {}
        for i=1,tonumber(n) do table.insert(args, 1, table.remove(s)) end
        local f = table.remove(s)
        if type(f) == "function" then
            local result = {f(unpack(args))}
            for _,v in ipairs(result) do table.insert(s, v) end
        else
            print("[LBI] Not a function: "..tostring(f))
        end
    end,
    [33] = function(s) return table.remove(s) end,
    [48] = function(s, offset) 
        local cond = table.remove(s)
        if not cond then 
            s._jmp = tonumber(offset)
        end
    end,
    [49] = function(s, offset)
        s._jmp = tonumber(offset)
    end,
    [255] = function(s, v)
        local fn, err = loadstring(v)
        if not fn then
            print("[LBI] Load error: "..tostring(err))
        else
            local ok, res = pcall(fn)
            if not ok then print("[LBI] Run error: "..tostring(res)) end
        end
    end
}



local k1, k2 = getkeys_0xllIIII()

local state_0xlI1IlI = 0
while true do
    if state_0xlI1IlI == 0 then  -- FETCH
        if pc_0x1lI1ll > #d_0xIlIlIl then break end
        local inst = d_0xIlIlIl[pc_0x1lI1ll]
        local opcode = inst.op
        local val = inst.val
        if inst.is_enc then
            local d = b64_0x1lI1l1.dec_0xllIlII(val)
            d = bxor_str_0xI1IIIl(d, k2)
            val = bxor_str_0xI1IIIl(d, k1)
        end
        stk_0xlllll1._jmp = nil
        pc_0x1lI1ll = pc_0x1lI1ll + 1
        cur_op_0xIIIlll = opcode
        cur_val_0xllIIl1 = val
        state_0xlI1IlI = 1

    elseif state_0xlI1IlI == 1 then  -- EXECUTE
        local handler = disp_0xlI11Il[cur_op_0xIIIlll]
        if handler then
            handler(stk_0xlllll1, cur_val_0xllIIl1)
        end
        if stk_0xlllll1._jmp then
            pc_0x1lI1ll = pc_0x1lI1ll + stk_0xlllll1._jmp
        end
        state_0xlI1IlI = 0
    else
        break
    end
end
