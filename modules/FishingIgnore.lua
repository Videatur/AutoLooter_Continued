--[[
    AutoLooter Fishing Ignore Module
    Restricts fishing loot before the general loot filters run.
]]

local ADDON_NAME, PRIVATE_TABLE = ...

local L = LibStub("AceLocale-3.0"):GetLocale("AutoLooter")
local Color = PRIVATE_TABLE.Color
local Util = PRIVATE_TABLE.Util

local AutoLooter = LibStub("AceAddon-3.0"):GetAddon("AutoLooter")
local module = AutoLooter:NewModule("FishingIgnore", PRIVATE_TABLE.ToggleableModulePrototype, "AceEvent-3.0")
module.priority = 10

local reason = Color.DARK_BLUE .. L["Ignore Fishing"]

local IsFishingLoot = IsFishingLoot

function module:CanEnable()
    return module.db.profile.enableModule or module.db.profile.lootWhitelistOnly
end

function module:InitializeDb()
    local defaults = { profile = { enableModule = false, lootWhitelistOnly = false } }
    self.db = AutoLooter.db:RegisterNamespace("FishingIgnoreModule", defaults)
end

-- Choosing a fishing mode clears the other modes in the current profile.
function module:SetFishingMode(mode, enabled)
    local fishing = AutoLooter:GetModule("Fishing")
    if enabled then
        self.db.profile.enableModule = mode == "none"
        self.db.profile.lootWhitelistOnly = mode == "whitelist"
        fishing.db.profile.enableFishingLoot = mode == "all"
    elseif mode == "none" then
        self.db.profile.enableModule = false
    elseif mode == "whitelist" then
        self.db.profile.lootWhitelistOnly = false
    else
        fishing.db.profile.enableFishingLoot = false
    end
    self:UpdateState()
    fishing:UpdateState()
end

function module.CanLoot(link, icon, sTitle, nQuantity, currencyID, nRarity, locked, isQuestItem, questId, isActive)
    if not IsFishingLoot() then return end
    if module.db.profile.enableModule then
        return false, reason, AutoLooter.FormatLoot(icon, link, nQuantity), true
    end
    if module.db.profile.lootWhitelistOnly then
        local items = AutoLooter.db.profile.items
        local id = Util.GetCachedId(link)
        if not ((id and items[id]) or (sTitle and items[sTitle])) then
            return false, reason, AutoLooter.FormatLoot(icon, link, nQuantity), true
        end
        -- Listed items continue through the existing locked/whitelist checks.
    end
end

function module:GetOptions()
    return {
        fishing = {
            name = L["Fishing"],
            type = "group",
            args = {
                fishingBuddy = {
                    type = "toggle",
                    order = 2,
                    name = L["Don't loot anything while Fishing"],
                    desc = L["This can be useful to let addons like Fishing Buddy do its work"],
                    set = function(info, value) self:SetFishingMode("none", Util.GetBoolean(value)) end,
                    get = function(info) return self.db.profile.enableModule end,
                },
                fishingWhitelist = {
                    type = "toggle",
                    order = 3,
                    width = "double",
                    name = L["Loot only whitelisted items while Fishing"],
                    desc = L["Fishing whitelist mode description"],
                    set = function(info, value) self:SetFishingMode("whitelist", Util.GetBoolean(value)) end,
                    get = function(info) return self.db.profile.lootWhitelistOnly end,
                },
            },
        },
    }
end
