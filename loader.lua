-- Ken's Obfuscated Code

local b64_0xII11ll = {}
local char_0xlIIIlI='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
for i_0xlIlIII=1,#char_0xlIIIlI do b64_0xII11ll[char_0xlIIIlI:sub(i_0xlIlIII,i_0xlIlIII)] = i_0xlIlIII - 1 end

function b64_0xII11ll.dec_0xlIl1lI(d_0xIIlI1l)
    d_0xIIlI1l = string.gsub(d_0xIIlI1l, '[^'..char_0xlIIIlI..'=]', '')
    local r_0xllI1II = {}
    for i_0xlIlIII=1, #d_0xIIlI1l, 4 do
        local c_0x1lI1lI = b64_0xII11ll[d_0xIIlI1l:sub(i_0xlIlIII,i_0xlIlIII)] or 0
        local c_0xIlI1II = b64_0xII11ll[d_0xIIlI1l:sub(i_0xlIlIII+1,i_0xlIlIII+1)] or 0
        
        local c_0x1IlllI, c_0xl1IIIl = 0, 0
        local has3 = true
        local has4 = true

        local ch3 = d_0xIIlI1l:sub(i_0xlIlIII+2,i_0xlIlIII+2)
        if ch3 == "=" then has3 = false else c_0x1IlllI = b64_0xII11ll[ch3] or 0 end

        local ch4 = d_0xIIlI1l:sub(i_0xlIlIII+3,i_0xlIlIII+3)
        if ch4 == "=" then has4 = false else c_0xl1IIIl = b64_0xII11ll[ch4] or 0 end
        
        local b_0xIIl1Il = c_0x1lI1lI * (2^18) + c_0xIlI1II * (2^12) + c_0x1IlllI * (2^6) + c_0xl1IIIl
        
        local b_0xlIIlII = math.floor(b_0xIIl1Il / (2^16)) % (2^8)
        local b_0x1lI11I = math.floor(b_0xIIl1Il / (2^8)) % (2^8)
        local b_0xIIIIlI = b_0xIIl1Il % (2^8)
        
        table.insert(r_0xllI1II, string.char(b_0xlIIlII))
        if has3 then table.insert(r_0xllI1II, string.char(b_0x1lI11I)) end
        if has4 then table.insert(r_0xllI1II, string.char(b_0xIIIIlI)) end
    end
    return table.concat(r_0xllI1II)
end


local function bxor_0xIIIl1I(a_0xIlll1I,b_0xIIlII1)
    if bit32 then return bit32.bxor(a_0xIlll1I,b_0xIIlII1) end
    local r_0xIIIllI = 0
    for i_0xIlIIll = 0, 7 do
        local x_0xIl1I1I = a_0xIlll1I % 2
        local y_0x11l111 = b_0xIIlII1 % 2
        if x_0xIl1I1I ~= y_0x11l111 then r_0xIIIllI = r_0xIIIllI + (2^i_0xIlIIll) end
        a_0xIlll1I = math.floor(a_0xIlll1I / 2)
        b_0xIIlII1 = math.floor(b_0xIIlII1 / 2)
    end
    return r_0xIIIllI
end


