--[[
    AutoLooter Utilities
    Shared helpers: color constants, table operations, item ID parsing, and rarity formatting.
]]

local ADDON_NAME, PRIVATE_TABLE = ...

-- Upvalue frequently-used globals
local type = type
local pairs = pairs
local tonumber = tonumber
local string_match = string.match
local string_gsub = string.gsub
local select = select

local L = LibStub("AceLocale-3.0"):GetLocale("AutoLooter")

---@class Util
local Util = PRIVATE_TABLE.Util

-- Normalize GetItemQualityColor across versions (Retail/TWW returns a Color object via C_Item)
local function GetQualityHexColor(rarity)
    if C_Item and C_Item.GetItemQualityColor then
        local color = C_Item.GetItemQualityColor(rarity)
        if type(color) == "table" then
            -- Retail/TWW returns a ColorMixin
            if color.colorCode then
                return color.colorCode -- already without leading |c
            elseif color.GenerateHexColor then
                -- GenerateHexColor includes alpha; returns e.g. "ffa335ee"
                return color:GenerateHexColor()
            end
        end
    end
    -- Legacy API: returns r,g,b,hex
    local _, _, _, hex = _G.GetItemQualityColor(rarity)
    return hex
end

---@class Color
local Color = PRIVATE_TABLE.Color
Color.BLUE = "|cFF29E0E7"
Color.DARK_BLUE = "|cFF7878ff"
Color.PURPLE = "|cFFB737E7"
Color.WHITE = "|cFFFFFFFF"
Color.RED = "|cFFDC2924"
Color.YELLOW = "|cFFFFF244"
Color.GREEN = "|cFF3DDC53"
Color.PINK = "|cFFDC5272"
Color.ORANGE = "|cFFE77324"

Color.GOLD = "|cFFFFFF00"
Color.SILVER = "|cFFCCCCCC"
Color.COPPER = "|cFFFF6600"

function Util.orderedPairs(t, sortFunction, filter, resetMessage)
    local sortTable = {}

    local iNext, iTable
    if type(t) == "function" then
        iNext, iTable = t()
    else
        iNext, iTable = pairs(t)
    end

    for key, value in iNext, iTable do
        if not filter or filter(key, value) then
            table.insert(sortTable, key)
        end
    end
    table.sort(sortTable, sortFunction)

    local i = 0
    local iterator = function(k)
        if resetMessage and k == resetMessage then
            i = 0
            return
        end
        i = i + 1
        if sortTable[i] == nil then
            return nil
        else
            return sortTable[i], iTable[sortTable[i]]
        end
    end

    return iterator
end

function Util.CountTable(t)
    if not t then return 0 end

    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

function Util.CountChecked(t)
    local n = 0
    for k, v in pairs(t) do
        if v then n = n + 1 end
    end

    return n
end

function Util.GetColorForRarity(rarity)
    local hex = GetQualityHexColor(rarity)
    if hex then return "|c" .. hex end

    return ""
end

Util.OnOff = function(bToggle)
    if bToggle then
        return Color.GREEN .. L["On"] .. "|r"
    end
    return Color.RED .. L["Off"] .. "|r"
end

function Util.GetItemText(icon, link, quantity, iconOnly)
    quantity = quantity or 1
    icon = icon or "Interface\\Icons\\INV_Misc_QuestionMark"
    link = link or ""
    local texture = "|T" .. icon .. ":0|t"
    local text = texture .. link

    if iconOnly then
        local newText, count = link:gsub("|h%[.+%]|h", "|h[" .. texture .. "]|h")
        if count == 0 then
            newText = link:gsub("|h.+|h", "|h" .. texture .. "|h")
        end
        text = newText
    end

    return Color.WHITE .. quantity .. "x|r" .. text
end

function Util.GetBoolean(bool, def)
    if bool == "on" or bool == true then
        return true
    elseif bool == "off" or bool == false then
        return false
    end

    if not def then return false end

    return def
end

function Util.mergeTable(t1, t2)
    for k, v in pairs(t2) do
        if type(v) == "table" and type(t1[k] or false) == "table" then
            Util.mergeTable(t1[k], t2[k])
        else
            t1[k] = v
        end
    end
    return t1
end

function Util.getId(itemLinkOrId)
    if not itemLinkOrId then return end
    if tonumber(itemLinkOrId) then return tonumber(itemLinkOrId) end

    -- 0) Robust native API when available
    local GetItemInfoInstantFunc = (C_Item and C_Item.GetItemInfoInstant) or _G.GetItemInfoInstant
    if GetItemInfoInstantFunc then
        local iid = select(1, GetItemInfoInstantFunc(itemLinkOrId))
        if iid and tonumber(iid) then return tonumber(iid) end
    end

    -- 1) Fast path: parse plain item:id anywhere in the string
    local id = itemLinkOrId:match("item:(%-?%d+)")
    if id then return tonumber(id) end

    -- 2) Fallback to legacy permissive pattern (kept for compatibility)
    local _, _, capturedId = string_match(itemLinkOrId,
        "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
    if capturedId then return tonumber(capturedId) end

    return nil
end

function Util.trim(s)
    return (string_gsub(s, "^%s*(.-)%s*$", "%1"))
end
