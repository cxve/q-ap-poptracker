-- put logic functions here using the Lua API: https://github.com/black-sliver/PopTracker/blob/master/doc/PACKS.md#lua-interface
-- don't be afraid to use custom logic functions. it will make many things a lot easier to maintain, for example by adding logging.
-- to see how this function gets called, check: locations/locations.json

local acc_no = AccessibilityLevel.None
local acc_maybe = AccessibilityLevel.SequenceBreak
local acc_yes = AccessibilityLevel.Normal

function has_difficulty_requirements_rank(num)
    local n = tonumber(num)
    if (n < 2) then
        return acc_yes
    end
    local has_item_shop = Tracker:ProviderCountForCode("item_shop")
    if ENABLE_DEBUG_LOG then
        print(string.format("has_item_shop: %s", has_item_shop))
    end
    local pass = true
    if (n > 4 and has_item_shop < 1) then
        pass = false
    end
    local qblock_breaker = Tracker:ProviderCountForCode("progressive_qblock_breaker")
    if (n > 52 and qblock_breaker < 9) then
        return acc_no
    end
    if (n > 48 and qblock_breaker < 8) then
        return acc_no
    end
    if (n > 46 and qblock_breaker < 7) then
        return acc_no
    end
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
    if n < 4 then
        return acc_yes
    end
    local has_challenges = Tracker:ProviderCountForCode("progressive_challenges")
    if n <= 20 and has_challenges > 0 then
        return acc_yes
    end
    local has_item_shop = Tracker:ProviderCountForCode("item_shop")
    local pass = true
    if (n > 11 and has_item_shop < 1) then
        pass = false
    end
    local count = Tracker:ProviderCountForCode('skill')
    local requirement = calculate_skill_requirement_level(n)
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

function has_crystals(depth)
    local d = tonumber(depth)
    local efficiency = Tracker:ProviderCountForCode("itemPoolEfficiencyCrystals")
    local crystals = Tracker:ProviderCountForCode("crystals")
    return crystals * efficiency > d * 2
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