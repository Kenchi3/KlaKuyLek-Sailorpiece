-- Ken's Hardened V2 Fix

local b64_0xl11llI = {}
local char_0x11IIl1='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
for i_0xlI1IIl=1,#char_0x11IIl1 do b64_0xl11llI[char_0x11IIl1:sub(i_0xlI1IIl,i_0xlI1IIl)] = i_0xlI1IIl - 1 end

function b64_0xl11llI.dec_0xIIlIlI(d_0xlIlI1l)
    d_0xlIlI1l = string.gsub(d_0xlIlI1l, '[^'..char_0x11IIl1..'=]', '')
    local r_0xIIl1I1 = {}
    for i_0xlI1IIl=1, #d_0xlIlI1l, 4 do
        local c_0x11l1Il = b64_0xl11llI[d_0xlIlI1l:sub(i_0xlI1IIl,i_0xlI1IIl)] or 0
        local c_0xII111I = b64_0xl11llI[d_0xlIlI1l:sub(i_0xlI1IIl+1,i_0xlI1IIl+1)] or 0
        local c_0x1IIlIl, c_0xIlIIII = 0, 0
        local has3 = true
        local has4 = true
        local ch3 = d_0xlIlI1l:sub(i_0xlI1IIl+2,i_0xlI1IIl+2)
        if ch3 == "=" then has3 = false else c_0x1IIlIl = b64_0xl11llI[ch3] or 0 end
        local ch4 = d_0xlIlI1l:sub(i_0xlI1IIl+3,i_0xlI1IIl+3)
        if ch4 == "=" then has4 = false else c_0xIlIIII = b64_0xl11llI[ch4] or 0 end
        local b_0xlIlIlI = c_0x11l1Il * (2^18) + c_0xII111I * (2^12) + c_0x1IIlIl * (2^6) + c_0xIlIIII
        local b_0xIIllll = math.floor(b_0xlIlIlI / (2^16)) % (2^8)
        local b_0xIl1ll1 = math.floor(b_0xlIlIlI / (2^8)) % (2^8)
        local b_0x1IIllI = b_0xlIlIlI % (2^8)
        table.insert(r_0xIIl1I1, string.char(b_0xIIllll))
        if has3 then table.insert(r_0xIIl1I1, string.char(b_0xIl1ll1)) end
        if has4 then table.insert(r_0xIIl1I1, string.char(b_0x1IIllI)) end
    end
    return table.concat(r_0xIIl1I1)
end


local function bxor_0xIllll1(a_0xII1lll,b_0xlII1lI)
    if bit32 then return bit32.bxor(a_0xII1lll,b_0xlII1lI) end
    local r_0xIlIII1 = 0
    for i_0xIIll11 = 0, 7 do
        local x_0xI1Ill1 = a_0xII1lll % 2
        local y_0x11lIl1 = b_0xlII1lI % 2
        if x_0xI1Ill1 ~= y_0x11lIl1 then r_0xIlIII1 = r_0xIlIII1 + (2^i_0xIIll11) end
        a_0xII1lll = math.floor(a_0xII1lll / 2)
        b_0xlII1lI = math.floor(b_0xlII1lI / 2)
    end
    return r_0xIlIII1
end


local function bxor_str_0xlI1Ill(s_0x1IIII1, k_0xlIIl11)
    local r_0xlllIlI = {}
    for i_0xIlIIIl=1, #s_0x1IIII1 do
        local b_0xlI1IIl = string.byte(s_0x1IIII1, i_0xIlIIIl)
        local kb_0xI11III = string.byte(k_0xlIIl11, (i_0xIlIIIl-1) % #k_0xlIIl11 + 1)
        r_0xlllIlI[i_0xIlIIIl] = string.char(bxor_0xIllll1(b_0xlI1IIl, kb_0xI11III))
    end
    return table.concat(r_0xlllIlI)
end


local function getkeys_0xI11IlI()
    local seed = b64_0xl11llI.dec_0xIIlIlI("WUR2TmdkRDg=")
    local k1_enc = b64_0xl11llI.dec_0xIIlIlI("CzQcPVA9KHw=")
    local k2_enc = b64_0xl11llI.dec_0xIIlIlI("bzM5DRVVMU0=")
    return bxor_str_0xlI1Ill(k1_enc, seed), bxor_str_0xlI1Ill(k2_enc, seed)
end


local function cff_0x1IIl1I(a_0xlIllII)
    local st_0xIlI1Il = 0
    local res_0xIlI1ll = a_0xlIllII
    while true do
        if st_0xIlI1Il == 0 then
            res_0xIlI1ll = res_0xIlI1ll + 1
            st_0xIlI1Il = 1
        elseif st_0xIlI1Il == 1 then
            res_0xIlI1ll = res_0xIlI1ll * 2
            st_0xIlI1Il = 2
        elseif st_0xIlI1Il == 2 then
            res_0xIlI1ll = res_0xIlI1ll - 3
            st_0xIlI1Il = 3
        else
            break
        end
    end
    return res_0xIlI1ll
end


local function chain_0xlIII1l(x) return x*2 end
local function chain_0x1IIllI(x) return chain_0xlIII1l(x)+1 end


local d_0x11Illl = {
  {op=255, val="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", is_enc=true},
}
local pc_0xlI1IlI = 1
local stk_0xIIIIll = {}
stk_0xIIIIll._jmp = nil


local disp_0xIlI1Il = {
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



local k1, k2 = getkeys_0xI11IlI()

local state_0xlI1III = 0
while true do
    if state_0xlI1III == 0 then  -- FETCH
        if pc_0xlI1IlI > #d_0x11Illl then break end
        local inst = d_0x11Illl[pc_0xlI1IlI]
        local opcode = inst.op
        local val = inst.val
        if inst.is_enc then
            local d = b64_0xl11llI.dec_0xIIlIlI(val)
            d = bxor_str_0xlI1Ill(d, k2)
            val = bxor_str_0xlI1Ill(d, k1)
        end
        stk_0xIIIIll._jmp = nil
        pc_0xlI1IlI = pc_0xlI1IlI + 1
        cur_op_0x1lI1II = opcode
        cur_val_0xIIIIlI = val
        state_0xlI1III = 1

    elseif state_0xlI1III == 1 then  -- EXECUTE
        local handler = disp_0xIlI1Il[cur_op_0x1lI1II]
        if handler then
            handler(stk_0xIIIIll, cur_val_0xIIIIlI)
        end
        if stk_0xIIIIll._jmp then
            pc_0xlI1IlI = pc_0xlI1IlI + stk_0xIIIIll._jmp
        end
        state_0xlI1III = 0
    else
        break
    end
end
