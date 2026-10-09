--[[
    AutoLooter Main
    Core addon logic: loot filtering, module iteration, event handling, and slash commands.
    Maintained by Videatur; original author Eliote.
]]

local ADDON_NAME, PRIVATE_TABLE = ...

-- Upvalue frequently-used globals
local type = type
local pairs = pairs
local ipairs = ipairs
local tostring = tostring
local select = select
local table_insert = table.insert
local table_concat = table.concat
local pcall = pcall

local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
local MOD_VERSION = GetAddOnMetadata(ADDON_NAME, "Version")

---@class AutoLooter
AutoLooter = LibStub("AceAddon-3.0"):NewAddon("AutoLooter", "AceEvent-3.0")
local events = LibStub("CallbackHandler-1.0"):New(AutoLooter)

local L = LibStub("AceLocale-3.0"):GetLocale("AutoLooter")

---@type Util
local Util = PRIVATE_TABLE.Util
local Color = PRIVATE_TABLE.Color

AutoLooter.GetNumLootItems = GetNumLootItems
AutoLooter.GetLootSlotType = GetLootSlotType
AutoLooter.GetLootSlotInfo = GetLootSlotInfo
AutoLooter.GetLootSlotLink = GetLootSlotLink
AutoLooter.LootSlot = LootSlot
AutoLooter.ConfirmLootSlot = ConfirmLootSlot

-- ============================================================================
-- CHAT OUTPUT
-- ============================================================================

local chatCache = {}
local function findChatFrame(name)
    if name == -1 then return DEFAULT_CHAT_FRAME end

    local chat = chatCache[name]
    if chat then return chat end

    local found
    for i = 1, NUM_CHAT_WINDOWS do
        local chatName = GetChatWindowInfo(i)
        if chatName then
            local chatFrame = _G["ChatFrame" .. i]
            chatCache[chatName] = chatFrame

            if chatName == name then
                found = chatFrame
            end
        end
    end

    return found
end

local function filterChatFrame(namesMap)
    local frames = {}
    for k, selected in pairs(namesMap) do
        if selected then
            local frame = findChatFrame(k)
            if frame then
                table_insert(frames, frame)
            end
        end
    end
    return frames
end

function AutoLooter.print(...)
    local chatFrames = filterChatFrame(AutoLooter.db.char.chatFrameNames)
    if #chatFrames == 0 then return end

    local args = {}
    for i = 1, select("#", ...) do
        args[i] = tostring(select(i, ...))
    end
    local out = table_concat(args)

    for i, chatFrame in ipairs(chatFrames) do
        chatFrame:AddMessage(Color.WHITE .. "[" .. Color.BLUE .. "AL" .. Color.WHITE .. "]|r|r|r " .. out)
    end
end

-- ============================================================================
-- ADDON STATE MANAGEMENT
-- ============================================================================

local function LoadState()
    if AutoLooter.db.profile.enable then
        AutoLooter:Enable()
    else
        AutoLooter:Disable()
    end
end

function AutoLooter.Toggle(bool)
    AutoLooter.db.profile.enable = Util.GetBoolean(bool, not AutoLooter.db.profile.enable)
    LoadState()
end

function AutoLooter:ReloadOptions(onInit)
    if onInit == "OnInitialization" then
        self:SetEnabledState(self.db.profile.enable)
    else
        LoadState()
    end
end

-- ============================================================================
-- OPTIONS / PROFILE SETUP
-- ============================================================================

