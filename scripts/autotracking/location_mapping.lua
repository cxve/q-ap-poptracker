-- use this file to map the AP location ids to your locations
-- first value is the code of the target location/item and the second is the item type override (feel free to expand the table with any other values you might need (i.e. special initial values, increments, etc.)!)
-- to reference a location in Pop use @ in the beginning and then path to the section (more info: https://github.com/black-sliver/PopTracker/blob/master/doc/PACKS.md#locations)
-- to reference an item use it's code
-- here are the SM locations as an example: https://github.com/Cyb3RGER/sm_ap_tracker/blob/main/scripts/autotracking/location_mapping.lua
BASE_LOCATION_ID = 1000000

local ranks = { "Silver", "Gold", "Platinum", "Diamond", "Master", "Grandmaster", "Anomaly", "Improbability", "Exploiter",
	"CHEATER" }

LOCATION_MAPPING = {
	[BASE_LOCATION_ID + 0] = { { "@Ranks/Bronze 2/" } },
	[BASE_LOCATION_ID + 1] = { { "@Ranks/Bronze 3/" } },
	[BASE_LOCATION_ID + 2] = { { "@Ranks/Bronze 4/" } },
	[BASE_LOCATION_ID + 3] = { { "@Ranks/Bronze 5/" } },
}

for r, rank in ipairs(ranks) do
	for i = 0, 4, 1 do
		LOCATION_MAPPING[BASE_LOCATION_ID + 4 + (r - 1) * 5 + i] = { { "@Ranks/" .. rank .. " " .. (i + 1) .. "/" } }
	end
end

for i = 0, 48, 1 do
	LOCATION_MAPPING[BASE_LOCATION_ID + 100 + i] = { { "@Levels/Level " .. (i + 2) .. "/" } }
end

local features = { "GAME_STORE",
	"ITEM_SHOP",
	"INCREASED_WALLET_SIZE",
	"EVEN_BIGGER_WALLET",
	"JUMBO_WALLET",
	"FULLBODY_WALLET_SUIT",
	"WORLDS_BIGGEST_WALLET",
	"ITEM_RECYCLING_SYSTEM",
	"CHALLENGES",
	"ADDITIONAL_ITEM_SLOT_1",
	"ADDITIONAL_ITEM_SLOT_2",
	"ADDITIONAL_ITEM_SLOT_3",
	"ADDITIONAL_ITEM_SLOT_4",
	"INCREASED_SHARD_SLOT_CAPACITY",
	"MAXIMUM_SHARD_SLOT_CAPACITY",
	"HONOR_DUELS",
	"ADDITIONAL_SHOP_SLOT_1",
	"ADDITIONAL_SHOP_SLOT_2",
	"ADDITIONAL_SHOP_SLOT_3",
	"ADDITIONAL_SHOP_SLOT_4",
	"ADDITIONAL_SHOP_SLOT_5",
	"QBLOCK_BREAKER_1",
	"QBLOCK_BREAKER_2",
	"QBLOCK_BREAKER_3",
	"QBLOCK_BREAKER_4",
	"QBLOCK_BREAKER_5",
	"QBLOCK_BREAKER_6",
	"QBLOCK_BREAKER_7",
	"QBLOCK_BREAKER_8",
	"QBLOCK_BREAKER_9",
	"TRICKLE_DOWN_",
	"KNOWLEDGE_TRANSFER",
	"SHOP_REROLL",
	"TURBO_SPEED",
	"EXTREMELY_COOL_SHOPS_SOMETIMES",
	"MORE_BETTERED_CHALLENGES",
	"ENHANCED_ITEM_RECYCLING__SORTING",
	"SHOP_LOCK",
	"ADDITIONAL_CHALLENGE_SLOT_1",
	"ADDITIONAL_CHALLENGE_SLOT_2",
	"NEW_BUSINESS_MODEL",
	"STATS_",
	"STATS_CHARTS",
	"LOADOUTS" }

for i, v in ipairs(features) do
	LOCATION_MAPPING[BASE_LOCATION_ID + 199 + i] = { { "@Features/" .. v .. "/" } }
end

for t=1,4,1 do
	for i=1,10,1 do
		LOCATION_MAPPING[BASE_LOCATION_ID + 299 + 10 * (t - 1) + i] = { { "@Sanity: Challenges/Tier " .. t .. "/Challenge " .. i } }
	end
end

local recycling_sets = {
	"Double Triple Set", 
	"Six of a Kind Set", 
	"Typical Set", 
	"Two by Four Set", 
	"Four of a Kind Set", 
	"PVP Set", 
	"Three Pairs Set", 
	"Timeline Saturated Set", 
	"Three of a Kind Set", 
	"Two Pairs Set"
}

for i, v in ipairs(recycling_sets) do
	LOCATION_MAPPING[BASE_LOCATION_ID + 400 + i] = { { "@Sanity: Recycling/Vanilla Sets/" .. v } }
end

for i=1,150,1 do
	LOCATION_MAPPING[BASE_LOCATION_ID + 1000 + i - 1] = { { "@Sanity: Trigger/Combo/" .. i } }
end