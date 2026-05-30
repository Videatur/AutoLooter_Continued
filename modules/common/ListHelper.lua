--[[
    AutoLooter List Helper
    Generic item list management for whitelist, blacklist, and alert list operations.
]]

local ADDON_NAME, PRIVATE_TABLE = ...

-- Upvalue frequently-used globals
local type = type
local pairs = pairs
local tonumber = tonumber
local select = select

local AutoLooter = LibStub("AceAddon-3.0"):GetAddon("AutoLooter")
local L = LibStub("AceLocale-3.0"):GetLocale("AutoLooter")
local ListHelper = PRIVATE_TABLE.ListHelper
local Util = PRIVATE_TABLE.Util
local Color = PRIVATE_TABLE.Color

local GetItemInfo = (C_Item and C_Item.GetItemInfo) or GetItemInfo
local GetItemInfoInstant = (C_Item and C_Item.GetItemInfoInstant) or _G.GetItemInfoInstant

function ListHelper.AddItem(sTitle, list)
    local sLink = sTitle
    if type(sTitle) == "string" then sLink = Util.trim(sTitle) end
    if not sTitle or sTitle == "" then
        sTitle, sLink = GameTooltip:GetItem()

        if not sTitle or sTitle == "" then
            for k, _ in pairs(list) do
                AutoLooter.print(k)
            end
            return
        end
    end

    local id = Util.getId(sLink)
    if not id and GetItemInfoInstant then
        local iid = select(1, GetItemInfoInstant(sLink))
        if iid then id = tonumber(iid) end
    end
    if not id then
        -- Try extracting [Item Name] and resolve to link if cached
        local bracketName = sLink and sLink:match("%[(.+)%]") or sTitle and sTitle:match("%[(.+)%]")
        local tryName = bracketName or sTitle
        if tryName and tryName ~= "" then
            local _, nameLink = GetItemInfo(tryName)
            if nameLink then
                id = Util.getId(nameLink)
                sLink = nameLink
            end
        end
    end
    if not id then
        AutoLooter.print(L["Invalid item"], ": ", sTitle)
        return
    end

    local hasItemAPI = Item and Item.CreateFromItemID
    if hasItemAPI then
        local item = Item:CreateFromItemID(id)
        if not item then
            AutoLooter.print(L["Invalid item"], ": ", sTitle)
            return
        end

        item:ContinueOnItemLoad(function()
            local name, link = GetItemInfo(id)
            link = link or sLink

            if list[id] then
                AutoLooter.print(L["Already in the list"], ": ", Color.YELLOW, link)
                return
            end

            if name and list[name] then
                list[name] = nil
            end

            list[id] = link
            AutoLooter.print(L["Added"], ": ", Color.YELLOW, link)
        end)
    else
        -- Fallback path for older clients: use whatever info we have synchronously
        local name, link = GetItemInfo(id)
        link = link or sLink

        if list[id] then
            AutoLooter.print(L["Already in the list"], ": ", Color.YELLOW, link)
            return
        end

        if name and list[name] then
            list[name] = nil
        end

        list[id] = link
        AutoLooter.print(L["Added"], ": ", Color.YELLOW, link)
    end
end

function ListHelper.RemoveItem(sTitle, list)
    local sLink = sTitle
    if type(sTitle) == "string" then sLink = Util.trim(sTitle) end
    -- If the UI passes numeric IDs as strings, normalize them to numbers
    if type(sTitle) == "string" then
        local maybeNum = tonumber(sTitle)
        if maybeNum then sTitle = maybeNum end
    end
    if sTitle == nil or (type(sTitle) == "string" and sTitle == "") then
        sTitle, sLink = GameTooltip:GetItem()

        if not sTitle or sTitle == "" then
            for k, _ in pairs(list) do
                AutoLooter.print(k)
            end
            return
        end
    end

    local id = Util.getId(sLink)
    if not id and GetItemInfoInstant then
        local iid = select(1, GetItemInfoInstant(sLink))
        if iid then id = tonumber(iid) end
    end
    if not id then
        local bracketName = sLink and sLink:match("%[(.+)%]") or sTitle and sTitle:match("%[(.+)%]")
        local tryName = bracketName or sTitle
        if tryName and tryName ~= "" then
            local _, nameLink = GetItemInfo(tryName)
            if nameLink then
                id = Util.getId(nameLink)
                sLink = nameLink
            end
        end
    end

    if not id then
        if sTitle ~= nil and list[sTitle] then
            list[sTitle] = nil
            AutoLooter.print(L["Removed"], ": ", Color.YELLOW, sTitle)
            return
        end
    end

    if id and list[id] then
        local link = list[id]
        list[id] = nil
        AutoLooter.print(L["Removed"], ": ", Color.YELLOW, link)
        return
    end

    -- Fallback: try to match by displayed value (link) or plain name in the list values
    if type(sTitle) == "string" then
        for k, v in pairs(list) do
            if v == sTitle then
                list[k] = nil
                AutoLooter.print(L["Removed"], ": ", Color.YELLOW, sTitle)
                return
            end
            -- If user clicked a name (no link), try to match the bracketed name inside the link
            if type(v) == "string" then
                local vn = v:match("%[(.+)%]")
                if vn and vn == sTitle then
                    list[k] = nil
                    AutoLooter.print(L["Removed"], ": ", Color.YELLOW, v)
                    return
                end
            end
        end
    end

    AutoLooter.print(L["Not listed"], ": ", Color.YELLOW, sTitle)
end

function ListHelper.ListToString(list)
    local text = ""
    for k, _ in pairs(list) do
        text = text .. k .. '\n'
    end
    return text
end

function ListHelper.GetValues(list)
    local values = {}

    for k, v in pairs(list) do
        if tonumber(k) then
            values[k] = v
        elseif v then
            values[k] = k
        end
    end

    return values
end
