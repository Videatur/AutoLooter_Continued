--[[
    AutoLooter Auctionator Integration
    Retrieves the lowest known auction price for an item link from Auctionator.
    Falls back gracefully when Auctionator is missing or not yet initialized.
]]

-- Returns lowest known auction price from Auctionator, or nil if unavailable.
---@param itemLink string
---@return number|nil
function AuctionPrice(itemLink)
    if type(itemLink) ~= "string" or itemLink == "" then return nil end
    local A = rawget(_G, "Auctionator")
    if not A then return nil end

    -- Preferred public API (synchronous)
    if A.API and A.API.v1 and A.API.v1.GetAuctionPriceByItemLink then
        local ok, price = pcall(function()
            return A.API.v1.GetAuctionPriceByItemLink("AutoLooter", itemLink)
        end)
        if ok and type(price) == "number" and price > 0 then
            return price
        end
    end

    -- Fallback to Database if Utilities provides a synchronous key
    local utils = A.Utilities
    local db = A.Database
    if utils and db then
        -- Check if Auctionator database is initialized and has data
        local hasData = false
        local ok, allPrices = pcall(function()
            return db.GetAllPrices and db:GetAllPrices()
        end)
        if ok and allPrices and type(allPrices) == "table" and next(allPrices) ~= nil then
            hasData = true
        end

        -- Only try to get price if database has data
        if hasData then
            local ok, keyOrKeys = pcall(function()
                -- Some versions return a string key synchronously, others require a callback.
                if utils.DBKeyFromLink then
                    -- Check if the function exists and is callable
                    if type(utils.DBKeyFromLink) == "function" then
                        return utils.DBKeyFromLink(itemLink)
                    end
                end
                return nil
            end)
            if ok and keyOrKeys then
                local priceOk, price = pcall(function()
                    return db.GetFirstPrice and db:GetFirstPrice(keyOrKeys)
                end)
                if priceOk and type(price) == "number" and price > 0 then
                    return price
                end
            end
        end
    end

    -- No price available
    return nil
end
