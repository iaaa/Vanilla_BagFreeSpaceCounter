local frame = CreateFrame("Frame")

local NORMAL_BAG = 0
local numFreeSlots = -1

--local BagLabel = MainMenuBarBackpackButton:CreateFontString( "BagFreeSlotLabel", "OVERLAY", "GameTooltipText" )
local BagLabel = MainMenuBarBackpackButton:CreateFontString("", "ARTWORK")
--BagLabel:SetFont( "Fonts\\FRIZQT__.TTF", 14, "THINOUTLINE" )
--BagLabel:SetFont( "Fonts\\MORPHEUS.TTF", 14, "THINOUTLINE" )
BagLabel:SetFont( "Fonts\\ARIALN.TTF", 14, "THINOUTLINE" )
BagLabel:SetPoint( "BOTTOM", 0, 3 )
BagLabel:SetTextColor( 1, 1, 1 )


function GetContainerNumFreeSlots( bag )
	local freeSlots = 0
	local bagSize = GetContainerNumSlots(bag)
	if bagSize then -- Check if the bag exists
		for slot = 1, bagSize do
			if not GetContainerItemLink(bag, slot) then
				freeSlots = freeSlots + 1
			end
		end
	end
	return freeSlots, NORMAL_BAG
end

local function CountFreeSlots( )
	local totalFreeSlots = 0
	for i = 0, NUM_BAG_SLOTS do
		local freeCount, bagType = GetContainerNumFreeSlots(i)
		if bagType == NORMAL_BAG then
			totalFreeSlots = totalFreeSlots + freeCount
		end
	end
	
	return totalFreeSlots
end


local function UpdateBagCountLabel( )
	BagLabel:SetText("(" .. numFreeSlots .. ")")
end


local function BagChanged( self, event, bagID )
	if event == "PLAYER_LOGIN" then
		numFreeSlots = CountFreeSlots()
		UpdateBagCountLabel()
		return
	end
	
	-- BAG_UPDATE: arg1 is the ID of the modified container
	-- Ignore the bank containers
--	if bagID < 0 or bagID > NUM_BAG_SLOTS then
--		return
--	end	
	
	local totalFreeSlots = CountFreeSlots()
	if numFreeSlots ~= totalFreeSlots then
		numFreeSlots = totalFreeSlots
		UpdateBagCountLabel()
	end
end


local function Init( )
	frame:SetScript("OnEvent", BagChanged)
	frame:RegisterEvent("BAG_UPDATE")
	--frame:RegisterEvent( "UNIT_INVENTORY_CHANGED" )	-- necessary?
	frame:RegisterEvent("PLAYER_LOGIN")
end

-- main ---------------
Init()
BagChanged(nil, nil, 0)
