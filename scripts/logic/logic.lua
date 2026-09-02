-- put logic functions here using the Lua API: https://github.com/black-sliver/PopTracker/blob/master/doc/PACKS.md#lua-interface
-- don't be afraid to use custom logic functions. it will make many things a lot easier to maintain, for example by adding logging.
-- to see how this function gets called, check: locations/locations.json

local acc_no = AccessibilityLevel.None
local acc_maybe = AccessibilityLevel.SequenceBreak
local acc_yes = AccessibilityLevel.Normal

function has_difficulty_requirements_rank(num)
    local n = tonumber(num)
    if (n < 3) then return acc_yes end
    local has_item_shop = Tracker:ProviderCountForCode("item_shop")
    local has_challenges = Tracker:ProviderCountForCode("progressive_challenges")
    if ENABLE_DEBUG_LOG then print(string.format("has_item_shop: %s", has_item_shop)) end
    local pass = true
    if (n > 4 and has_item_shop < 1) then pass = false end
    if (n > 15 and has_challenges < 1) then pass = false end
    local qblock_breaker = Tracker:ProviderCountForCode("progressive_qblock_breaker")
    if (n > 51 and qblock_breaker < 9) then return acc_no end
    if (n > 44 and qblock_breaker < 8) then pass = false end
    if (n > 42 and qblock_breaker < 7) then pass = false end
    if (n > 40 and qblock_breaker < 6) then pass = false end
    if (n > 39 and qblock_breaker < 5) then pass = false end
    if (n > 38 and qblock_breaker < 4) then pass = false end
    if (n > 37 and qblock_breaker < 3) then pass = false end
    if (n > 36 and qblock_breaker < 2) then pass = false end
    if (n > 35 and qblock_breaker < 1) then pass = false end
    local count = Tracker:ProviderCountForCode('skill')
    local requirement = calculate_skill_requirement_rank(n)
    if ENABLE_DEBUG_LOG then
        print(string.format("called has_difficulty_requirements_rank: count: %s, n: %s, requirement: %s", count, n, requirement))
    end
    if count >= requirement then
        if pass then return acc_yes
        else return acc_maybe end
    elseif count + 5 >= requirement then
        return acc_maybe
    end
    return acc_no
end

function calculate_skill_requirement_rank(rank)
    local numSkills = Tracker:ProviderCountForCode('itemPoolTotalSkillNum')
    return math.min(math.floor(rank ^ 0.865 * 1.09 + 0.5), numSkills)
end

function has_difficulty_requirements_level(num)
    local n = tonumber(num)
    if n < 6 then return acc_yes end
    local requirement = calculate_skill_requirement_level(n)
    local has_challenges = Tracker:ProviderCountForCode("progressive_challenges")
    if n <= 22 and has_challenges > 0 then return acc_yes end
    local has_item_shop = Tracker:ProviderCountForCode("item_shop")
    local pass = true
    if (n > 11 and has_item_shop < 1) then pass = false end
    if (n >= 15 and has_challenges < 1) then pass = false end
    local count = Tracker:ProviderCountForCode('skill')
    if ENABLE_DEBUG_LOG then
        print(string.format("called has_difficulty_requirements_level: count: %s, n: %s, requirement: %s", count, n, requirement))
    end
    if count >= requirement then
        if pass then return acc_yes
        else return acc_maybe end
    elseif count + 5 >= requirement then
        return acc_maybe
    end
    return acc_no
end

function calculate_skill_requirement_level(level)
    local numSkills = Tracker:ProviderCountForCode('itemPoolTotalSkillNum')
    return math.min(math.floor(level ^ 0.87 * 1.16 + 0.5), numSkills)
end

local drops_crystal = {2, 6, 8, 10, 15, 8, 9, 10, 11, 25, 13, 15, 17, 19, 50, 20, 22, 24, 26, 85, 30, 32, 34, 36, 120, 40, 43, 46, 49, 150, 60, 62, 65, 70, 250}
local mail_crystal = {10, 10, 20, 20, 30, 30, 40, 40, 50, 50, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25}

