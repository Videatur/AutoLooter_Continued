-- Blizzard-native view of the existing option schema. AceDB and the module
-- callbacks remain the single source of truth; all visible controls are native.
local ADDON_NAME, PRIVATE_TABLE = ...
local addon = AutoLooter
local ListHelper = PRIVATE_TABLE.ListHelper
local Util = PRIVATE_TABLE.Util
local unpack = unpack or table.unpack
local GetItemInfo = (C_Item and C_Item.GetItemInfo) or GetItemInfo
local GetItemInfoInstant = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
local UI = { expanded = {}, rows = {}, pool = {}, used = {} }
addon.NativeOptions = UI
local itemLists = {
    alertlist = { field = "alert", module = "AlertList" },
    whitelist = { field = "items", module = "WhiteList" },
    blacklist = { field = "ignore", module = "BlackList" },
    fishing = { field = "items", module = "WhiteList" },
}

local function supported()
    return ScrollUtil and ScrollUtil.InitScrollFrameWithScrollBar and MenuUtil
end

local function infoFor(path)
    local info = { options = addon.options, appName = ADDON_NAME, uiType = "dialog" }
    local node = addon.options
    info.handler = node.handler
    for i, key in ipairs(path) do
        info[i] = key
        node = node.args[key]
        info.handler = node.handler or info.handler
    end
    info.option, info.arg = node, node.arg
    return info
end

local methods = { get = true, set = true, func = true, values = true,
    disabled = true, hidden = true, validate = true, confirm = true }
local function read(info, field, ...)
    local value = info.option[field]
    if type(value) == "function" then return value(info, ...) end
    if methods[field] and type(value) == "string" and info.handler and type(info.handler[value]) == "function" then
        return info.handler[value](info.handler, info, ...)
    end
    return value
end