function AutoLooter:CreateProfile()
    self.options = {
        type = "group",
        name = "AutoLooter",
        args = {
            config = {
                type = "execute",
                name = L["Show/Hide UI"],
                func = function() AutoLooter:ToggleOptions() end,
                hidden = true,
            },
            general = {
                order = 0,
                name = L["General"],
                type = "group",
                args = {},
            },
        },
    }

    self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    self.options.args.profile.name = L["Profiles"]
    self.options.args.profile.order = -1

    for _, module in AutoLooter:IterateModules() do
        if module.GetOptions then
            Util.mergeTable(self.options.args, module:GetOptions())
        end
    end

    local AceConfig = LibStub("AceConfig-3.0")
    AceConfig:RegisterOptionsTable("AutoLooter", self.options, { "al", "autolooter", "atl" })

    self:RegisterOptionsPanel()

    -- Preserve AceConfig text commands, but open the native view for bare aliases.
    for _, alias in ipairs({ "al", "autolooter", "atl" }) do
        local command = "ACECONSOLE_" .. alias:upper()
        local handler = SlashCmdList[command]
        SlashCmdList[command] = function(input, editBox)
            if not input or input:match("^%s*$") then self:ToggleOptions()
            elseif handler then handler(input, editBox) end
        end
    end
end

local function registerResetCacheOn(module, func)
    local original = module[func]
    module[func] = function(...)
        AutoLooter:ResetModulesCache()
        if original then return original(...) end
    end
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

function AutoLooter:OnInitialize()
    -- On some Classic branches LE_EXPANSION_LEVEL_CURRENT can be nil; guard it.
    local isDragonFlight = Util.IsDragonflight()
    local defaults = {
        profile = {
            items = {},
            ignore = {},
            alert = {},
            enable = true,
            printout = true,
            printoutIgnored = false,
            printType = false,
            lootAll = false,
            lootQuest = true,
            close = false,
            rarity = 2,
            price = 40000,
            auctionatorIntegration = false,
            alertSound = "Sound/creature/Murloc/mMurlocAggroOld.ogg",
            typeTable = {},
            ignoreGreys = false,
            autoConfirmRoll = false,
            minimap = { hide = false },
            ignoreBop = false,
            printoutReason = true,
            lootEarly = not isDragonFlight,
            printLoginCommands = false,
            printCommandsAtLogin = false,
        },
        global = {
            fishItems = {},
            language = "client",
        },
        char = {
            chatFrameNames = { [-1] = true },
        },
    }
    self.db = LibStub("AceDB-3.0"):New("AutoLooterDB", defaults, "Default")
    PRIVATE_TABLE.Localization:Apply(self.db.global.language)
    self.db.RegisterCallback(self, "OnProfileChanged", "ReloadOptions")
    self.db.RegisterCallback(self, "OnProfileCopied", "ReloadOptions")
    self.db.RegisterCallback(self, "OnProfileReset", "ReloadOptions")

    for _, module in self:IterateModules() do
        registerResetCacheOn(module, "OnEnable")
        registerResetCacheOn(module, "OnDisable")
    end

    AutoLooter:ReloadOptions("OnInitialization")
    AutoLooter:CreateProfile()

    if self.db.profile.printCommandsAtLogin then
        DEFAULT_CHAT_FRAME:AddMessage(Color.BLUE .. "AutoLooter" .. Color.WHITE .. " || v" .. MOD_VERSION .. " || " .. Color.YELLOW .. "/autolooter /al /atl|r")
    end
end

function AutoLooter:OnEnable()
    self:RegisterLootEvents()
    events:Fire("OnEnable")
end

function AutoLooter:OnDisable()
    events:Fire("OnDisable")
end

-- Only the loot event actually used by the current lootEarly setting needs to
-- be active; keeps the event handler from firing an empty pass on every loot.
function AutoLooter:RegisterLootEvents()
    if self.db.profile.lootEarly then
        self:RegisterEvent("LOOT_READY")
        self:UnregisterEvent("LOOT_OPENED")
    else
        self:RegisterEvent("LOOT_OPENED")
        self:UnregisterEvent("LOOT_READY")
    end
end

-- ============================================================================
-- LOOT LOGIC
-- ============================================================================

local function Loot(index, itemName, itemLink)
    AutoLooter.LootSlot(index)
    pcall(AutoLooter.ConfirmLootSlot, index) -- In case it's a Bind on Pickup
    events:Fire("OnLoot", index)
end

