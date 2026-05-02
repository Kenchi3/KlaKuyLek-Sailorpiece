-- Ken's Hardened V2 Fix

local b64_0xI1Illl = {}
local char_0x11I1II='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
for i_0xlIl1ll=1,#char_0x11I1II do b64_0xI1Illl[char_0x11I1II:sub(i_0xlIl1ll,i_0xlIl1ll)] = i_0xlIl1ll - 1 end

function b64_0xI1Illl.dec_0xIlllll(d_0xlllIIl)
    d_0xlllIIl = string.gsub(d_0xlllIIl, '[^'..char_0x11I1II..'=]', '')
    local r_0xIIlIl1 = {}
    for i_0xlIl1ll=1, #d_0xlllIIl, 4 do
        local c_0xII1Ill = b64_0xI1Illl[d_0xlllIIl:sub(i_0xlIl1ll,i_0xlIl1ll)] or 0
        local c_0xIllIll = b64_0xI1Illl[d_0xlllIIl:sub(i_0xlIl1ll+1,i_0xlIl1ll+1)] or 0
        local c_0xIlIllI, c_0xlIIlll = 0, 0
        local has3 = true
        local has4 = true
        local ch3 = d_0xlllIIl:sub(i_0xlIl1ll+2,i_0xlIl1ll+2)
        if ch3 == "=" then has3 = false else c_0xIlIllI = b64_0xI1Illl[ch3] or 0 end
        local ch4 = d_0xlllIIl:sub(i_0xlIl1ll+3,i_0xlIl1ll+3)
        if ch4 == "=" then has4 = false else c_0xlIIlll = b64_0xI1Illl[ch4] or 0 end
        local b_0xIlIlll = c_0xII1Ill * (2^18) + c_0xIllIll * (2^12) + c_0xIlIllI * (2^6) + c_0xlIIlll
        local b_0xII1Ill = math.floor(b_0xIlIlll / (2^16)) % (2^8)
        local b_0xl11I1I = math.floor(b_0xIlIlll / (2^8)) % (2^8)
        local b_0xlIllll = b_0xIlIlll % (2^8)
        table.insert(r_0xIIlIl1, string.char(b_0xII1Ill))
        if has3 then table.insert(r_0xIIlIl1, string.char(b_0xl11I1I)) end
        if has4 then table.insert(r_0xIIlIl1, string.char(b_0xlIllll)) end
    end
    return table.concat(r_0xIIlIl1)
end


local function bxor_0xIIIl1l(a_0x111I1I,b_0xIIl1I1)
    if bit32 then return bit32.bxor(a_0x111I1I,b_0xIIl1I1) end
    local r_0xIlllll = 0
    for i_0xIlllIl = 0, 7 do
        local x_0xIllIIl = a_0x111I1I % 2
        local y_0x1l1lII = b_0xIIl1I1 % 2
        if x_0xIllIIl ~= y_0x1l1lII then r_0xIlllll = r_0xIlllll + (2^i_0xIlllIl) end
        a_0x111I1I = math.floor(a_0x111I1I / 2)
        b_0xIIl1I1 = math.floor(b_0xIIl1I1 / 2)
    end
    return r_0xIlllll
end


local function bxor_str_0xlI1IlI(s_0xI1lIll, k_0xIIll11)
    local r_0xllIIIl = {}
    for i_0x11Ill1=1, #s_0xI1lIll do
        local b_0xI1llll = string.byte(s_0xI1lIll, i_0x11Ill1)
        local kb_0xllIl11 = string.byte(k_0xIIll11, (i_0x11Ill1-1) % #k_0xIIll11 + 1)
        r_0xllIIIl[i_0x11Ill1] = string.char(bxor_0xIIIl1l(b_0xI1llll, kb_0xllIl11))
    end
    return table.concat(r_0xllIIIl)
end


local function getkeys_0xI1IIlI()
    local seed = b64_0xI1Illl.dec_0xIlllll("U2FEV2FwMW4=")
    local k1_enc = b64_0xI1Illl.dec_0xIlllll("NwIHOAIXdj0=")
    local k2_enc = b64_0xI1Illl.dec_0xIlllll("IhcRBVIUASc=")
    return bxor_str_0xlI1IlI(k1_enc, seed), bxor_str_0xlI1IlI(k2_enc, seed)
end


local function cff_0xlIIll1(a_0x1ll1Il)
    local st_0x1IlIII = 0
    local res_0xIIllII = a_0x1ll1Il
    while true do
        if st_0x1IlIII == 0 then
            res_0xIIllII = res_0xIIllII + 1
            st_0x1IlIII = 1
        elseif st_0x1IlIII == 1 then
            res_0xIIllII = res_0xIIllII * 2
            st_0x1IlIII = 2
        elseif st_0x1IlIII == 2 then
            res_0xIIllII = res_0xIIllII - 3
            st_0x1IlIII = 3
        else
            break
        end
    end
    return res_0xIIllII
end


local function chain_0xlIlIl1(x) return x*2 end
local function chain_0xIIllI1(x) return chain_0xlIlIl1(x)+1 end


local d_0x1IlIIl = {
  {op=255, val="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", is_enc=true},
}
local pc_0xIIIlll = 1
local stk_0xl1lI1l = {}
stk_0xl1lI1l._jmp = nil


local disp_0xI1l11l = {
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



local k1, k2 = getkeys_0xI1IIlI()

local state_0xI1ll1l = 0
while true do
    if state_0xI1ll1l == 0 then  -- FETCH
        if pc_0xIIIlll > #d_0x1IlIIl then break end
        local inst = d_0x1IlIIl[pc_0xIIIlll]
        local opcode = inst.op
        local val = inst.val
        if inst.is_enc then
            local d = b64_0xI1Illl.dec_0xIlllll(val)
            d = bxor_str_0xlI1IlI(d, k2)
            val = bxor_str_0xlI1IlI(d, k1)
        end
        stk_0xl1lI1l._jmp = nil
        pc_0xIIIlll = pc_0xIIIlll + 1
        cur_op_0xIllIll = opcode
        cur_val_0xI1lII1 = val
        state_0xI1ll1l = 1

    elseif state_0xI1ll1l == 1 then  -- EXECUTE
        local handler = disp_0xI1l11l[cur_op_0xIllIll]
        if handler then
            handler(stk_0xl1lI1l, cur_val_0xI1lII1)
        end
        if stk_0xl1lI1l._jmp then
            pc_0xIIIlll = pc_0xIIIlll + stk_0xl1lI1l._jmp
        end
        state_0xI1ll1l = 0
    else
        break
    end
end