local function childPath(path, key)
    local result = { unpack(path) }
    result[#result + 1] = key
    return result
end

local function visible(info)
    if info.option.dialogHidden ~= nil then return not read(info, "dialogHidden") end
    return not read(info, "hidden")
end

local function ordered(args, path)
    local result = {}
    for key in pairs(args) do
        local info = infoFor(childPath(path, key))
        if visible(info) then result[#result + 1] = info end
    end
    table.sort(result, function(a, b)
        local ao, bo = read(a, "order") or 100, read(b, "order") or 100
        if ao ~= bo then return ao < bo end
        return tostring(read(a, "name") or a[#a]) < tostring(read(b, "name") or b[#b])
    end)
    return result
end

local function keys(values)
    local result = {}
    for key in pairs(values) do result[#result + 1] = key end
    table.sort(result, function(a, b)
        if type(a) == "number" and type(b) == "number" then return a < b end
        return tostring(values[a]) < tostring(values[b])
    end)
    return result
end

local function label(parent, font)
    local text = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
    text:SetJustifyH("LEFT")
    text:SetWordWrap(true)
    return text
end

local function atlas(texture, name, r, g, b, a)
    if C_Texture and C_Texture.GetAtlasInfo(name) then
        texture:SetAtlas(name)
    else
        texture:SetColorTexture(r, g, b, a or 1)
    end
end

local optionHelp = {
    price = "Price slider help",
    auctionatorIntegration = "Auctionator option help",
    ignoreBop = "Ignore BoP option help",
    fishingLoot = "Fishing all option help",
    fishingBuddy = "Fishing none option help",
}
local function tooltip(control, info)
    control:SetScript("OnEnter", function(self)
        local helpKey = optionHelp[info[#info]]
        local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)
        local desc = helpKey and L[helpKey] or read(info, "desc") or read(info, "usage")
        if desc and desc ~= "" then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(info[#info] == "price" and L["Price"] or read(info, "name") or "AutoLooter")
            GameTooltip:AddLine(desc, 1, 1, 1, true)
            GameTooltip:Show()
        end
    end)
    control:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

local function scrollArea(parent)
    local area = CreateFrame("ScrollFrame", nil, parent)
    area:EnableMouseWheel(true)
    local bar = CreateFrame("EventFrame", nil, parent, "MinimalScrollBar")
    bar:SetPoint("TOPLEFT", area, "TOPRIGHT", 5, 0)
    bar:SetPoint("BOTTOMLEFT", area, "BOTTOMRIGHT", 5, 0)
    local child = CreateFrame("Frame", nil, area)
    child:SetSize(1, 1)
    area:SetScrollChild(child)
    ScrollUtil.InitScrollFrameWithScrollBar(area, bar)
    local function updateBar(self)
        bar:SetShown(self:GetVerticalScrollRange() > .5)
    end
    area:HookScript("OnScrollRangeChanged", updateBar)
    area:SetScript("OnSizeChanged", function(self, width) child:SetWidth(width) end)
    area.Child, area.Bar, area.UpdateBarVisibility = child, bar, updateBar
    updateBar(area)
    return area
end

function UI:QueueRefresh()
    if self.pending then return end
    self.pending = true
    C_Timer.After(0, function()
        self.pending = false
        if self.frame and self.frame:IsShown() then self:Refresh() end
    end)
end

StaticPopupDialogs.AUTOLOOTER_NATIVE_CONFIRM = {
    text = "%s", button1 = YES, button2 = NO,
    OnAccept = function(_, action) action() end,
    timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
}

function UI:Apply(info, field, ...)
    if read(info, "disabled") then return end
    local args = { ... }
    if info.option.validate then
        local valid = read(info, "validate", unpack(args))
        if valid ~= true and valid ~= nil then
            UIErrorsFrame:AddMessage(type(valid) == "string" and valid or read(info, "usage") or "Invalid value", 1, .2, .2)
            return
        end
    end
    local function commit()
        read(info, field, unpack(args))
        UI:QueueRefresh()
    end
    local confirm = read(info, "confirm", unpack(args))
    if info[1] == "profile" and info[#info] == "reset" then
        confirm = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)["Reset profile confirmation"]
    end
    if confirm then
        StaticPopup_Show("AUTOLOOTER_NATIVE_CONFIRM", info.option.confirmText or
            (type(confirm) == "string" and confirm) or ((read(info, "name") or "AutoLooter") .. "?"), nil, commit)
    else
        commit()
    end
end

-- Recycle controls across pages and refreshes: WoW frames cannot be destroyed.
function UI:Acquire(kind)
    self.used[kind] = (self.used[kind] or 0) + 1
    self.pool[kind] = self.pool[kind] or {}
    local index = self.used[kind]
    local row = self.pool[kind][index]
    if not row then
        row = CreateFrame("Frame", nil, self.content.Child)
        row.Label = label(row)
        row.Label:SetPoint("TOPLEFT", 0, -2)
        if kind == "toggle" then
            row.Control = CreateFrame("CheckButton", nil, row, "MinimalCheckboxTemplate")
            row.Control:SetSize(28, 28)
            row.Control:SetPoint("TOPLEFT", -4, 3)
            row.Control:SetScript("OnHide", function(control)
                if GameTooltip:IsOwned(control) then GameTooltip:Hide() end
            end)
            row.Label:SetPoint("TOPLEFT", 28, -3)
        elseif kind == "execute" or kind == "group" then
            row.Control = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            row.Control:SetPoint("TOPLEFT", 0, 0)
            row.Control:SetSize(280, 26)
        elseif kind == "input" or kind == "range" then
            row.Control = CreateFrame("EditBox", nil, row, "InputBoxTemplate")
            row.Control:SetAutoFocus(false)
            row.Control:SetSize(kind == "range" and 120 or 340, 26)
            row.Control:SetPoint("TOPLEFT", 6, -25)
            row.Control:SetScript("OnEscapePressed", function(edit) edit:ClearFocus() end)
            row.Apply = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            row.Apply:SetSize(76, 24)
            row.Apply:SetPoint("LEFT", row.Control, "RIGHT", 10, 0)
            row.Apply:SetText(OKAY)
            if kind == "range" then
                row.Slider = CreateFrame("Slider", nil, row, "MinimalSliderTemplate")
                row.Slider:SetPoint("TOPLEFT", 5, -65)
                row.Slider:SetWidth(420)
                row.Slider:SetObeyStepOnDrag(true)
                if row.Slider.Low then row.Slider.Low:Hide() end
                if row.Slider.High then row.Slider.High:Hide() end
                if row.Slider.Text then row.Slider.Text:Hide() end
            end
        elseif kind == "select" then
            row.Control = CreateFrame("DropdownButton", nil, row, "WowStyle1DropdownTemplate")
            row.Control:SetPoint("TOPLEFT", 0, -25)
            row.Control:SetWidth(420)
        end
        self.pool[kind][index] = row
    end
    row:ClearAllPoints()
    row:SetPoint("TOPLEFT", 16, -self.y)
    row:SetWidth(self.content.Child:GetWidth() - 32)
    row.Label:SetWidth(row:GetWidth() - (kind == "toggle" and 32 or 0))
    if kind == "toggle" and self.path and self.path[1] == "fishing" then
        row.Label:SetWidth(row:GetWidth() - 52)
    end
    row.Label:Show()
    row:Show()
    return row
end

function UI:Text(text, heading)
    local row = self:Acquire("text")
    row.Label:SetFontObject(heading and "GameFontNormalLarge" or "GameFontHighlight")
    row.Label:SetText(text or "")
    local height = math.max(20, row.Label:GetStringHeight() + 12)
    row:SetHeight(height)
    self.y = self.y + height + (heading and 8 or 2)
end

-- `left` and `top` allow dense two-column sections without changing the
-- renderer used by the other option pages.
function UI:Toggle(info, key, text, left, top, width)
    local row = self:Acquire("toggle")
    local fishingCard = self.path and self.path[1] == "fishing"
    if fishingCard and not row.CardBackground then
        row.CardBackground = row:CreateTexture(nil, "BACKGROUND")
        row.CardBackground:SetAllPoints()
        atlas(row.CardBackground, "Professions-recipe-header-middle", .18, .16, .12)
    end
    if row.CardBackground then row.CardBackground:SetShown(fishingCard) end
    row.Control:ClearAllPoints()
    row.Label:ClearAllPoints()
    if fishingCard then
        row.Control:SetPoint("LEFT", 8, 0)
        row.Label:SetPoint("LEFT", row.Control, "RIGHT", 8, 0)
    else
        row.Control:SetPoint("TOPLEFT", -4, 3)
        row.Label:SetPoint("TOPLEFT", 28, -3)
    end
    if left then
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", left, -top)
        row:SetWidth(width)
        row.Label:SetWidth(width - 32)
    end
    row.Label:SetText(text or read(info, "name"))
    local control = row.Control
    control:SetChecked(read(info, "get", key) and true or false)
    control:SetEnabled(not read(info, "disabled"))
    row.Label:SetAlpha(control:IsEnabled() and 1 or .45)
    control:SetScript("OnClick", function(button)
        if key ~= nil then self:Apply(info, "set", key, button:GetChecked() and true or false)
        else self:Apply(info, "set", button:GetChecked() and true or false) end
    end)
    local labelWidth = math.min(row.Label:GetWidth(), row.Label:GetStringWidth())
    local labelGap = fishingCard and 8 or 4
    control:SetHitRectInsets(0, -(labelGap + labelWidth + 4), 0, 0)
    tooltip(control, info)
    local height = math.max(fishingCard and 54 or 32, row.Label:GetStringHeight() + (fishingCard and 24 or 12))
    row:SetHeight(height)
    if not top then self.y = self.y + height end
    return height
end

function UI:QueueListRefresh(page)
    self.listRefreshPending = self.listRefreshPending or {}
    if self.listRefreshPending[page] then return end
    self.listRefreshPending[page] = true
    C_Timer.After(.1, function()
        self.listRefreshPending[page] = nil
        if self.frame and self.frame:IsShown() and self.path[1] == page then
            self:Refresh()
        end
    end)
end

-- Show whitelist, blacklist, and tagged fishing entries beneath their controls.
function UI:RenderListItems(page)
    local config = itemLists[page]
    local saved = addon.db.profile[config.field] or {}
    local fishItems = addon.db.global.fishItems
    local items = {}
    self.unresolvedListItemIds = {}
    self.requestedListItemIds = self.requestedListItemIds or {}
    for key, link in pairs(saved) do
        local id = Util.getId(key) or Util.getId(link)
        local isFish = id and fishItems[id]
        if page == "blacklist" or page == "alertlist" or (page == "fishing" and isFish) or (page == "whitelist" and not isFish) then
            local name, _, quality, _, _, _, _, _, _, icon
            if GetItemInfo then
                name, _, quality, _, _, _, _, _, _, icon = GetItemInfo(id or link or key)
            end
            if not icon and id and GetItemInfoInstant then
                _, _, _, _, icon = GetItemInfoInstant(id)
            end
            if not name and id then
                self.unresolvedListItemIds[id] = true
                if not self.requestedListItemIds[id] and C_Item and C_Item.RequestLoadItemDataByID then
                    self.requestedListItemIds[id] = true
                    C_Item.RequestLoadItemDataByID(id)
                end
            end
            name = name or (type(link) == "string" and link:match("%[(.-)%]")) or tostring(key)
            items[#items + 1] = { key = key, link = link, id = id, name = name, quality = quality, icon = icon }
        end
    end
    table.sort(items, function(a, b)
        local first, second = a.name:lower(), b.name:lower()
        if first == second then return tostring(a.key) < tostring(b.key) end
        return first < second
    end)

    local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)
    self.y = self.y + 10
    self:Text(L[page == "fishing" and "Fishes (added in Whitelist)" or "Items list"] .. " (" .. #items .. ")", true)
    if #items == 0 then
        local emptyHelp = page == "alertlist" and "Alert empty list help" or page == "fishing" and "Fishing empty list help"
            or page == "blacklist" and "Blacklist empty list help" or "Whitelist empty list help"
        self:Text(L[emptyHelp])
        return
    end
    local gutter, columnWidth = self:GridMetrics()
    local firstY = self.y
    local rowHeight, rowGap = 42, 6
    for index, item in ipairs(items) do
        local row = self:Acquire("listItem")
        if not row.Background then
            row:EnableMouse(true)
            row.Background = row:CreateTexture(nil, "BACKGROUND")
            row.Background:SetAllPoints()
            atlas(row.Background, "Professions-recipe-header-middle", .18, .16, .12)
            row.Hover = row:CreateTexture(nil, "ARTWORK", nil, -1)
            row.Hover:SetAllPoints()
            row.Hover:SetColorTexture(.85, .75, .5, .075)
            row.Hover:Hide()
            row.Icon = row:CreateTexture(nil, "ARTWORK")
            row.Icon:SetSize(28, 28)
            row.Icon:SetPoint("LEFT", 8, 0)
            row.Remove = CreateFrame("Button", nil, row, "UIPanelCloseButton")
            row.Remove:SetSize(24, 24)
            row.Remove:SetPoint("RIGHT", -8, 0)
            row.Remove:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(REMOVE or DELETE or "Remove")
                GameTooltip:Show()
            end)
            row.Remove:SetScript("OnLeave", function() GameTooltip:Hide() end)
            row.FishTag = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            row.FishTag:SetSize(24, 24)
            row.FishTag:SetPoint("RIGHT", row.Remove, "LEFT", -4, 0)
            row.FishTag:SetText("")
            row.FishTag.Icon = row.FishTag:CreateTexture(nil, "ARTWORK")
            row.FishTag.Icon:SetPoint("TOPLEFT", 4, -4)
            row.FishTag.Icon:SetPoint("BOTTOMRIGHT", -4, 4)
            row.FishTag.Icon:SetTexture("Interface\\Icons\\INV_Misc_Fish_02")
            row.FishTag:SetScript("OnLeave", function() GameTooltip:Hide() end)
            row.Label:ClearAllPoints()
            row.Label:SetPoint("LEFT", row.Icon, "RIGHT", 9, 0)
            row.Label:SetFontObject("GameFontHighlight")
            row.Label:SetWordWrap(false)
        end
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", index % 2 == 1 and 16 or 16 + columnWidth + gutter,
            -firstY - math.floor((index - 1) / 2) * (rowHeight + rowGap))
        row:SetSize(columnWidth, rowHeight)
        row.Hover:Hide()
        row.Icon:SetTexture(item.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
        local canTagFish = page == "whitelist" or page == "fishing"
        row.FishTag:SetShown(canTagFish)
        row.FishTag:SetEnabled(item.id ~= nil)
        row.FishTag:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(page == "fishing" and L["Remove fish tag"] or L["Mark as fish"])
            GameTooltip:Show()
        end)
        row.FishTag:SetScript("OnClick", function()
            if not item.id or saved[item.key] == nil then return end
            if page == "fishing" then
                fishItems[item.id] = nil
            else
                fishItems[item.id] = true
            end
            self:QueueRefresh()
        end)
        row.Label:ClearAllPoints()
        row.Label:SetPoint("LEFT", row.Icon, "RIGHT", 8, 0)
        row.Label:SetPoint("RIGHT", canTagFish and row.FishTag or row.Remove, "LEFT", -8, 0)
        row.Label:SetText(item.name)
        if item.quality ~= nil and GetItemQualityColor then
            local r, g, b = GetItemQualityColor(item.quality)
            row.Label:SetTextColor(r, g, b)
        elseif type(item.link) == "string" and item.link:match("|cff%x%x%x%x%x%x") then
            local r, g, b = item.link:match("|cff(%x%x)(%x%x)(%x%x)")
            row.Label:SetTextColor(tonumber(r, 16) / 255, tonumber(g, 16) / 255, tonumber(b, 16) / 255)
        else
            row.Label:SetTextColor(1, .82, 0)
        end
        row.Remove:SetScript("OnClick", function()
            if saved[item.key] == nil then return end
            ListHelper.RemoveItem(item.key, saved)
            local module = addon:GetModule(config.module, true)
            if module then module:UpdateState() end
            self:QueueRefresh()
        end)
        row:SetScript("OnEnter", function(self)
            self.Hover:Show()
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            if type(item.link) == "string" and item.link:find("|Hitem:") then
                GameTooltip:SetHyperlink(item.link)
            elseif item.id and GameTooltip.SetItemByID then
                GameTooltip:SetItemByID(item.id)
            else
                GameTooltip:SetText(item.name)
            end
            GameTooltip:Show()
        end)
        row:SetScript("OnLeave", function(self) self.Hover:Hide(); GameTooltip:Hide() end)
    end
    self.y = firstY + math.ceil(#items / 2) * (rowHeight + rowGap)
end

-- AceConfig's price label is derived from the saved value. During a slider
-- drag the saved value intentionally stays untouched, so format the preview
-- from the pending slider value instead.
local function rangeLabel(info, value)
    if info[#info] == "price" and GetMoneyString then
        return GetMoneyString(value)
    end
    return read(info, "name")
end

function UI:GridMetrics()
    local gutter = 18
    return gutter, math.floor((self.content.Child:GetWidth() - 32 - gutter) / 2)
end

function UI:ToggleGrid(entries, rightShift)
    local gutter = 18
    local availableWidth = self.content.Child:GetWidth() - 32 - (rightShift or 0)
    local columnWidth = math.floor((availableWidth - gutter) / 2)
    local startY, leftY, rightY = self.y, self.y, self.y
    for index, entry in ipairs(entries) do
        local left = (index % 2 == 1) and (16 + (rightShift or 0)) or (16 + (rightShift or 0) + columnWidth + gutter)
        local rowY = (index % 2 == 1) and leftY or rightY
        local height = self:Toggle(entry.info, entry.key, entry.text, left, rowY, columnWidth)
        if index % 2 == 1 then leftY = leftY + height else rightY = rightY + height end
    end
    self.y = math.max(leftY, rightY, startY)
end

function UI:Action(info, left, top, width)
    local kind = info.option.type
    local row = self:Acquire(kind)
    row.Label:Hide()
    if left then
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", left, -top)
        row:SetWidth(width)
        row.Control:SetWidth(width)
    else
        row.Control:SetWidth(280)
    end
    row.Control:SetText(read(info, "name"))
    if info[1] == "type" and info[#info] == "none" then
        row.Control:SetText(LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)["Clear selection"])
    end
    row.Control:SetEnabled(not read(info, "disabled"))
    row.Control:SetScript("OnClick", function()
        if kind == "group" then self:Select(info) else self:Apply(info, "func") end
    end)
    tooltip(row.Control, info)
    row:SetHeight(34)
    if not top then self.y = self.y + 34 end
    return 34
end

function UI:ActionGrid(entries)
    local gutter, columnWidth = self:GridMetrics()
    local startY, leftY, rightY = self.y, self.y, self.y
    for index, info in ipairs(entries) do
        local left = (index % 2 == 1) and 16 or (16 + columnWidth + gutter)
        local rowY = (index % 2 == 1) and leftY or rightY
        local height = self:Action(info, left, rowY, columnWidth)
        if index % 2 == 1 then leftY = leftY + height else rightY = rightY + height end
    end
    self.y = math.max(leftY, rightY, startY)
end

function UI:RenderMulti(info, valuesOverride, title)
    self.y = self.y + 10
    self:Text(title or read(info, "name"), true)
    local entries, values = {}, valuesOverride or read(info, "values") or {}
    for _, key in ipairs(keys(values)) do
        entries[#entries + 1] = { info = info, key = key, text = values[key] }
    end
    self:ToggleGrid(entries)
end

function UI:RenderChildren(children)
    local index = 1
    while index <= #children do
        local child, kind = children[index], children[index].option.type
        if kind == "toggle" then
            local entries = {}
            while index <= #children and children[index].option.type == "toggle" do
                entries[#entries + 1] = { info = children[index] }
                index = index + 1
            end
            self:ToggleGrid(entries)
        elseif kind == "group" and not child.option.inline then
            local groups = {}
            while index <= #children and children[index].option.type == "group" and not children[index].option.inline do
                groups[#groups + 1] = children[index]
                index = index + 1
            end
            self:ActionGrid(groups)
        else
            self:Render(child)
            index = index + 1
        end
    end
end

function UI:Render(info, centered)
    local option, kind = info.option, info.option.type
    if kind == "group" and option.inline then
        self.y = self.y + 12
        self:Text(read(info, "name"), true)
        self:RenderChildren(ordered(option.args, info))
    elseif kind == "description" or kind == "header" then
        self:Text(read(info, "name"), kind == "header")
    elseif kind == "toggle" then
        self:Toggle(info)
    elseif kind == "multiselect" then
        self:RenderMulti(info)
    elseif kind == "execute" or kind == "group" then
        self:Action(info)
    elseif kind == "input" or kind == "range" then
        local row = self:Acquire(kind)
        local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)
        row.Apply:SetText(itemLists[self.path[1]] and info[#info] == "add" and L["Add"]
            or info[1] == "profile" and info[#info] == "new" and L["Create"] or OKAY)
        local compactPrice = kind == "range" and info[#info] == "price"
        row.Label:SetText(kind == "range" and rangeLabel(info, read(info, "get") or option.min) or read(info, "name"))
        local edit = row.Control
        edit:ClearFocus()
        edit:SetText(tostring(read(info, "get") or ""))
        local enabled = not read(info, "disabled")
        local labelHeight = math.max(18, row.Label:GetStringHeight())
        edit:ClearAllPoints()
        edit:Show()
        row.Apply:Show()
        if compactPrice then
            edit:Hide()
            row.Apply:Hide()
            row.Label:ClearAllPoints()
            row.Label:SetJustifyH("CENTER")
        elseif centered and kind == "range" then
            row.Label:ClearAllPoints()
            row.Label:SetPoint("TOPLEFT", 0, -2)
            row.Label:SetJustifyH("CENTER")
            edit:SetPoint("TOP", row, "TOP", -43, -labelHeight - 7)
        else
            row.Label:ClearAllPoints()
            row.Label:SetPoint("TOPLEFT", 0, -2)
            row.Label:SetJustifyH("LEFT")
            edit:SetPoint("TOPLEFT", 6, -labelHeight - 7)
        end
        edit:SetEnabled(enabled)
        row.Apply:SetEnabled(enabled)
        local function submit()
            local value = compactPrice and row.Slider:GetValue() or edit:GetText()
            if kind == "range" then
                value = tonumber(value)
                if not value then return end
                value = math.max(option.min, math.min(option.max, value))
                value = math.floor(value / (option.step or 1) + .5) * (option.step or 1)
            end
            edit:ClearFocus()
            self:Apply(info, "set", value)
        end
        edit:SetScript("OnEnterPressed", submit)
        row.Apply:SetScript("OnClick", submit)
        edit:SetScript("OnReceiveDrag", function()
            local cursor, id, link = GetCursorInfo()
            if cursor == "item" and kind == "input" and enabled then
                edit:SetText(link or tostring(id))
                ClearCursor()
                submit()
            end
        end)
        tooltip(edit, info)
        if kind == "range" then
            local slider = row.Slider
            slider:ClearAllPoints()
            slider:Show()
            if compactPrice then
                slider:SetWidth(480)
                slider:SetPoint("TOP", row, "TOP", 0, -6)
                row.Label:SetPoint("TOP", slider, "BOTTOM", 0, -8)
                if not row.MinLabel then
                    row.MinLabel = label(row, "GameFontDisableSmall")
                    row.MaxLabel = label(row, "GameFontDisableSmall")
                    row.MinLabel:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 0, -8)
                    row.MaxLabel:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT", 0, -8)
                end
                row.MinLabel:SetText(tostring(option.min))
                row.MaxLabel:SetText(GetMoneyString(option.softMax or option.max))
                row.MinLabel:Show()
                row.MaxLabel:Show()
            elseif centered then
                slider:SetWidth(420)
                slider:SetPoint("TOP", row, "TOP", 0, -labelHeight - 47)
            else
                slider:SetWidth(420)
                slider:SetPoint("TOPLEFT", 5, -labelHeight - 47)
            end
            slider:SetScript("OnValueChanged", nil)
            slider:SetMinMaxValues(option.min, option.softMax or option.max)
            slider:SetValueStep(option.step or 1)
            slider:SetValue(read(info, "get") or option.min)
            slider:SetEnabled(enabled)
            slider:SetScript("OnValueChanged", function(_, value, userInput)
                if userInput then
                    if not compactPrice then edit:SetText(tostring(math.floor(value + .5))) end
                    row.Label:SetText(rangeLabel(info, value))
                end
            end)
            slider:SetScript("OnMouseUp", submit)
            tooltip(slider, info)
            if not compactPrice and row.MinLabel then row.MinLabel:Hide(); row.MaxLabel:Hide() end
        end
        row:SetHeight(compactPrice and 62 or labelHeight + (kind == "range" and 82 or 48))
        self.y = self.y + row:GetHeight()
    elseif kind == "select" then
        local row = self:Acquire(kind)
        row.Label:SetText(read(info, "name"))
        local values = read(info, "values") or {}
        local sound = option.arg and option.arg.soundPreview
        local soundLabels = sound and option.arg.soundLabels and option.arg.soundLabels() or {}
        local dropdown = row.Control
        local labelHeight = math.max(18, row.Label:GetStringHeight())
        dropdown:ClearAllPoints()
        dropdown:SetPoint("TOPLEFT", 0, -labelHeight - 7)
        dropdown:SetEnabled(not read(info, "disabled") and next(values) ~= nil)
        local selectedValue = read(info, "get")
        local selectedText = selectedValue and values[selectedValue]
        if sound then
            selectedText = values[selectedValue] and (soundLabels[selectedValue] or tostring(selectedValue)) or nil
            if not selectedText then
                for name, path in pairs(values) do if path == selectedValue then selectedText = soundLabels[name] or tostring(name); break end end
            end
            selectedText = selectedText or LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)["Custom sound"]
        end
        dropdown:SetDefaultText(selectedText or read(info, "name"))
        dropdown:SetupMenu(function(_, root)
            root:SetScrollMode(320)
            for _, key in ipairs(option.valueOrder or keys(values)) do
                local text = sound and (soundLabels[key] or tostring(key)) or values[key]
                local function choose()
                    self:Apply(info, "set", key)
                end
                if read(info, "get") ~= nil and read(info, "get") ~= false then
                    root:CreateRadio(text, function() return read(info, "get") == key or (sound and values[key] == read(info, "get")) end, choose)
                else
                    root:CreateButton(text, choose)
                end
            end
        end)
        tooltip(dropdown, info)
        if sound then
            if not row.Preview then
                row.Preview = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
                row.Preview:SetSize(82, 24)
                row.Preview:SetPoint("LEFT", dropdown, "RIGHT", 8, 0)
            end
            row.Preview:SetText(LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)["Preview"])
            row.Preview:SetEnabled(selectedValue ~= nil and selectedValue ~= false)
            row.Preview:SetScript("OnClick", function()
                local selected = read(info, "get")
                if option.arg.playSound then option.arg.playSound(selected); return end
                local path = values[selected] or selected
                if (type(path) == "string" and path ~= "") or type(path) == "number" then PlaySoundFile(path, "Master") end
            end)
            row.Preview:Show()
        elseif row.Preview then row.Preview:Hide() end
        row:SetHeight(labelHeight + 48)
        self.y = self.y + row:GetHeight()
    end
end

-- The old Ace view placed the main switches, price and rarity together. Keep
-- that information architecture, while giving the dense controls a balanced
-- Retail-style two-column layout.
local generalToggleOrder = {
    enable = 1, auctionatorIntegration = 2,
    autoConfirmRoll = 3, close = 4,
    lootEarly = 5, ignoreBop = 6,
    lootAll = 7, lootQuest = 8,
    showMinimap = 9,
}
function UI:RenderGeneral(info)
    local toggles, price, rarity, remaining = {}, nil, nil, {}
    for _, child in ipairs(ordered(info.option.args, info)) do
        if child.option.type == "toggle" then
            toggles[#toggles + 1] = child
        elseif child[#child] == "priceGroup" and child.option.args and child.option.args.price then
            price = infoFor(childPath(child, "price"))
        elseif child[#child] == "rarity" and child.option.type == "multiselect" then
            rarity = child
        else
            remaining[#remaining + 1] = child
        end
    end

    -- Fix column positions by option key, independent of translated labels.
    table.sort(toggles, function(a, b)
        local ak, bk = a[#a], b[#b]
        local ao, bo = generalToggleOrder[ak] or 100, generalToggleOrder[bk] or 100
        if ao ~= bo then return ao < bo end
        return ak < bk
    end)
    local toggleEntries = {}
    for _, child in ipairs(toggles) do toggleEntries[#toggleEntries + 1] = { info = child } end
    self:ToggleGrid(toggleEntries)
    if addon.db.profile.lootAll then
        self:Text(LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)["Loot all status"])
    end
    self.y = self.y + 14

    if price then
        self:Text(read(infoFor({ "general", "priceGroup" }), "name"), true)
        self:Render(price, true)
        self.y = self.y + 10
    end

    if rarity then
        self:Text(read(rarity, "name"), true)
        local entries, values = {}, read(rarity, "values") or {}
        for _, key in ipairs(keys(values)) do entries[#entries + 1] = { info = rarity, key = key, text = values[key] } end
        self:ToggleGrid(entries, 40)
        self.y = self.y + 8
    end

    self:RenderChildren(remaining)
end

function UI:Select(path)
    self.path = { unpack(path) }
    for i = 1, #path - 1 do self.expanded[table.concat(path, "\001", 1, i)] = true end
    self.content:SetVerticalScroll(0)
    self:Refresh()
end

function UI:RenderType(info)
    local categories = {}
    for _, child in ipairs(ordered(info.option.args, info)) do
        if child.option.type == "group" and not child.option.inline then categories[#categories + 1] = child end
    end
    local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)
    if info.option.args.ignoreGreys then self:Toggle(infoFor({ "type", "ignoreGreys" })) end
    self.y = self.y + 10
    local selected
    for _, category in ipairs(categories) do
        if category[#category] == self.selectedItemCategory then selected = category; break end
    end
    selected = selected or categories[1]
    if selected then
        self.selectedItemCategory = selected[#selected]
        local row = self:Acquire("select")
        row.Label:SetText(L["Item category"])
        row.Control:ClearAllPoints()
        row.Control:SetPoint("TOPLEFT", 0, -25)
        row.Control:SetEnabled(true)
        row.Control:SetDefaultText(L["Item category"])
        row.Control:SetScript("OnEnter", nil)
        row.Control:SetScript("OnLeave", nil)
        row.Control:SetupMenu(function(_, root)
            root:SetScrollMode(320)
            for _, category in ipairs(categories) do
                local key = category[#category]
                local name = tostring(read(category, "name")):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
                root:CreateRadio(name, function() return self.selectedItemCategory == key end, function()
                    self.selectedItemCategory = key
                    self.content:SetVerticalScroll(0)
                    self:QueueRefresh()
                end)
            end
        end)
        row:SetHeight(64)
        self.y = self.y + 64
        local actions = {}
        for _, child in ipairs(ordered(selected.option.args, selected)) do
            if child.option.type == "execute" then actions[#actions + 1] = child else self:Render(child) end
        end
        self:ActionGrid(actions)
    end
    self.y = self.y + 16
    local maintenance = self:Acquire("execute")
    maintenance.Label:Hide()
    maintenance.Control:SetText((self.typeMaintenance and "- " or "+ ") .. L["Advanced options"])
    maintenance.Control:SetWidth(280)
    maintenance.Control:SetEnabled(true)
    maintenance.Control:SetScript("OnEnter", nil)
    maintenance.Control:SetScript("OnLeave", nil)
    maintenance.Control:SetScript("OnClick", function()
        self.typeMaintenance = not self.typeMaintenance
        self:QueueRefresh()
    end)
    maintenance:SetHeight(34)
    self.y = self.y + 34
    if self.typeMaintenance then
        local actions = {}
        for _, key in ipairs({ "removeAll", "removeOld" }) do
            if info.option.args[key] then actions[#actions + 1] = infoFor({ "type", key }) end
        end
        self:ActionGrid(actions)
        if info.option.args.oldEntries then self:RenderMulti(infoFor({ "type", "oldEntries" })) end
    end
end

function UI:RenderListPage(info)
    local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)
    self:Text(L["List add instructions"])
    for _, child in ipairs(ordered(info.option.args, self.path)) do
        if child[#child] ~= "info" and child[#child] ~= "remove" then self:Render(child) end
    end
end

function UI:RenderFishing()
    local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)
    local gate = addon:GetModule("FishingIgnore")
    local fishing = addon:GetModule("Fishing")
    local values = { general = L["Use general filters"], all = L["Loot everything while Fishing"],
        whitelist = L["Loot only whitelisted items while Fishing"], none = L["Don't loot anything while Fishing"] }
    local info = { "fishing", "mode", option = {
        type = "select", name = L["Fishing mode"], values = values,
        valueOrder = { "general", "all", "whitelist", "none" },
        get = function()
            if gate.db.profile.enableModule then return "none" end
            if gate.db.profile.lootWhitelistOnly then return "whitelist" end
            if fishing.db.profile.enableFishingLoot then return "all" end
            return "general"
        end,
        set = function(_, value)
            if value == "general" then
                gate:SetFishingMode("none", false)
                gate:SetFishingMode("whitelist", false)
                gate:SetFishingMode("all", false)
            else gate:SetFishingMode(value, true) end
        end,
        desc = L["Fishing mode help"],
    } }
    self:Render(info)
    self:Text(L["Fishing mode help"])
end

function UI:RenderChat(info)
    local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)
    local args = info.option.args
    if args.printoutChatFrame then
        local target = infoFor({ "chat", "printoutChatFrame" })
        local values = {}
        for key, name in pairs(read(target, "values") or {}) do
            local normalized = tostring(name):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):lower()
            if normalized ~= "voice" and normalized ~= "combat log"
                and name ~= VOICE_CHAT and name ~= COMBAT_LOG then values[key] = name end
        end
        self:RenderMulti(target, values, L["Destinations"])
    end
    self:Text(L["Messages"], true)
    local messages = {}
    for _, key in ipairs({ "printout", "printLoginCommands" }) do
        if args[key] then messages[#messages + 1] = { info = infoFor({ "chat", key }) } end
    end
    if args.chatLootGroup then
        for _, key in ipairs({ "printItemsYouReceive", "printItemsOthersReceive" }) do
            if args.chatLootGroup.args[key] then
                messages[#messages + 1] = { info = infoFor({ "chat", "chatLootGroup", key }) }
            end
        end
    end
    self:ToggleGrid(messages)
    if args.chatLootGroup and args.chatLootGroup.args.printItemsReceivedDelay then
        self:Render(infoFor({ "chat", "chatLootGroup", "printItemsReceivedDelay" }))
    end
    self:Text(L["Format"], true)
    local formats = {}
    for _, key in ipairs({ "printoutIconOnly", "printoutReason" }) do
        if args[key] then formats[#formats + 1] = { info = infoFor({ "chat", key }) } end
    end
    self:ToggleGrid(formats)
end

function UI:RenderProfiles(info)
    local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)
    local profileNames = { choose = "Existing profiles", new = "New profile", copyfrom = "Copy from profile",
        reset = "Reset profile", delete = "Delete profile" }
    local function renderProfileOption(key)
        local child = infoFor({ "profile", key })
        -- Keep AceDB callbacks intact while translating only this native view.
        child.option = setmetatable({ name = L[profileNames[key]], desc = false,
            confirm = key == "delete" and L["Delete profile confirmation"] or child.option.confirm }, { __index = child.option })
        self:Render(child)
    end
    self:Text(L["Profile"] .. ": |cffffd100" .. addon.db:GetCurrentProfile() .. "|r")
    local localization = PRIVATE_TABLE.Localization
    local languageValues = { client = L["Client Language"] }
    for code, name in pairs(localization.languages) do languageValues[code] = name end
    self:Render({ "profile", "language", option = {
        type = "select", name = L["Addon Language"], values = languageValues,
        valueOrder = localization.order, desc = L["Addon language help"],
        get = function()
            local value = addon.db.global.language
            return localization:IsSupportedPreference(value) and value or "client"
        end,
        set = function(_, value)
            if localization:IsSupportedPreference(value) then addon.db.global.language = value end
        end,
    } })
    self:Render({ "profile", "applyLanguage", option = {
        type = "execute", name = L["Apply language and reload UI"],
        disabled = function() return not localization:RequiresReload(addon.db.global.language) end,
        func = function() ReloadUI() end,
    } })
    for _, key in ipairs({ "choose", "new", "copyfrom" }) do
        if info.option.args[key] then renderProfileOption(key) end
    end
    self.y = self.y + 10
    local row = self:Acquire("execute")
    row.Label:Hide()
    row.Control:SetWidth(280)
    row.Control:SetText((self.profileMaintenance and "- " or "+ ") .. L["Profile maintenance"])
    row.Control:SetEnabled(true)
    row.Control:SetScript("OnEnter", nil)
    row.Control:SetScript("OnLeave", nil)
    row.Control:SetScript("OnClick", function()
        self.profileMaintenance = not self.profileMaintenance
        self:QueueRefresh()
    end)
    row:SetHeight(34)
    self.y = self.y + 34
    if self.profileMaintenance then
        self:Text(L["Profile maintenance help"])
        for _, key in ipairs({ "reset", "delete" }) do
            if info.option.args[key] then renderProfileOption(key) end
        end
    end
end

function UI:Navigation()
    for _, row in ipairs(self.rows) do row:Hide() end
    self.navHeaders = self.navHeaders or {}
    for _, header in pairs(self.navHeaders) do header:Hide() end
    local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)
    local sections = {
        { name = L["Settings"], keys = { "general", "alertlist", "chat" } },
        { name = L["Item lists"], keys = { "whitelist", "blacklist" } },
        { name = L["Other options"], keys = { "fishing", "type", "profile" } },
    }
    local index, y = 0, 4
    local rootOrder = { "general", "alertlist", "whitelist", "blacklist", "chat", "fishing", "type", "profile", "debug" }
    local function navigationChildren(group, path)
        if #path > 0 then return ordered(group.args, path) end
        local result, seen = {}, {}
        for _, key in ipairs(rootOrder) do
            if key ~= "debug" and group.args[key] then
                local info = infoFor(childPath(path, key))
                if visible(info) then
                    result[#result + 1], seen[key] = info, true
                end
            end
        end
        -- Future modules stay reachable without changing the curated order.
        for _, info in ipairs(ordered(group.args, path)) do
            local key = info[#info]
            if not seen[key] and key ~= "debug" then result[#result + 1] = info end
        end
        return result
    end
    local function addGroups(path, depth, supplied)
        local group = infoFor(path).option
        for _, info in ipairs(supplied or navigationChildren(group, path)) do
            if info.option.type == "group" and not info.option.inline then
                index = index + 1
                local row = self.rows[index]
                if not row then
                    row = CreateFrame("Button", nil, self.nav.Child, "SettingsCategoryListButtonTemplate")
                    row:SetHeight(28)
                    -- Keep the native category art, with AutoLooter's own state.
                    -- Blizzard's handlers expect SettingsPanel category objects.
                    row:SetScript("OnEnter", nil)
                    row:SetScript("OnLeave", nil)
                    row:SetScript("OnMouseDown", nil)
                    row:SetScript("OnMouseUp", nil)
                    row.Selected = row.Texture
                    row.Selected:ClearAllPoints()
                    row.Selected:SetAllPoints()
                    atlas(row.Selected, "Options_List_Active", .45, .33, .10, .8)
                    local hover = row:CreateTexture(nil, "HIGHLIGHT")
                    hover:SetAllPoints()
                    atlas(hover, "Options_List_Hover", .6, .5, .25, .2)
                    row.Toggle:ClearAllPoints()
                    row.Toggle:SetPoint("LEFT", 7, 0)
                    row.Label:SetWordWrap(false)
                    self.rows[index] = row
                end
                local id = table.concat(info, "\001")
                local children = false
                for _, child in pairs(info.option.args) do
                    if info[1] ~= "type" and child.type == "group" and not child.inline then children = true; break end
                end
                row:ClearAllPoints()
                row:SetPoint("TOPLEFT", depth * 12, -y)
                row:SetWidth(self.nav.Child:GetWidth() - depth * 12)
                row.Label:ClearAllPoints()
                row.Label:SetPoint("LEFT", 34, 0)
                row.Label:SetPoint("RIGHT", -8, 0)
                row.Label:SetText(read(info, "name"))
                local selected = id == table.concat(self.path, "\001")
                row.Selected:SetShown(selected)
                row.Label:SetFontObject((selected or depth > 0) and "GameFontHighlight" or "GameFontNormal")
                row.Toggle:SetShown(children)
                local toggleArt = self.expanded[id] and "UI-MinusButton" or "UI-PlusButton"
                row.Toggle:SetNormalTexture("Interface\\Buttons\\" .. toggleArt .. "-UP")
                row.Toggle:SetPushedTexture("Interface\\Buttons\\" .. toggleArt .. "-DOWN")
                row.Toggle:SetScript("OnClick", function()
                    self.expanded[id] = not self.expanded[id]
                    self:Select(info)
                end)
                row:SetScript("OnClick", function()
                    if children then self.expanded[id] = not self.expanded[id] end
                    self:Select(info)
                end)
                row:Show()
                y = y + 30
                if children and self.expanded[id] then addGroups(info, depth + 1) end
            end
        end
    end
    local seen = {}
    for sectionIndex, section in ipairs(sections) do
        local groups = {}
        for _, key in ipairs(section.keys) do
            if addon.options.args[key] then
                local info = infoFor({ key })
                if visible(info) then groups[#groups + 1] = info; seen[key] = true end
            end
        end
        if #groups > 0 then
            local header = self.navHeaders[sectionIndex]
            if not header then
                header = CreateFrame("Frame", nil, self.nav.Child, "SettingsCategoryListHeaderTemplate")
                header.Background:ClearAllPoints()
                header.Background:SetPoint("TOPLEFT", header, "TOPLEFT", 0, 0)
                -- Use the same native size and text placement as Settings.
                header.Background:SetAtlas("Options_CategoryHeader_" .. (((sectionIndex - 1) % 3) + 1), true)
                header.Label:ClearAllPoints()
                header.Label:SetPoint("LEFT", 20, -1)
                header.Label:SetPoint("RIGHT", -6, 0)
                header.Label:SetFontObject("GameFontHighlightMedium")
                self.navHeaders[sectionIndex] = header
            end
            y = y + (sectionIndex == 1 and 0 or 12)
            header:ClearAllPoints()
            header:SetPoint("TOPLEFT", 0, -y)
            local headerWidth = self.nav.Child:GetWidth()
            header.Background:SetScale(1)
            -- Keep native height, but never extend past the inner divider.
            header.Background:SetWidth(math.min(header.Background:GetWidth(), headerWidth))
            header:SetSize(headerWidth, 30)
            header.Label:SetText(section.name)
            header:Show()
            y = y + 34
            addGroups({}, 0, groups)
        end
    end
    local extra = {}
    for _, info in ipairs(ordered(addon.options.args, {})) do
        if not seen[info[#info]] and info[#info] ~= "debug" then extra[#extra + 1] = info end
    end
    if #extra > 0 then addGroups({}, 0, extra) end
    self.nav.Child:SetHeight(math.max(y, self.nav:GetHeight()))
end

function UI:Refresh()
    for _, pool in pairs(self.pool) do for _, row in ipairs(pool) do row:Hide() end end
    self.used, self.y = {}, 8
    self:Navigation()
    local info = infoFor(self.path)
    self.title:SetText(read(info, "name"))
    self.profile:SetText(addon.db:GetCurrentProfile())
    local listPage = #self.path == 1 and itemLists[self.path[1]] and self.path[1]
    if not listPage then self.unresolvedListItemIds = nil end
    if #self.path == 1 and self.path[1] == "general" then
        self:RenderGeneral(info)
    elseif #self.path == 1 and self.path[1] == "type" then
        self:RenderType(info)
    elseif #self.path == 1 and self.path[1] == "fishing" then
        self:RenderFishing()
    elseif #self.path == 1 and self.path[1] == "chat" then
        self:RenderChat(info)
    elseif #self.path == 1 and self.path[1] == "profile" then
        self:RenderProfiles(info)
    elseif listPage then
        self:RenderListPage(info)
    else
        self:RenderChildren(ordered(info.option.args, self.path))
    end
    if listPage then self:RenderListItems(listPage) end
    self.content.Child:SetHeight(math.max(self.y + 12, self.content:GetHeight()))
    self.content:UpdateScrollChildRect()
    self.content:SetVerticalScroll(math.min(self.content:GetVerticalScroll(), self.content:GetVerticalScrollRange()))
    self.content:UpdateBarVisibility()
end

function UI:Create()
    local frame = CreateFrame("Frame", "AutoLooterNativeOptionsFrame", UIParent, "SettingsFrameTemplate")
    self.frame = frame
    frame:Hide()
    -- Preserve native horizontal margins and corner artwork while reducing
    -- the empty space below the controls. Only the straight middle stretches.
    local innerFrame = frame:CreateTexture(nil, "OVERLAY", nil, 2)
    innerFrame:SetAtlas("Options_InnerFrame", true)
    local innerWidth, nativeHeight = innerFrame:GetWidth(), innerFrame:GetHeight()
    local frameWidth = innerWidth + 34
    local frameHeight = math.min(nativeHeight + 86, 620)
    local innerHeight, capHeight = frameHeight - 86, 12
    local coordinates = { innerFrame:GetTexCoord() }
    local function segment(texture, offset, height, startRatio, endRatio)
        texture:SetPoint("TOPLEFT", frame, "TOPLEFT", 17, -42 - offset)
        texture:SetSize(innerWidth, height)
        local function interpolate(a, b, ratio) return a + (b - a) * ratio end
        texture:SetTexCoord(
            interpolate(coordinates[1], coordinates[3], startRatio), interpolate(coordinates[2], coordinates[4], startRatio),
            interpolate(coordinates[1], coordinates[3], endRatio), interpolate(coordinates[2], coordinates[4], endRatio),
            interpolate(coordinates[5], coordinates[7], startRatio), interpolate(coordinates[6], coordinates[8], startRatio),
            interpolate(coordinates[5], coordinates[7], endRatio), interpolate(coordinates[6], coordinates[8], endRatio))
    end
    segment(innerFrame, 0, capHeight, 0, capHeight / nativeHeight)
    local middle = frame:CreateTexture(nil, "OVERLAY", nil, 2)
    middle:SetAtlas("Options_InnerFrame", true)
    segment(middle, capHeight, innerHeight - capHeight * 2, capHeight / nativeHeight, 1 - capHeight / nativeHeight)
    local bottom = frame:CreateTexture(nil, "OVERLAY", nil, 2)
    bottom:SetAtlas("Options_InnerFrame", true)
    segment(bottom, innerHeight - capHeight, capHeight, 1 - capHeight / nativeHeight, 1)
    -- Keep the Blizzard background artwork, with less scenery showing through.
    local backgroundBase = frame.Bg:CreateTexture(nil, "BACKGROUND", nil, -8)
    backgroundBase:SetAllPoints()
    backgroundBase:SetColorTexture(.025, .02, .015, .8)
    frame:SetSize(frameWidth, frameHeight)
    frame:SetScale(math.min(1, (UIParent:GetWidth() - 40) / frameWidth, (UIParent:GetHeight() - 40) / frameHeight))
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame.NineSlice.Text:SetText("AutoLooter")
    -- This standalone window closes directly, including during combat.
    frame.ClosePanelButton:SetScript("OnClick", function() frame:Hide() end)
    table.insert(UISpecialFrames, "AutoLooterNativeOptionsFrame")

    local left = CreateFrame("Frame", nil, frame)
    left:SetPoint("TOPLEFT", 18, -54)
    left:SetPoint("BOTTOMLEFT", 18, 46)
    left:SetWidth(199)
    self.nav = CreateFrame("Frame", nil, left)
    self.nav:SetPoint("TOPLEFT", 0, 0)
    self.nav:SetPoint("BOTTOMRIGHT", 0, 0)
    self.nav.Child = CreateFrame("Frame", nil, self.nav)
    self.nav.Child:SetPoint("TOPLEFT", self.nav, "TOPLEFT", 0, 0)
    self.nav.Child:SetPoint("TOPRIGHT", self.nav, "TOPRIGHT", 0, 0)

    local right = CreateFrame("Frame", nil, frame)
    right:SetPoint("TOPLEFT", left, "TOPRIGHT", 16, 0)
    right:SetPoint("BOTTOMRIGHT", -22, 47)
    -- Both columns share the inherited Settings background.
    self.title = label(right, "GameFontNormalLarge")
    self.title:SetPoint("TOPLEFT", 18, -15)
    self.title:SetPoint("RIGHT", -20, 0)
    self.content = scrollArea(right)
    self.content:SetPoint("TOPLEFT", 4, -46)
    self.content:SetPoint("BOTTOMRIGHT", -24, 8)
    local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)
    local profileCaption = label(frame, "GameFontDisableSmall")
    profileCaption:SetText(L["Profile"] .. ":")
    profileCaption:SetPoint("BOTTOMLEFT", 24, 16)
    self.profile = label(frame, "GameFontHighlightSmall")
    self.profile:SetPoint("LEFT", profileCaption, "RIGHT", 5, 0)
    local close = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    close:SetSize(110, 24)
    close:SetPoint("BOTTOMRIGHT", -15, 9)
    close:SetText(CLOSE)
    close:SetScript("OnClick", function() frame:Hide() end)
    frame:SetScript("OnShow", function()
        self.requestedListItemIds = {}
        self:Refresh()
    end)
    frame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
    frame:RegisterEvent("ITEM_DATA_LOAD_RESULT")
    frame:SetScript("OnEvent", function(_, _, itemID, success)
        local page = self.path[1]
        if success and frame:IsShown() and itemLists[page]
            and self.unresolvedListItemIds and self.unresolvedListItemIds[itemID] then
            self:QueueListRefresh(page)
        end
    end)
    frame:SetScript("OnHide", function()
        GameTooltip:Hide()
        for _, kind in ipairs({ "input", "range" }) do
            for _, row in ipairs(self.pool[kind] or {}) do row.Control:ClearFocus() end
        end
    end)
    self.path = { "general" }
    self.nav.Child:SetWidth(self.nav:GetWidth())
    self.content.Child:SetWidth(self.content:GetWidth())

    hooksecurefunc("ChatEdit_InsertLink", function(link)
        if not frame:IsShown() then return end
        for _, row in ipairs(self.pool.input or {}) do
            if row:IsShown() and row.Control:HasFocus() then row.Control:Insert(link); return end
        end
    end)
    LibStub("AceConfigRegistry-3.0").RegisterCallback(self, "ConfigTableChange", function(_, name)
        if name == ADDON_NAME then self:QueueRefresh() end
    end)
    for _, event in ipairs({ "OnProfileChanged", "OnProfileCopied", "OnProfileReset" }) do
        addon.db.RegisterCallback(self, event, function()
            self.requestedListItemIds = {}
            self:QueueRefresh()
        end)
    end
end

function addon:OpenOptions()
    if not SettingsCategoryListButtonMixin and C_AddOns and C_AddOns.LoadAddOn then
        C_AddOns.LoadAddOn("Blizzard_Settings_Shared")
    end
    if not supported() or not SettingsCategoryListButtonMixin then
        UIErrorsFrame:AddMessage("AutoLooter: native options API unavailable", 1, .2, .2)
        return
    end
    if not UI.frame then UI:Create() end
    UI.frame:Show()
    UI:Refresh()
end

function addon:ToggleOptions()
    if UI.frame and UI.frame:IsShown() then UI.frame:Hide(); return end
    self:OpenOptions()
end

function addon:RegisterOptionsPanel()
    local panel = CreateFrame("Frame")
    panel.name = ADDON_NAME
    local title = label(panel, "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("AutoLooter")
    local button = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    button:SetSize(260, 28)
    button:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -20)
    button:SetText(LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)["Show/Hide UI"])
    button:SetScript("OnClick", function() self:ToggleOptions() end)
    if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
        Settings.RegisterAddOnCategory(Settings.RegisterCanvasLayoutCategory(panel, ADDON_NAME))
    elseif InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(panel)
    end
    self.optionsFrame = panel
end