local trim = Util.trim
local function PrintReason(reason, contents)
    local items = ""
    for _, content in pairs(contents) do
        items = items .. content .. " "
    end

    if not reason or reason == "" then
        AutoLooter.print(trim(items))
    else
        AutoLooter.print(reason, "|r: ", trim(items))
    end
end

local modulesCache = {}
local resetMessage = {}
---@return fun(tbl: table<string, AutoLooterModule>):string, AutoLooterModule
function AutoLooter:SortedModulesIterator(lootOnly)
    local cacheKey = lootOnly and "lootOnlyTrue" or "lootOnlyFalse"
    if modulesCache[cacheKey] ~= nil then
        modulesCache[cacheKey](resetMessage)
        return modulesCache[cacheKey]
    end

    -- Snapshot module priorities once per cache build so the sort comparator
    -- never resolves GetModule() (O(n log n) lookups) during every comparison.
    local priorities = {}
    for key in self:IterateModules() do
        local module = self:GetModule(key)
        priorities[key] = (module and module.priority) or 99999999
    end

    local function sort(o1, o2)
        local p1 = priorities[o1] or 99999999
        local p2 = priorities[o2] or 99999999
        if p1 == p2 then return o1 < o2 end -- stable tie-break for determinism
        return p1 < p2
    end
    local exclusion = function(key, module)
        if module:IsEnabled() then
            if lootOnly then return module.CanLoot end
            return true
        end
    end
    local function iterator() return self:IterateModules() end

    modulesCache[cacheKey] = Util.orderedPairs(iterator, sort, exclusion, resetMessage)
    return modulesCache[cacheKey]
end

function AutoLooter:ResetModulesCache()
    modulesCache = {}
end

-- ============================================================================
-- EVENT HANDLERS
-- ============================================================================

function AutoLooter:LOOT_OPENED(...)
    if not self.db.profile.lootEarly then
        self:Loot(...)
    end
end

function AutoLooter:LOOT_READY(...)
    if self.db.profile.lootEarly then
        self:Loot(...)
    end
end

function AutoLooter:Loot(_, autoloot)
    if autoloot then return end

    events:Fire("OnLootReadyStart")

    -- New loot window: drop item-info session cache from the previous loot.
    Util.ResetLootCache()

    local reasonMap = {}
    local printReason = self.db.profile.printout
    local lootModules = self:SortedModulesIterator(true)

    for nIndex = 1, self.GetNumLootItems() do
        local slotType = self.GetLootSlotType(nIndex) or 0
        if slotType > 0 then
            -- If the item is gone, there's nothing we can do.
            local icon, title, quantity, currencyID, rarity, locked, isQuestItem, questId, isActive = self.GetLootSlotInfo(nIndex)
            quantity = quantity or 0
            local itemLink = self.GetLootSlotLink(nIndex)

            -- The iterator is a shared closure; reset it before each slot so
            -- the module list is re-walked for every item.
            lootModules(resetMessage)
            for _, module in lootModules do
                local loot, reason, reasonContent, forceBreak = module.CanLoot(
                    itemLink,
                    icon,
                    title,
                    quantity,
                    currencyID,
                    rarity,
                    locked,
                    isQuestItem,
                    questId,
                    isActive
                )

                if printReason and reason and reasonContent and reasonContent ~= "" then
                    -- Ignored items will still print the reason
                    if loot and not self.db.profile.printoutReason and quantity > 0 then
                        reason = ""
                    end

                    if loot or self.db.profile.printoutIgnored then
                        reasonMap[reason] = reasonMap[reason] or {}
                        table_insert(reasonMap[reason], reasonContent)
                    end
                end

                if loot then
                    Loot(nIndex, title, itemLink)
                    break
                end

                if forceBreak then break end -- Ignore other modules and go to the next item
            end
        end
    end

    for _, module in self:SortedModulesIterator() do
        if module.Finish then module.Finish() end
    end

    for reason, contents in pairs(reasonMap) do
        PrintReason(reason, contents)
    end

    events:Fire("OnLootReadyFinish")
end
