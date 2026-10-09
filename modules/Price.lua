--[[
    AutoLooter Price Module
    Loots items whose vendor price (or Auctionator price) exceeds a threshold.
]]

local ADDON_NAME, PRIVATE_TABLE = ...

-- Upvalue frequently-used globals
local type = type
local pcall = pcall
local GetTime = GetTime

local L = LibStub("AceLocale-3.0"):GetLocale("AutoLooter")
local Color = PRIVATE_TABLE.Color
local Util = PRIVATE_TABLE.Util

local AutoLooter = LibStub("AceAddon-3.0"):GetAddon("AutoLooter")
local module = AutoLooter:NewModule("Price", PRIVATE_TABLE.ToggleableModulePrototype, "AceEvent-3.0")
module.priority = 1000

local reason = Color.GREEN .. L["Price"]

function module:CanEnable()
    return AutoLooter.db.profile.price > 0
end

function module:InitializeDb()
    self.db = AutoLooter.db
end

-- Auctionator prices are cached per item and refreshed on a short TTL so a
-- single corpse loot doesn't trigger a full price-table scan for every slot.
local AUCTION_PRICE_CACHE_TTL = 30
local auctionPriceCache = {}

function module.CanLoot(link, icon, sTitle, nQuantity, currencyID, nRarity, locked, isQuestItem, questId, isActive)
    local _, _, _, _, _, itemType, itemSubType, _, _, _, iPrice = Util.GetCachedItemInfo(link)
    -- Auctionator integration
    local aPrice
    if AutoLooter.db.profile.auctionatorIntegration and type(AuctionPrice) == "function" then
        local id = Util.GetCachedId(link)
        if id then
            local cached = auctionPriceCache[id]
            if cached and GetTime() - cached.time < AUCTION_PRICE_CACHE_TTL then
                aPrice = cached.price
            else
                local ok, result = pcall(AuctionPrice, link)
                if ok then
                    aPrice = result
                end
                auctionPriceCache[id] = { price = aPrice, time = GetTime() }
            end
        else
            local ok, result = pcall(AuctionPrice, link)
            if ok then
                aPrice = result
            end
        end
    end
    if aPrice and aPrice >= AutoLooter.db.profile.price then
        iPrice = aPrice
    end
    -- End Auctionator
    if iPrice and AutoLooter.db.profile.price > 0 and iPrice >= AutoLooter.db.profile.price then
        return true, reason, AutoLooter.FormatLoot(icon, link, nQuantity), nil
    end
end

function module:GetOptions()
    return {
        general = {
            args = {
                priceGroup = {
                    name = L["Price"],
                    type = "group",
                    inline = true,
                    order = 1000,
                    args = {
                        price = {
                            type = "range",
                            name = function()
                                local formatedPrice = "[" .. Color.RED .. L["Off"] .. "|r]"
                                if AutoLooter.db.profile.price > 0 then
                                    formatedPrice = GetMoneyString(AutoLooter.db.profile.price)
                                end
                                return formatedPrice
                            end,
                            desc = function()
                                if AutoLooter.db.profile.price > 0 then
                                    return L["Loot everything with a price greater or equal to this value"]
                                end
                            end,
                            min = 0,
                            max = 200000, -- 20 gold
                            step = 1000, -- 10 silver per slider tick
                            width = "full",
                            set = function(info, value) module:SetProfileVar("price", value) end,
                            get = function(info) return AutoLooter.db.profile.price end,
                        },
                    },
                },
            },
        },
    }
end
