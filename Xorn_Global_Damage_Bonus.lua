-- Thick of the Fight damage bonus statuses
local xornthickOfTheFightdamagebonusStatuses = {
    ["Xorn_ThickOfTheFight_10"] = 10,
    ["Xorn_ThickOfTheFight_20"] = 20,
    ["Xorn_ThickOfTheFight_30"] = 30,
    ["Xorn_ThickOfTheFight_40"] = 40,
    ["Xorn_ThickOfTheFight_50"] = 50,
}

-- Blacklist of skills
local xornblacklist = {
    "Projectile_BouncingShield_-1",
    "Target_Xorn_Duelist_Clash_-1",
    "Projectile_Grenade_Molotov",
    "Projectile_Grenade_ArmorPiercing",
    "Projectile_Grenade_Nailbomb",
    "Projectile_Grenade_CursedMolotov",
    "Projectile_Grenade_ChemicalWarfare",
    "Projectile_Grenade_Ice",
    "Projectile_Grenade_SmokeBomb",
    "Projectile_Grenade_Tremor",
    "Projectile_Grenade_Taser",
    "Projectile_Grenade_CursedPoisonFlask",
    "Projectile_Grenade_Flashbang",
    "Projectile_Grenade_MindMaggot",
    "Projectile_Grenade_BlessedIce",
    "Projectile_Grenade_Holy",
    "Projectile_Grenade_Terror",
    "Projectile_Grenade_WaterBalloon",
    "Projectile_Grenade_WaterBlessedBalloon",
    "Projectile_Grenade_MustardGas",
    "Projectile_Grenade_OilFlask",
    "Projectile_Grenade_BlessedOilFlask",
    "Projectile_Grenade_PoisonFlask",
    "Projectile_Grenade_Flashbang_WaterBalloon",
    "Projectile_Grenade_Flashbang_PoisonFlask",
    "Projectile_Grenade_Flashbang_OilFlask",
    "Projectile_Grenade_Flashbang_Molotov",
    "Projectile_Grenade_Flashbang_Ice",
    "Projectile_Grenade_Taser_WaterBalloon",
    "Projectile_Grenade_Taser_PoisonFlask",
    "Projectile_Grenade_Taser_OilFlask",
    "Projectile_Grenade_Taser_Molotov",
    "Projectile_Grenade_Taser_Ice",
    "Projectile_Grenade_MustardGas_WaterBalloon",
    "Projectile_Grenade_MustardGas_PoisonFlask",
    "Projectile_Grenade_MustardGas_OilFlask",
    "Projectile_Grenade_MustardGas_Molotov",
    "Projectile_Grenade_MustardGas_Ice",
    "Projectile_Grenade_Nailbomb_WaterBalloon",
    "Projectile_Grenade_Nailbomb_PoisonFlask",
    "Projectile_Grenade_Nailbomb_OilFlask",
    "Projectile_Grenade_Nailbomb_Molotov",
    "Projectile_Grenade_Nailbomb_Ice",
    "Projectile_Grenade_SmokeBomb_WaterBalloon",
    "Projectile_Grenade_SmokeBomb_PoisonFlask",
    "Projectile_Grenade_SmokeBomb_OilFlask",
    "Projectile_Grenade_SmokeBomb_Molotov",
    "Projectile_Grenade_SmokeBomb_Ice",
    "ProjectileStrike_Grenade_ClusterBomb",
    "Projectile_Xorn_Launch_Frost_Trap",
    "Projectile_Xorn_Launch_Arc_Trap",
    "Projectile_Xorn_Launch_Poison_Trap",
    "Projectile_Xorn_Launch_Fire_Trap",
    "Projectile_Xorn_Launch_Shrapnel_Trap",
    "ProjectileStrike_Grenade_CursedClusterBomb",
    "Projectile_OdinHUN_SeekingArrows_Shot",
    "Projectile_Xorn_Sab_Proj_Fire",
    "Projectile_Xorn_Sab_Proj_Poison",
    "Projectile_Xorn_Sab_Proj_Water",
    "Projectile_Xorn_Sab_Proj_Earth",
    "Projectile_Xorn_Sab_Proj_Air",
    "Projectile_Xorn_Sab_Proj_Phys",
    "Projectile_Xorn_Sab_Proj_Pierce",
    "Target_Xorn_JawBreaker_-1",
    "Projectile_Xorn_Intercept_Proj",
    "Projectile_Xorn_Unstable1",
    "Projectile_Xorn_Unstable2",
    "Projectile_Xorn_Unstable3",
    "Projectile_Xorn_Bulwark_Proj",
    "Projectile_Xorn_Status_IntimidateAura",
    "ProjectileStrike_Xorn_Cowl_Blades_Proj_Return_Damage",
    "Projectile_Xorn_Venom_Dose_Proc"
}




