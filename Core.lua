--[[
    AutoLooter Core
    Private namespace initialization with auto-creating sub-tables via __index.
]]

local ADDON_NAME, PRIVATE_TABLE = ...
PRIVATE_TABLE.MODULES = {}

setmetatable(PRIVATE_TABLE, {
    __index = function(table, key)
        table[key] = {}
        return table[key]
    end,
})