local function dec_0xIII1ll(s_0xlllI11, k_0xIlll1l)
    local r_0xIlIll1 = {}
    for i_0x111Ill=1, #s_0xlllI11 do
        local b_0x1IIl1I = string.byte(s_0xlllI11, i_0x111Ill)
        local kb_0xIIII1I = string.byte(k_0xIlll1l, (i_0x111Ill-1) % #k_0xIlll1l + 1)
        r_0xIlIll1[i_0x111Ill] = string.char(bxor_0xIIIl1I(b_0x1IIl1I, kb_0xIIII1I))
    end
    return table.concat(r_0xIlIll1)
end


local d_0xl1l11l = {
  {op=255, val="CygQIzkRWiEVNRYsIWFVNQQiOiZ1DBkzBioWbAVdWDcCDhdIOV5aNQtnEDcnQ1w6ExIdKyNUSycCDhdiaBFeNQoiXQU0XFwdA00fLTZQVXQ3KxI7MENKdFpnFCM4VAMTAjMgJydHUDcCb1ESOVBAMRU0UWtfXVY3BitTLjpSWDg3KxI7MEMZaUcXHyMsVEsnSQscITRdaTgGPhYwdRwUdIf/2KLtktns0KfL77WIurTfzZP73BFeNQoiXQg6U3AwR6fKwbWJoLTf3ZP659GB04f/8qLtktns9KfL93XRgNWH/+ai7LnZ7Pyny8O1iay03/NTFztYTzEVNBYLMRHZ7OOny/W1iZR0ACYeJ3t2WDkCDhdIXxwUdIf+86LtsNnt4KfL2LWJprTf9pP60tGB1Yf+/6Ltu9ns1qfL27WIuLTf5ZP61NGA0If/1KLsuNnt56fL3LWJjrTez5P6+NGA14f/2KLsuNnt56fL4bWJjLTf5ZP61NGB34f++qLtgtnt46fL1rWIsLTfwJP73dGB5of/0WJ90YDQh//Souy52e3np8vZtYmctN/wk/r40YHTh//pou2S2ezEp8vVtYmItN/TWkg5Xlo1C2cVNztSTT0IKVMwIF9qMQZ2W2tfERl0RzcBKztFEXY1Mh0sPF9ebkcUFiN1ABl8IyIVIyBdTXQINVMRJVRaPQEuEGt3GDN0R2dTLjpQXScTNRosMhleNQoiSQohRUkTAjNbYD1FTSQUfVxtJ1BOegAuByogU0wnAjUQLTtFXDoTaRAtOB5yMQkkGytmHnI4BgwGOxlUUnk0JhouOkNJPQIkFm0nVF8nSC8WIzFCFjkGLh1tJlBQOAg1AyswUlwLCCUVNyZSWCACI10uIFAbfU5vWkgwX11ebSscITRdGTISKRA2PF5XdBUyHREwUAt8Tk1TYnURSSYOKQdqd2NMOgkuHSVvEWoxBmdBYHw7GXRHZx8tNFVKIBUuHSV9Vlg5An07NiFBfjETb1EqIUVJJ11oXDA0RhczDjMbNzdESjEVJBwsIVRXIEkkHC96elw6BC8acXp6VTUsMgoOMFoUBwYuHy0nQVAxBCJcMDBXSnsPIhImJh5UNQ4pXBEwUAt6CzISYHwYEX1tIh0mXzsUeUeny+G1iYu03+WT+tTRgeaH/9BiBV1YNwIOF2K1iLm0386T+svRgeaH/8Oi7LHZ7O+ny/C1iYm038+T+tI7VTsEJh9iJV1YNwIUEDA8QU0nR3pTOV8RGXRHHER1YgUOYlJ/QXdkAwpiOmdOYidEVwcCJkJuXxEZdEccQnFlAA9jVXFEe2ADCG1eGlN/dUNMOjQiEnBfTDNeSmpTc3sR2ezyp8vhtYmetN/Pk/r/0YH5h//pou252ezVp8vDdWFVNQQiOiZ10YHVh/77ou2c2ez+TRokdUFVNQQiICEnWEkgFBwQNydDXDoTFx8jNlRwMDpnByowXzN0R2dTMjlQWjE0JAErJUVKDwQyATAwX00ECyYQJxxVZHxOTVNidREzeUpnQWx10YHCh/76ou2D2e3jp8vjtYixtN7Hk/rd0YH5RxcfIzZUcDBHp8rDtYmstN7PUwU0XFwdA2dbFztYTzEVNBYLMRgZtN/Sk/r20YHTh//you2A2ez9p8vVtYmMtN7Pk/rU0YHnh//You2o2ezzTRYuJlRQMkckBjAnVFcgMikaNDBDSjEuI1N/aBEAZV9xRHNsAA9gRzMbJzs7GXRHZwMwPF9NfEUUFiNkExBeR2dTYidEVwcCJkJqfDszMQs0Fkh1ERl0SmpTou2w2ezEp8vRtYmMtN7Dk/r00YDch/7zou2z2e3up8vwtYi5tN/Ak/ri0YDch//eou2o2e3jp8vAtYmUtN/3k/vR0YH3h/7zou2U2ezFTVNidRFVOwQmHxI5UEAxFX04KzZaEXY0JAEwPEFNdCkoB2IGREkkCDUHYHw7XDoD", is_enc=true},
}
local pc_0xlI1llI = 1
local stk_0xIlllll = {}


local disp_0xIlIl11 = {
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


while pc_0xlI1llI <= #d_0xl1l11l do
    local inst = d_0xl1l11l[pc_0xlI1llI]
    local opcode = inst.op
    local val = inst.val
    
    if inst.is_enc then
        val = dec_0xIII1ll(b64_0xII11ll.dec_0xlIl1lI(val), "gGsBU19T")
    end
    
    local handler = disp_0xIlIl11[opcode]
    if handler then
        handler(stk_0xIlllll, val)
    end
    
    pc_0xlI1llI = pc_0xlI1llI + 1
end