-- Define all damage types
local xorndamageTypes = {"Physical", "Piercing", "Corrosive", "Magic", "Fire", "Water", "Air", "Earth", "Poison", "Shadow", "Chaos", "Sulfuric"}

-- Function to add bonus damage for all or specific damage types
local function addBonusDamage(esvTarget, statusHandle, damageType, bonusAmount)
    local hitdamage = NRD_HitStatusGetDamage(esvTarget.MyGuid, statusHandle, damageType)
    if hitdamage and hitdamage > 0 then
        local bonusIncrease = hitdamage * (bonusAmount / 100)
        local addAmount = Ext.Round(bonusIncrease)
        local originalDamage = hitdamage
        local finalDamage = hitdamage + addAmount
        NRD_HitStatusAddDamage(esvTarget.MyGuid, statusHandle, damageType, addAmount)
        --print(string.format("Added bonus damage from %s: %d", damageType, addAmount))
        --print("Original damage:", originalDamage)
        --print("Final damage:", finalDamage)
        return addAmount  -- Return bonus amount
    end
    return 0
end

-- Main damage calculation function
local function xornGlobalDamage(status, context)
    local esvAttacker = Ext.GetGameObject(status.StatusSourceHandle)
    local esvTarget = Ext.GetGameObject(status.TargetHandle)
    local statusHandle = status.StatusHandle

    -- Debug prints
    --print("xornGlobalDamage - StatusSourceHandle:", status.StatusSourceHandle)
    --print("xornGlobalDamage - TargetHandle:", status.TargetHandle)

    if esvAttacker and esvTarget then
        local stats = esvAttacker.Stats
        if stats then
            local skill = string.gsub(status.SkillId or "", "_%-1$", "")
            --print("xornGlobalDamage - SkillId:", skill)

            -- Check for blacklisted skills
            local isBlacklisted = false
            for _, blacklistEntry in ipairs(xornblacklist) do
                if skill == blacklistEntry then
                    isBlacklisted = true
                    break
                end
            end
            
            -- Exit if skill is blacklisted
            if isBlacklisted then
                --print("Skill is blacklisted, no bonus damage applied.")
                return
            end

            -- Thick of the Fight bonus damage
            local attackType = XornCombatGetAttackType(status, context, skill, true, true)


            if attackType == 0 then
                for statusName, damageBonus in pairs(xornthickOfTheFightdamagebonusStatuses) do
                    if esvAttacker:GetStatus(statusName) then
                        -- Apply Thick of the Fight bonus damage for all damage types
                        for _, damageType in ipairs(xorndamageTypes) do
                            addBonusDamage(esvTarget, statusHandle, damageType, damageBonus)
                        end
                        --print("Adding Thick of the Fight bonus:", damageBonus)
                    end
                end
            end

            -- Death Wish bonus damage
            if esvAttacker:GetStatus("Xorn_DeathWish_Status") and (attackType == 0 or attackType == 1) then
                local deathWishBonus = 0

                -- Necromancy bonus
                local necroRanks = stats.Necromancy or 0
                if necroRanks > 0 then
                    deathWishBonus = deathWishBonus + necroRanks * 2.5
                    --print("Adding Necromancy bonus damage:", necroRanks * 2.5)
                end

                -- Lifesteal bonus
                local lifestealValue = NRD_CharacterGetComputedStat(esvAttacker.MyGuid, "LifeSteal", 0)
                if lifestealValue > 0 then
                    deathWishBonus = deathWishBonus + lifestealValue / 2
                    --print("Adding Lifesteal bonus damage:", lifestealValue / 2)
                end

                -- Apply Deathwish bonus damage for all damage types
                for _, damageType in ipairs(xorndamageTypes) do
                    local bonusDamage = addBonusDamage(esvTarget, statusHandle, damageType, deathWishBonus)
                    if bonusDamage > 0 then
                        --print(string.format("Added Deathwish bonus damage (%s): %d", damageType, bonusDamage))
                    end
                end
            end

            -- IceBreaker bonuses (Piercing)
            if skill == "Projectile_Xorn_Ice_Breaker" then
                local STR = stats.Strength or 0
                local INT = stats.Intelligence or 0
                local FIN = stats.Finesse or 0

                local semibonusAmount = 0

                if STR >= INT and STR >= FIN then
                    semibonusAmount = (STR - 10)
                    --print("Adding IceBreaker bonus for STR:", semibonusAmount)
                elseif INT >= STR and INT >= FIN then
                    semibonusAmount = (INT - 10)
                    --print("Adding IceBreaker bonus for INT:", semibonusAmount)
                elseif FIN >= STR and FIN >= INT then
                    semibonusAmount = (FIN - 10)
                    --print("Adding IceBreaker bonus for FIN:", semibonusAmount)
                end

                -- Apply the bonus amount to all damage types
                if semibonusAmount > 0 then
                    for _, damageType in ipairs(xorndamageTypes) do
                        local SemiResult = semibonusAmount * NRD_HitStatusGetDamage(esvTarget.MyGuid, statusHandle, damageType)
                        local Result = SemiResult / 100

                        if Result > 0 then
                            addBonusDamage(esvTarget, statusHandle, damageType, Result)
                        end
                    end
                end
            end

            -- Silver Arrow bonus
            if skill == "Projectile_CharmingArrow" then
                local isZombie = esvTarget.Stats and esvTarget.Stats.TALENT_Zombie
                local isVoidwoken = esvTarget:HasTag("VOIDWOKEN")
                if isZombie or isVoidwoken then
		--print("ZOMBIES!!")
                for _, damageType in ipairs(xorndamageTypes) do
                    local currentDamage = NRD_HitStatusGetDamage(esvTarget.MyGuid, statusHandle, damageType)
                    local bonusDamage = currentDamage * 0.30  -- 30% bonus damage
                    addBonusDamage(esvTarget, statusHandle, damageType, bonusDamage)
                    --print("Applying Silver Arrow bonus damage to Physical")
                    -- Play effect for Silver Arrow
                    PlayEffect(esvTarget.MyGuid, "RS3_FX_GP_Impacts_Arena_PillarLight_01_Silver", "Dummy_Root")
                end
            end
	end

            -- Bonus damage from Soul Wave (Magic)
            if skill == "Projectile_Xorn_Soul_Wave_Magic_Wave" then
                local INT = stats.Intelligence - 10 or 0
                local STR = stats.Strength - 10 or 0
                local INTSTRAmount = INT + STR
                local INTSTRPro = INTSTRAmount * 2.5
                local INTSTRDiv = INTSTRPro / 100

                for _, damageType in ipairs(xorndamageTypes) do
                    local SemiResult = INTSTRDiv * NRD_HitStatusGetDamage(esvTarget.MyGuid, statusHandle, damageType)
                    local Result = SemiResult / 100

                    if Result > 0 then
                        addBonusDamage(esvTarget, statusHandle, damageType, Result)
                        --print("Applied bonus damage from Soul Wave (Magic)")
                    end
                end
            end

            -- Apply bonus damage for Soul Wave (Piercing)
            if skill == "Projectile_Xorn_Soul_Wave_Bleed_ProjectileP" then
                local INT = stats.Intelligence - 10 or 0
                local STR = stats.Strength - 10 or 0
                local INTSTRAmount = INT + STR
                local INTSTRPro = INTSTRAmount * 2.5
                local INTSTRDiv = INTSTRPro / 100

                for _, damageType in ipairs(xorndamageTypes) do
                    local SemiResult = INTSTRDiv * NRD_HitStatusGetDamage(esvTarget.MyGuid, statusHandle, damageType)
                    local Result = SemiResult / 100

                    if Result > 0 then
                        addBonusDamage(esvTarget, statusHandle, damageType, Result)
                        --print("Applied bonus damage from Soul Wave (Piercing)")
                    end
                end
            end

            -- Apply Fated Whisper bonus damage as Piercing
            if esvTarget:GetStatus("Xorn_Tortur_Soul2") and NRD_StatusGetInt(esvTarget.MyGuid, statusHandle, "Hit") == 1 then
                --print("Applying Fated Whisper bonus damage as Piercing")

                for _, damageType in ipairs(xorndamageTypes) do
                    local currentDamage = NRD_HitStatusGetDamage(esvTarget.MyGuid, statusHandle, damageType)
                    local bonusDamage = currentDamage * 0.15  -- 15% bonus damage as Piercing

                    if bonusDamage > 0 then
                        NRD_HitStatusAddDamage(esvTarget.MyGuid, statusHandle, "Piercing", bonusDamage)
                        --print("Applied bonus damage from Fated Whisper (Piercing)")
                    end
                end
            end

            -- Apply bonus damage from Mark of the Fang (10% lifesteal)
            if esvTarget:GetStatus("Xorn_MarkFang") and esvAttacker.MyGuid ~= esvTarget.MyGuid then
                for _, damageType in ipairs(xorndamageTypes) do
                    local bonusDamage = NRD_HitStatusGetDamage(esvTarget.MyGuid, statusHandle, damageType) * 0.1  -- 10% bonus damage

                    if bonusDamage > 0 then
                        -- Apply bonus damage as vitality
                        local addAmount = Ext.Round(bonusDamage)
                        local originalDamage = NRD_HitStatusGetDamage(esvTarget.MyGuid, statusHandle, damageType)
                        local finalDamage = originalDamage + addAmount
                        addBonusDamage(esvTarget, statusHandle, damageType, addAmount)
                        --print(string.format("Applied bonus damage from Mark of the Fang as lifesteal: %d", addAmount))

                        -- Heal the attacker
                        local currentVitality = stats.CurrentVitality or 0
                        currentVitality = math.max(currentVitality + addAmount, 0)
                        NRD_CharacterSetStatInt(esvAttacker.MyGuid, "CurrentVitality", currentVitality)

                        -- Notify in-game
                        NRD_ModCall("Strategist_Mode", "StatusText", esvAttacker.MyGuid, "<font color='#97FBFF' size='22'>", "+" .. math.floor(addAmount), "</font>")
                    end
                end
            end

            -- Apply Sawtooth Gouge bonus damage as Piercing
            if esvTarget:GetStatus("Xorn_SawKnife_Debuff") then
                for _, damageType in ipairs(xorndamageTypes) do
                    local hitdamage = NRD_HitStatusGetDamage(esvTarget.MyGuid, statusHandle, damageType)
                    local bonusDamage = hitdamage * 0.15  -- 15% bonus damage as Piercing

                    if bonusDamage > 0 then
                        NRD_HitStatusAddDamage(esvTarget.MyGuid, statusHandle, "Piercing", bonusDamage)
                        --print("Applied bonus damage from Gouge (Piercing)")
                    end
                end
            end

            -- Apply bonus damage from Vitrify Status (all damage types)
            if esvTarget:GetStatus("Xorn_Vitrify_Status") then
                for _, damageType in ipairs(xorndamageTypes) do
                    addBonusDamage(esvTarget, statusHandle, damageType, 10)  -- 10% bonus damage to all damage types
                end
            end
        end
    end
end

-- Listener for StatusHitEnter event
Ext.RegisterListener("StatusHitEnter", xornGlobalDamage)



