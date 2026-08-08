-- use this file to map the AP item ids to your items
-- first value is the code of the target item and the second is the item type override. The third value is an optional increment multiplier for consumables. (feel free to expand the table with any other values you might need (i.e. special initial values, etc.)!)
-- here are the SM items as an example: https://github.com/Cyb3RGER/sm_ap_tracker/blob/main/scripts/autotracking/item_mapping.lua
BASE_ITEM_ID = 1000000
--ITEM_MAPPING = {
--	[BASE_ITEM_ID + 00000] = { { "toggle" } },
--	[BASE_ITEM_ID + 00001] = { { "progressive" } },
--	[BASE_ITEM_ID + 00002] = { { "consumable" } },
--	-- handle progressive_toggle as toggle, only changing it's active state
--	[BASE_ITEM_ID + 00003] = { { "progressive_toggle", "toggle" } },
--	-- multiple items on this id, add the consumable 3 times
--	[BASE_ITEM_ID + 00004] = { { "toggle" }, { "consumable", nil, 3 } }
--}

ITEM_MAPPING = {}
for i=0,279,1 do
	ITEM_MAPPING[BASE_ITEM_ID + i] = {{ "skill", "consumable" }}
end

for i=280,287,1 do
	ITEM_MAPPING[BASE_ITEM_ID + i] = {{ "hypernode", "consumable" }}
end

ITEM_MAPPING[BASE_ITEM_ID + 288] = {{ "gold", "consumable" }}
ITEM_MAPPING[BASE_ITEM_ID + 289] = {{ "corruption_shards", "consumable" }}
ITEM_MAPPING[BASE_ITEM_ID + 290] = {{ "crystals", "consumable" }}
ITEM_MAPPING[BASE_ITEM_ID + 291] = {{ "upgrade_points", "consumable" }}
ITEM_MAPPING[BASE_ITEM_ID + 292] = {{ "crystals", "consumable" }}

local features = {
 { "game_store", "toggle" },
 { "item_shop", "toggle" },
 { "progressive_wallet_size", "consumable" },
 { "progressive_item_recycling_system", "consumable" },
 { "progressive_challenges", "consumable" },
 { "progressive_item_slot", "consumable" },
 { "progressive_shard_slot_capacity", "consumable" },
 { "honor_duels", "toggle" },
 { "progressive_shop_slot", "consumable" },
 { "progressive_qblock_breaker", "consumable" },
 { "trickle_down", "toggle" },
 { "knowledge_transfer", "toggle" },
 { "progressive_challenge_slot", "consumable" },
 { "shop_lock", "toggle" },
 { "new_business_model", "toggle" },
 { "progressive_stats", "consumable" },
 { "loadouts", "toggle" },
 { "progressive_shop_reroll", "consumable" },
}

for i, item in ipairs(features) do
	ITEM_MAPPING[BASE_ITEM_ID + 292 + i] = {item}
end