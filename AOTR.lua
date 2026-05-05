-- Ken's Hardened V2 Fix

local b64_0xIlI1ll = {}
local char_0xI1ll1I='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
for i_0xll1lIl=1,#char_0xI1ll1I do b64_0xIlI1ll[char_0xI1ll1I:sub(i_0xll1lIl,i_0xll1lIl)] = i_0xll1lIl - 1 end

function b64_0xIlI1ll.dec_0xll1llI(d_0xIlIIll)
    d_0xIlIIll = string.gsub(d_0xIlIIll, '[^'..char_0xI1ll1I..'=]', '')
    local r_0xl1l1I1 = {}
    for i_0xll1lIl=1, #d_0xIlIIll, 4 do
        local c_0x11II1l = b64_0xIlI1ll[d_0xIlIIll:sub(i_0xll1lIl,i_0xll1lIl)] or 0
        local c_0x1IllII = b64_0xIlI1ll[d_0xIlIIll:sub(i_0xll1lIl+1,i_0xll1lIl+1)] or 0
        local c_0xIIll1I, c_0x11llIl = 0, 0
        local has3 = true
        local has4 = true
        local ch3 = d_0xIlIIll:sub(i_0xll1lIl+2,i_0xll1lIl+2)
        if ch3 == "=" then has3 = false else c_0xIIll1I = b64_0xIlI1ll[ch3] or 0 end
        local ch4 = d_0xIlIIll:sub(i_0xll1lIl+3,i_0xll1lIl+3)
        if ch4 == "=" then has4 = false else c_0x11llIl = b64_0xIlI1ll[ch4] or 0 end
        local b_0xI11lll = c_0x11II1l * (2^18) + c_0x1IllII * (2^12) + c_0xIIll1I * (2^6) + c_0x11llIl
        local b_0x1lI1II = math.floor(b_0xI11lll / (2^16)) % (2^8)
        local b_0xlII1II = math.floor(b_0xI11lll / (2^8)) % (2^8)
        local b_0xI1II1I = b_0xI11lll % (2^8)
        table.insert(r_0xl1l1I1, string.char(b_0x1lI1II))
        if has3 then table.insert(r_0xl1l1I1, string.char(b_0xlII1II)) end
        if has4 then table.insert(r_0xl1l1I1, string.char(b_0xI1II1I)) end
    end
    return table.concat(r_0xl1l1I1)
end


local function bxor_0xI1I1I1(a_0xIllIlI,b_0xl11II1)
    if bit32 then return bit32.bxor(a_0xIllIlI,b_0xl11II1) end
    local r_0xI1IIIl = 0
    for i_0xI1IlI1 = 0, 7 do
        local x_0xl11Ill = a_0xIllIlI % 2
        local y_0xllllII = b_0xl11II1 % 2
        if x_0xl11Ill ~= y_0xllllII then r_0xI1IIIl = r_0xI1IIIl + (2^i_0xI1IlI1) end
        a_0xIllIlI = math.floor(a_0xIllIlI / 2)
        b_0xl11II1 = math.floor(b_0xl11II1 / 2)
    end
    return r_0xI1IIIl
end


local function bxor_str_0xIllIl1(s_0xIIIIlI, k_0xlIllll)
    local r_0xIlI1Il = {}
    for i_0xIIIl1I=1, #s_0xIIIIlI do
        local b_0x11lllI = string.byte(s_0xIIIIlI, i_0xIIIl1I)
        local kb_0xlI11l1 = string.byte(k_0xlIllll, (i_0xIIIl1I-1) % #k_0xlIllll + 1)
        r_0xIlI1Il[i_0xIIIl1I] = string.char(bxor_0xI1I1I1(b_0x11lllI, kb_0xlI11l1))
    end
    return table.concat(r_0xIlI1Il)
end


local function getkeys_0x1IlIlI()
    local seed = b64_0xIlI1ll.dec_0xll1llI("M3FrdGt3eFU=")
    local k1_enc = b64_0xIlI1ll.dec_0xll1llI("eT9aRwYVCy0=")
    local k2_enc = b64_0xIlI1ll.dec_0xll1llI("ajAPGSodGgI=")
    return bxor_str_0xIllIl1(k1_enc, seed), bxor_str_0xIllIl1(k2_enc, seed)
end


local function cff_0xIII1l1(a_0xII1II1)
    local st_0xlIIl1I = 0
    local res_0xIllIll = a_0xII1II1
    while true do
        if st_0xlIIl1I == 0 then
            res_0xIllIll = res_0xIllIll + 1
            st_0xlIIl1I = 1
        elseif st_0xlIIl1I == 1 then
            res_0xIllIll = res_0xIllIll * 2
            st_0xlIIl1I = 2
        elseif st_0xlIIl1I == 2 then
            res_0xIllIll = res_0xIllIll - 3
            st_0xlIIl1I = 3
        else
            break
        end
    end
    return res_0xIllIll
end


local function chain_0xIllIIl(x) return x*2 end
local function chain_0xIIII11(x) return chain_0xIllIIl(x)+1 end


local d_0xl1IIlI = {
  {op=255, val="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", is_enc=true},
}
local pc_0xllIlII = 1
local stk_0xlIl1ll = {}
stk_0xlIl1ll._jmp = nil


local disp_0x1I1l1l = {
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



local k1, k2 = getkeys_0x1IlIlI()

local state_0x1I1I1I = 0
while true do
    if state_0x1I1I1I == 0 then  -- FETCH
        if pc_0xllIlII > #d_0xl1IIlI then break end
        local inst = d_0xl1IIlI[pc_0xllIlII]
        local opcode = inst.op
        local val = inst.val
        if inst.is_enc then
            local d = b64_0xIlI1ll.dec_0xll1llI(val)
            d = bxor_str_0xIllIl1(d, k2)
            val = bxor_str_0xIllIl1(d, k1)
        end
        stk_0xlIl1ll._jmp = nil
        pc_0xllIlII = pc_0xllIlII + 1
        cur_op_0xl1ll1I = opcode
        cur_val_0xIllllI = val
        state_0x1I1I1I = 1

    elseif state_0x1I1I1I == 1 then  -- EXECUTE
        local handler = disp_0x1I1l1l[cur_op_0xl1ll1I]
        if handler then
            handler(stk_0xlIl1ll, cur_val_0xIllllI)
        end
        if stk_0xlIl1ll._jmp then
            pc_0xllIlII = pc_0xllIlII + stk_0xlIl1ll._jmp
        end
        state_0x1I1I1I = 0
    else
        break
    end
end
