--[[
    AutoLooter Quest Module
    Loots quest items from corpses based on active quest requirements.
]]

local ADDON_NAME, PRIVATE_TABLE = ...

-- Upvalue frequently-used globals
local type = type
local select = select

local L = LibStub("AceLocale-3.0"):GetLocale("AutoLooter")
local Color = PRIVATE_TABLE.Color
local Util = PRIVATE_TABLE.Util

local AutoLooter = LibStub("AceAddon-3.0"):GetAddon("AutoLooter")
local module = AutoLooter:NewModule("Quest", PRIVATE_TABLE.ToggleableModulePrototype, "AceEvent-3.0")
module.priority = 800

local reason = Color.GREEN .. L["Quest"]

local GetNumQuestLogEntries = (C_QuestLog and C_QuestLog.GetNumQuestLogEntries) or GetNumQuestLogEntries
local GetNumQuestLeaderBoards = (C_QuestLog and C_QuestLog.GetNumQuestLeaderBoards) or GetNumQuestLeaderBoards
local GetQuestLogLeaderBoard = (C_QuestLog and C_QuestLog.GetQuestLogLeaderBoard) or GetQuestLogLeaderBoard
local C_Timer = C_Timer

local questItemList = {}
local questItemClassID = LE_ITEM_CLASS_QUESTITEM or Enum.ItemClass.Questitem

function module:CanEnable()
    return self.db.profile.lootQuest
end

function module:InitializeDb()
    self.db = AutoLooter.db
end

function module:OnEnable()
    self:RegisterEvent("QUEST_LOG_UPDATE")
    self:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
    -- If the option is enabled later, the event might not trigger immediately. So I update the list now.
    questItemList = self:CreateQuestItemList()
end

function module.CanLoot(link, icon, sTitle, nQuantity, currencyID, nRarity, locked, isQuestItem, questId, isActive)
    if AutoLooter.db.profile.lootQuest then
        -- Slot flags and objective names do not require cached item metadata.
        if isQuestItem or (sTitle and questItemList[sTitle]) then
            return true, reason, AutoLooter.FormatLoot(icon, link, nQuantity), nil
        end
        local itemName, _, _, _, _, itemType, itemSubType, _, _, _, iPrice, itemClassID, itemSubClassID, bindType = Util.GetCachedItemInfo(link)
        local instantClassID = select(6, Util.GetCachedItemInfoInstant(link))
        if bindType == 4 or itemClassID == questItemClassID or instantClassID == questItemClassID
            or (itemName and questItemList[itemName]) then
            return true, reason, AutoLooter.FormatLoot(icon, link, nQuantity), nil
        end
    end
end

function module:GetOptions()
    return {
        general = {
            args = {
                lootQuest = {
                    type = "toggle",
                    name = L["Loot quest items"],
                    set = function(info, value) self:SetProfileVar("lootQuest", Util.GetBoolean(value)) end,
                    get = function(info) return self.db.profile.lootQuest end,
                },
            },
        },
    }
end

-- ============================================================================
-- QUEST LOG SCANNING
-- ============================================================================

function module:CreateQuestItemList()
    local itemList = {}
    local function addObjective(text, objectiveType, finished)
        if finished or objectiveType ~= "item" or type(text) ~= "string" then return end
        -- Both formats occur across supported clients and locales.
        local itemName = text:match("^(.-):%s*%d+%s*/%s*%d+%s*$")
            or text:match("^%s*%d+%s*/%s*%d+%s+(.+)$")
        if itemName then itemList[Util.trim(itemName)] = true end
    end

    for questIndex = 1, GetNumQuestLogEntries() do
        if C_QuestLog and C_QuestLog.GetInfo and C_QuestLog.GetQuestObjectives then
            local info = C_QuestLog.GetInfo(questIndex)
            if info and not info.isHeader and info.questID then
                for _, objective in ipairs(C_QuestLog.GetQuestObjectives(info.questID) or {}) do
                    addObjective(objective.text, objective.type, objective.finished)
                end
            end
        elseif GetNumQuestLeaderBoards and GetQuestLogLeaderBoard then
            for boardIndex = 1, GetNumQuestLeaderBoards(questIndex) or 0 do
                addObjective(GetQuestLogLeaderBoard(boardIndex, questIndex))
            end
        end
    end

    return itemList
end

-- UNIT_QUEST_LOG_CHANGED fires frequently (per loot, per progress tick);
-- debounce full quest-log rescans so we don't re-scan every quest each time.
local rescanTimer

local function ScheduleRescan()
    if rescanTimer then
        rescanTimer:Cancel()
    end
    rescanTimer = C_Timer.NewTimer(0.5, function()
        rescanTimer = nil
        if module:IsEnabled() then
            questItemList = module:CreateQuestItemList()
        end
    end)
end

function module:QUEST_LOG_UPDATE()
    ScheduleRescan()
end

function module:UNIT_QUEST_LOG_CHANGED(event, unitId)
    if unitId == "player" then
        ScheduleRescan()
    end
end
