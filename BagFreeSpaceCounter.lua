local frame = CreateFrame( "Frame" )

local NORMAL_BAG = 0	-- Non-profession bag type ID
local numFreeSlots = -1

local BagLabel = MainMenuBarBackpackButton:CreateFontString( "BagFreeSlotLabel", "OVERLAY", "GameTooltipText" )
BagLabel:SetFont( "Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE" )
BagLabel:SetPoint( "BOTTOM", 1, 4 )
BagLabel:SetTextColor( 1, 0, 1 )


local function CountFreeSlots()

	local totalFreeSlots = 0
	for i=0, NUM_BAG_SLOTS do
		local freeCount, bagType = GetContainerNumFreeSlots( i )
		if bagType == NORMAL_BAG then
			totalFreeSlots = totalFreeSlots + freeCount
		end
	end
	
	return totalFreeSlots
end


local function UpdateBagCountLabel()

	BagLabel:SetFormattedText( "(%d)", numFreeSlots )
	--BagLabel:SetText( "(" .. numFreeSlots .. ")" )
end


local function BagChanged( self, event, bagID )

	-- BAG_UPDATE: arg1 is the ID of the modified container
	-- Ignore the bank containers
	if bagID < 0 or bagID > NUM_BAG_SLOTS then
		print( "Bank container modified" )
		return
	end	
	
	local totalFreeSlots = CountFreeSlots()
	if numFreeSlots ~= totalFreeSlots then
		numFreeSlots = totalFreeSlots
		UpdateBagCountLabel()
	end
	
end


local function Init()

	frame:SetScript( "OnEvent", BagChanged )
	frame:RegisterEvent( "BAG_UPDATE" )
	frame:RegisterEvent( "UNIT_INVENTORY_CHANGED" )	-- necessary?
end

Init()
BagChanged( nil, nil, 0 )