function has_crystals(cost)
    local c = tonumber(cost)
    local efficiency = Tracker:ProviderCountForCode("itemPoolEfficiencyCrystals")
    local crystals_min = Tracker:ProviderCountForCode("itemPoolCrystalNum")
    local count_recycling = Tracker:ProviderCountForCode("progressive_item_recycling_system")
    local count_crystals = Tracker:ProviderCountForCode("crystals") * efficiency * (count_recycling + 1)
    local crystals = 0
    for i=1,math.min(#drops_crystal,count_crystals),1 do crystals = crystals + drops_crystal[i] end
    crystals = crystals + math.max(0, count_crystals - #drops_crystal) * 100
    for i=1,math.min(#mail_crystal,math.floor(count_crystals/2) + 2),1 do crystals = crystals + mail_crystal[i] end
    if crystals >= c or (count_crystals >= crystals_min and count_recycling > 1) then return acc_yes end
    if crystals + 0.5 * crystals >= c then return acc_maybe end
    return acc_no
end

local drops_corruption_shard = {5, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 7, 10, 10, 10, 10, 10}

function has_corruption_shards(cost)
    local c = tonumber(cost)
    local efficiency = Tracker:ProviderCountForCode("itemPoolEfficiencyCorruptionShards")
    local shards_min = Tracker:ProviderCountForCode("itemPoolCorruptionShardNum")
    local count_challenges = Tracker:ProviderCountForCode("progressive_challenges")
    local mod_challenges = 1
    if count_challenges == 2 then mod_challenges = 1.5 end
    local count_shards = Tracker:ProviderCountForCode("corruption_shards") * efficiency * mod_challenges
    local shards = 0
    for i=1,math.min(#drops_corruption_shard,count_shards),1 do shards = shards + drops_corruption_shard[i] end
    shards = shards + math.max(0, count_shards - #drops_corruption_shard) * 10
    if shards >= c or (count_shards >= shards_min and count_challenges > 1) then return acc_yes end
    if shards + 0.5 * (shards + 20) >= c then return acc_maybe end
    return acc_no
end

function has_challenge_req(num)
    local has_challenges = Tracker:ProviderCountForCode("progressive_challenges")
    if (has_challenges < 1) then
        return 0
    end
    local slots = Tracker:ProviderCountForCode("progressive_challenge_slot")
    if (slots < tonumber(num)) then
        return 0
    end
    return 1
end

local challenges = {0, 0, 0, 0}
local challengesArgs = {0, 0}

function is_challenge_available(tier, num)
    local t = tonumber(tier)
    local n = tonumber(num)
    local numChallenges = Tracker:ProviderCountForCode("sanityNumChallenges")
    local numTier4 = Tracker:ProviderCountForCode("sanityNumChallengesTier4")
    if challengesArgs[1] ~= numChallenges or challengesArgs[2] ~= numTier4 then
        challenges = {0, 0, 0, 0}
        for i=0,numChallenges - 1,1 do
            if challenges[4] < numTier4 and challenges[3] > challenges[4] + 1 then challenges[4] = challenges[4] + 1
            elseif challenges[2] > challenges[3] + 1 then challenges[3] = challenges[3] + 1
            elseif challenges[1] > challenges[2] + 1 then challenges[2] = challenges[2] + 1
            else challenges[1] = challenges[1] + 1 end
        end
        challengesArgs = {numChallenges, numTier4}
        if ENABLE_DEBUG_LOG then 
            print(string.format("Rebuilt challenge cache: %s %s %s %s", challenges[1], challenges[2], challenges[3], challenges[4])) 
        end
    end
    return challenges[t] > n - 1
end

function is_combo_enabled(num)
    local n = tonumber(num)
    if n > Tracker:ProviderCountForCode("sanityTriggerComboMax") then return false end
    if n == Tracker:ProviderCountForCode("sanityTriggerComboMax") then return true end
    if n % Tracker:ProviderCountForCode("sanityTriggerComboIncrements") == 0 then return true end
    return false
end

function has_combo_req(num)
    local n = tonumber(num)
    local numSkillsTotal = Tracker:ProviderCountForCode('itemPoolTotalSkillNum')
    local numSkills = Tracker:ProviderCountForCode("skill")
    if numSkills >= numSkillsTotal then return acc_yes end
    function calc_trigger_num(_numSkills)
        local numSkillsHalf = math.ceil(_numSkills / 2)
        local numTrigger = math.floor(_numSkills * 10 / 35)
        local numTriggerPossible = math.floor(1.4 ^ numTrigger * 6) - 6
        return numSkillsHalf + numTriggerPossible
    end
    if calc_trigger_num(numSkills) >= n then return acc_yes end
    if calc_trigger_num(numSkills + 5) >= n then return acc_maybe end
    return acc_no
end