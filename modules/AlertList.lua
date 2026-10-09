--[[
    AutoLooter Alert List Module
    Plays a sound and posts a raid warning when a tracked item drops on a corpse.
]]

local ADDON_NAME, PRIVATE_TABLE = ...

-- Upvalue frequently-used globals
local type = type
local next = next
local pcall = pcall

local L = LibStub("AceLocale-3.0"):GetLocale("AutoLooter")
local ListHelper = PRIVATE_TABLE.ListHelper
local Util = PRIVATE_TABLE.Util
local Media = LibStub("LibSharedMedia-3.0")

local AutoLooter = LibStub("AceAddon-3.0"):GetAddon("AutoLooter")
local module = AutoLooter:NewModule("AlertList", PRIVATE_TABLE.ToggleableModulePrototype, "AceEvent-3.0")
module.priority = 1

local PlaySoundFile = PlaySoundFile
local PlaySound = PlaySound
local RaidNotice_AddMessage = RaidNotice_AddMessage

-- Keep sound-kit IDs separate from LSM file IDs: both are numbers, but use
-- different playback APIs. Stable keys also survive locale changes.
local nativeSounds = {
    { "RAID_WARNING", "Raid warning" },
    { "READY_CHECK", "Ready check" },
    { "RAID_BOSS_EMOTE_WARNING", "Boss warning" },
    { "TELL_MESSAGE", "Whisper" },
    { "MAP_PING", "Map ping" },
    { "ALARM_CLOCK_WARNING_1", "Alarm 1" },
    { "ALARM_CLOCK_WARNING_2", "Alarm 2" },
    { "ALARM_CLOCK_WARNING_3", "Alarm 3" },
    { "LOOT_WINDOW_COIN_SOUND", "Coins" },
    { "FISHING_REEL_IN", "Fishing reel" },
}

function module:GetAlertSounds()
    local values, labels = {}, {}
    for name, file in pairs(Media:HashTable("sound")) do
        values[name] = file
    end
    for _, entry in ipairs(nativeSounds) do
        local id = SOUNDKIT and SOUNDKIT[entry[1]]
        if type(id) == "number" and id > 0 then
            local key = "wow:" .. entry[1]
            values[key] = id
            labels[key] = "WoW: " .. L[entry[2]]
        end
    end
    return values, labels
end

function module:PlayAlertSound(selected)
    if type(selected) == "string" and selected:sub(1, 4) == "wow:" then
        for _, entry in ipairs(nativeSounds) do
            if selected == "wow:" .. entry[1] then
                local id = SOUNDKIT and SOUNDKIT[entry[1]]
                if type(id) == "number" and id > 0 then
                    return pcall(PlaySound, id, "Master")
                end
                return false
            end
        end
        return false
    end
    local sound = Media:HashTable("sound")[selected] or selected
    if (type(sound) == "string" and sound ~= "") or type(sound) == "number" then
        return pcall(PlaySoundFile, sound, "Master")
    end
    return false
end

function module:CanEnable()
    return AutoLooter.db.profile.alert and next(AutoLooter.db.profile.alert)
end

function module:InitializeDb()
    self.db = AutoLooter.db
end

function module.CanLoot(link, icon, sTitle, nQuantity, currencyID, nRarity, locked, isQuestItem, questId, isActive)
    local id = Util.GetCachedId(link)
    local db = AutoLooter.db.profile
    if db.alert[id] or db.alert[sTitle] then
        if db.alertSound then
            module:PlayAlertSound(db.alertSound)
        end

        RaidNotice_AddMessage(RaidWarningFrame, link, ChatTypeInfo["RAID_WARNING"])
    end
end

function module:GetOptions()
    return {
        alertlist = {
            name = L["Alert List"],
            type = "group",
            args = {
                info = {
                    type = "header",
                    name = L["You can drag & drop items here!"],
                    order = 0,
                    hidden = true,
                    dialogHidden = false,
                },
                add = {
                    type = "input",
                    name = L["Add item to alert list"],
                    width = "full",
                    set = function(info, val)
                        ListHelper.AddItem(val, AutoLooter.db.profile.alert)
                        module:UpdateState()
                    end,
                    get = false,
                    order = 1,
                },
                remove = {
                    type = "select",
                    name = L["Remove item from alert list"],
                    width = "full",
                    values = function() return ListHelper.GetValues(AutoLooter.db.profile.alert) end,
                    set = function(info, val)
                        ListHelper.RemoveItem(val, AutoLooter.db.profile.alert)
                        module:UpdateState()
                    end,
                    get = function(info) end,
                    order = 2,
                },
                sound = {
                    type = "select",
                    name = L["Set alert sound"],
                    width = "full",
                    arg = {
                        soundPreview = true,
                        soundLabels = function() local _, labels = module:GetAlertSounds(); return labels end,
                        playSound = function(selected) return module:PlayAlertSound(selected) end,
                    },
                    values = function() return module:GetAlertSounds() end,
                    set = function(info, val) AutoLooter.db.profile.alertSound = val end,
                    get = function(info) return AutoLooter.db.profile.alertSound end,
                    order = 3,
                },
            },
        },
    }
end
