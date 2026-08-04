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
local isRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE

function module:CanEnable()
    return self.db.profile.lootQuest
end

function module:InitializeDb()
    self.db = AutoLooter.db
end

function module:OnEnable()
    self:RegisterEvent("QUEST_LOG_UPDATE")
    -- If the option is enabled later, the event might not trigger immediately. So I update the list now.
    questItemList = self:CreateQuestItemList()
end

function module.CanLoot(link, icon, sTitle, nQuantity, currencyID, nRarity, locked, isQuestItem, questId, isActive)
    if AutoLooter.db.profile.lootQuest then
        local itemName, _, _, _, _, itemType, itemSubType, _, _, _, iPrice, itemClassID, itemSubClassID, bindType = Util.GetCachedItemInfo(link)
        if itemName and (isQuestItem or bindType == 4 or itemClassID == questItemClassID or questItemList[itemName]) then
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
                    dialogControl = "AutoLooter_WrapTextCheckBox",
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

    for questIndex = 1, GetNumQuestLogEntries() do
        for boardIndex = 1, GetNumQuestLeaderBoards(questIndex) do
            local leaderboardTxt, boardItemType, isDone = GetQuestLogLeaderBoard(boardIndex, questIndex)
            if not isDone and boardItemType == "item" then
                local itemName, numItems, numNeeded
                if isRetail then
                    numItems, numNeeded, itemName = leaderboardTxt:match("([%d]+)%s*/%s*([%d]+)%s*(.*)%s*")
                else
                    itemName, numItems, numNeeded = leaderboardTxt:match("(.*):%s*([%d]+)%s*/%s*([%d]+)")
                end
                if itemName then
                    itemList[itemName] = true
                end
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
        if rescanTimer.Cancel then rescanTimer:Cancel() end
        rescanTimer = nil
    end
    rescanTimer = C_Timer.After(0.5, function()
        rescanTimer = nil
        if module:IsEnabled() then
            questItemList = module:CreateQuestItemList()
        end
    end)
end

function module:QUEST_LOG_UPDATE()
    self:UnregisterEvent("QUEST_LOG_UPDATE")
    self:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
    ScheduleRescan()
end

function module:UNIT_QUEST_LOG_CHANGED(event, unitId)
    if unitId == "player" then
        ScheduleRescan()
    end
end
