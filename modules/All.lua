--[[
    AutoLooter All Module
    Catch-all handler that loots everything when lootAll is enabled,
    or logs remaining items as ignored when disabled.
]]

local ADDON_NAME, PRIVATE_TABLE = ...

-- Upvalue frequently-used globals
local type = type

local L = LibStub("AceLocale-3.0"):GetLocale("AutoLooter")
local Color = PRIVATE_TABLE.Color
local Util = PRIVATE_TABLE.Util

local AutoLooter = LibStub("AceAddon-3.0"):GetAddon("AutoLooter")
local module = AutoLooter:NewModule("All", "AceEvent-3.0")
module.priority = 100000

local reason = Color.GREEN .. L["All"]
local reasonLog = Color.ORANGE .. L["Ignored"]

local GetItemInfoInstant = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
local CloseLoot = CloseLoot

function module.CanLoot(link, icon, sTitle, nQuantity, currencyID, nRarity, locked, isQuestItem, questId, isActive)
    if AutoLooter.db.profile.lootAll then
        -- Loot everything left
        return true, reason, AutoLooter.FormatLoot(icon, link, nQuantity), nil
    else
        -- Logs everything left
        local _, itemType, itemSubType = GetItemInfoInstant(link)
        local typeSubtype = (AutoLooter.db.profile.printoutType and Color.YELLOW .. "(" .. itemType .. "/" .. itemSubType .. ")|r") or ""

        return false, reasonLog, typeSubtype .. AutoLooter.FormatLoot(icon, link, nQuantity), true
    end
end

function module.Finish()
    if AutoLooter.db.profile.close then
        CloseLoot()
    end
end

function module:GetOptions()
    return {
        general = {
            args = {
                lootAll = {
                    type = "toggle",
                    name = L["Loot everything"],
                    dialogControl = "AutoLooter_WrapTextCheckBox",
                    set = function(info, val) AutoLooter.db.profile.lootAll = Util.GetBoolean(val) end,
                    get = function(info) return AutoLooter.db.profile.lootAll end,
                },
            },
        },
    }
end
