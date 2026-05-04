-- Ken's Hardened V2 Fix

local b64_0xlI1III = {}
local char_0xlllIlI='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
for i_0xIIlIll=1,#char_0xlllIlI do b64_0xlI1III[char_0xlllIlI:sub(i_0xIIlIll,i_0xIIlIll)] = i_0xIIlIll - 1 end

function b64_0xlI1III.dec_0xII1lII(d_0xlIllI1)
    d_0xlIllI1 = string.gsub(d_0xlIllI1, '[^'..char_0xlllIlI..'=]', '')
    local r_0xlIllIl = {}
    for i_0xIIlIll=1, #d_0xlIllI1, 4 do
        local c_0xIllII1 = b64_0xlI1III[d_0xlIllI1:sub(i_0xIIlIll,i_0xIIlIll)] or 0
        local c_0xlll1lI = b64_0xlI1III[d_0xlIllI1:sub(i_0xIIlIll+1,i_0xIIlIll+1)] or 0
        local c_0xIIll1I, c_0xlIIll1 = 0, 0
        local has3 = true
        local has4 = true
        local ch3 = d_0xlIllI1:sub(i_0xIIlIll+2,i_0xIIlIll+2)
        if ch3 == "=" then has3 = false else c_0xIIll1I = b64_0xlI1III[ch3] or 0 end
        local ch4 = d_0xlIllI1:sub(i_0xIIlIll+3,i_0xIIlIll+3)
        if ch4 == "=" then has4 = false else c_0xlIIll1 = b64_0xlI1III[ch4] or 0 end
        local b_0xIIllIl = c_0xIllII1 * (2^18) + c_0xlll1lI * (2^12) + c_0xIIll1I * (2^6) + c_0xlIIll1
        local b_0x111lI1 = math.floor(b_0xIIllIl / (2^16)) % (2^8)
        local b_0xlIII1I = math.floor(b_0xIIllIl / (2^8)) % (2^8)
        local b_0xllIlll = b_0xIIllIl % (2^8)
        table.insert(r_0xlIllIl, string.char(b_0x111lI1))
        if has3 then table.insert(r_0xlIllIl, string.char(b_0xlIII1I)) end
        if has4 then table.insert(r_0xlIllIl, string.char(b_0xllIlll)) end
    end
    return table.concat(r_0xlIllIl)
end


local function bxor_0xlIIlIl(a_0xlIlIII,b_0xIlI1lI)
    if bit32 then return bit32.bxor(a_0xlIlIII,b_0xIlI1lI) end
    local r_0xlI1lII = 0
    for i_0xl1IIIl = 0, 7 do
        local x_0xIll1ll = a_0xlIlIII % 2
        local y_0xI1lIll = b_0xIlI1lI % 2
        if x_0xIll1ll ~= y_0xI1lIll then r_0xlI1lII = r_0xlI1lII + (2^i_0xl1IIIl) end
        a_0xlIlIII = math.floor(a_0xlIlIII / 2)
        b_0xIlI1lI = math.floor(b_0xIlI1lI / 2)
    end
    return r_0xlI1lII
end


local function bxor_str_0xlIlIII(s_0xlIll1l, k_0xlIlIIl)
    local r_0x11lIIl = {}
    for i_0xIIIllI=1, #s_0xlIll1l do
        local b_0xIIIIll = string.byte(s_0xlIll1l, i_0xIIIllI)
        local kb_0x11Illl = string.byte(k_0xlIlIIl, (i_0xIIIllI-1) % #k_0xlIlIIl + 1)
        r_0x11lIIl[i_0xIIIllI] = string.char(bxor_0xlIIlIl(b_0xIIIIll, kb_0x11Illl))
    end
    return table.concat(r_0x11lIIl)
end


local function getkeys_0xlIllII()
    local seed = b64_0xlI1III.dec_0xII1lII("VzdrZUtxYWY=")
    local k1_enc = b64_0xlI1III.dec_0xII1lII("MU0fDxMEVRQ=")
    local k2_enc = b64_0xlI1III.dec_0xII1lII("GkUCEjIWGzQ=")
    return bxor_str_0xlIlIII(k1_enc, seed), bxor_str_0xlIlIII(k2_enc, seed)
end


local function cff_0xlI1IIl(a_0xIIIlll)
    local st_0x1llIII = 0
    local res_0x1Ill1l = a_0xIIIlll
    while true do
        if st_0x1llIII == 0 then
            res_0x1Ill1l = res_0x1Ill1l + 1
            st_0x1llIII = 1
        elseif st_0x1llIII == 1 then
            res_0x1Ill1l = res_0x1Ill1l * 2
            st_0x1llIII = 2
        elseif st_0x1llIII == 2 then
            res_0x1Ill1l = res_0x1Ill1l - 3
            st_0x1llIII = 3
        else
            break
        end
    end
    return res_0x1Ill1l
end


local function chain_0x1ll1Il(x) return x*2 end
local function chain_0xlIl1ll(x) return chain_0x1ll1Il(x)+1 end


local d_0xlllll1 = {
  {op=255, val="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", is_enc=true},
}
local pc_0xlIl1ll = 1
local stk_0xlIlIIl = {}
stk_0xlIlIIl._jmp = nil


local disp_0xIl1lII = {
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



local k1, k2 = getkeys_0xlIllII()

local state_0x11llII = 0
while true do
    if state_0x11llII == 0 then  -- FETCH
        if pc_0xlIl1ll > #d_0xlllll1 then break end
        local inst = d_0xlllll1[pc_0xlIl1ll]
        local opcode = inst.op
        local val = inst.val
        if inst.is_enc then
            local d = b64_0xlI1III.dec_0xII1lII(val)
            d = bxor_str_0xlIlIII(d, k2)
            val = bxor_str_0xlIlIII(d, k1)
        end
        stk_0xlIlIIl._jmp = nil
        pc_0xlIl1ll = pc_0xlIl1ll + 1
        cur_op_0xll1IlI = opcode
        cur_val_0xlIl11I = val
        state_0x11llII = 1

    elseif state_0x11llII == 1 then  -- EXECUTE
        local handler = disp_0xIl1lII[cur_op_0xll1IlI]
        if handler then
            handler(stk_0xlIlIIl, cur_val_0xlIl11I)
        end
        if stk_0xlIlIIl._jmp then
            pc_0xlIl1ll = pc_0xlIl1ll + stk_0xlIlIIl._jmp
        end
        state_0x11llII = 0
    else
        break
    end
end
