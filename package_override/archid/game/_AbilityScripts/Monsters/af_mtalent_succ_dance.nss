// -----------------------------------------------------------------------------
// af_mtalent_succ_dance.nss
// -----------------------------------------------------------------------------
/*
    Script for MONSTER_SUCCUBUS_DANCE talent
*/
// -----------------------------------------------------------------------------
// georg / petert
// -----------------------------------------------------------------------------

#include "log_h"
#include "abi_templates"
#include "sys_traps_h"
#include "spell_constants_h"

void main()
{
    event ev = GetCurrentEvent();
    int nEventType = GetEventType(ev);

    switch(nEventType)
    {
        case EVENT_TYPE_SPELLSCRIPT_PENDING:
        {
            struct EventSpellScriptPendingStruct stEvent = Events_GetEventSpellScriptPendingParameters(ev);

            Ability_SetSpellscriptPendingEventResult(COMMAND_RESULT_SUCCESS);

            break;
        }

        case EVENT_TYPE_SPELLSCRIPT_CAST:
        {
            // Get a structure with the event parameters
            struct EventSpellScriptCastStruct stEvent = Events_GetEventSpellScriptCastParameters(ev);

            // determine if attack hits
            object oMainWeapon = GetItemInEquipSlot(INVENTORY_SLOT_MAIN);
            struct CombatAttackResultStruct stAttack = Combat_PerformAttack(stEvent.oCaster, stEvent.oTarget, oMainWeapon,0.0f,stEvent.nAbility);

            // Hand this through to cast_impact
            SetAbilityResult(stEvent.oCaster, stEvent.nResistanceCheckResult);

            Ability_ApplyObjectImpactVFX(stEvent.nAbility, stEvent.oCaster);

            break;
        }

        case EVENT_TYPE_SPELLSCRIPT_IMPACT:
        {
            // Get a structure with the event parameters
            struct EventSpellScriptImpactStruct stEvent = Events_GetEventSpellScriptImpactParameters(ev);

            Log_Trace(LOG_CHANNEL_COMBAT_ABILITY, GetCurrentScriptName() + ".EVENT_TYPE_SPELLSCRIPT_IMPACT",Log_GetAbilityNameById(stEvent.nAbility));

            // Handle impact
            ApplyEffectVisualEffect(stEvent.oCaster, stEvent.oCaster, MONSTER_SUCCUBUS_DANCE_AOE_VFX, EFFECT_DURATION_TYPE_INSTANT, 0.0, stEvent.nAbility);

            // apply damage to targets
            object [] oTargets = GetObjectsInShape(OBJECT_TYPE_CREATURE, SHAPE_SPHERE, GetLocation(stEvent.oCaster), MONSTER_SUCCUBUS_DANCE_RADIUS);
            int nCount = 0;
            int nNum = GetArraySize(oTargets);
            object oTarget;
            for (nCount = 0; nCount < nNum; nCount++)
            {
                oTarget = oTargets[nCount];
                // aoe doesn't harm itself or allies
                if (GetGroupId(oTarget) != GetGroupId(stEvent.oCaster))
                {
                    // remove stacking effects
                    RemoveStackingEffects(oTarget, stEvent.oCaster, stEvent.nAbility);

                    ApplyEffectVisualEffect(stEvent.oCaster, oTarget, MONSTER_SUCCUBUS_DANCE_IMPACT_VFX, EFFECT_DURATION_TYPE_INSTANT, 0.0);

                    if(GetCreatureGender(oTarget) == GENDER_FEMALE) // Vulnerability hex
                    {
                        effect eEffect;
                        eEffect = EffectDecreaseProperty(PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_FIRE, MONSTER_SUCCUBUS_DEBUF_RESIST_PENALTY,
                                                         PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_COLD, MONSTER_SUCCUBUS_DEBUF_RESIST_PENALTY,
                                                         PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_ELEC, MONSTER_SUCCUBUS_DEBUF_RESIST_PENALTY);
                        eEffect = SetEffectEngineInteger(eEffect, EFFECT_INTEGER_VFX, Ability_GetImpactObjectVfxId(stEvent.nAbility));
                        ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffect, oTarget, MONSTER_SUCCUBUS_DEBUF_DURATION, stEvent.oCaster, stEvent.nAbility);

                        eEffect = EffectDecreaseProperty(PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_NATURE, MONSTER_SUCCUBUS_DEBUF_RESIST_PENALTY,
                                                         PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_SPIRIT, MONSTER_SUCCUBUS_DEBUF_RESIST_PENALTY);
                        ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffect, oTarget, MONSTER_SUCCUBUS_DEBUF_DURATION, stEvent.oCaster, stEvent.nAbility);

                        eEffect = EffectDecreaseProperty(PROPERTY_ATTRIBUTE_RESISTANCE_PHYSICAL, MONSTER_SUCCUBUS_DEBUF_RESIST_PENALTY,
                                                         PROPERTY_ATTRIBUTE_RESISTANCE_MENTAL, MONSTER_SUCCUBUS_DEBUF_RESIST_PENALTY);
                        ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffect, oTarget, MONSTER_SUCCUBUS_DEBUF_DURATION, stEvent.oCaster, stEvent.nAbility);

                        eEffect = EffectKnockdown(stEvent.oCaster, 0, stEvent.nAbility);
                        ApplyEffectOnObject(EFFECT_DURATION_TYPE_INSTANT, eEffect, oTarget, 0.0, stEvent.oCaster, stEvent.nAbility);
                    }
                    else // male/neutral -> sleep + curse of mortality
                    {
                        // mental resistance
                        if (ResistanceCheck(stEvent.oCaster, stEvent.oTarget, PROPERTY_ATTRIBUTE_SPELLPOWER, RESISTANCE_MENTAL) == FALSE)
                        {
                            float fDuration = GetRankAdjustedEffectDuration(oTarget, MONSTER_SUCCUBUS_SLEEP_DURATION);
                            ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, EffectSleep(), oTarget, fDuration, stEvent.oCaster, stEvent.nAbility);
                        }

                        effect eEffect = Effect(EFFECT_TYPE_CURSE_OF_MORTALITY);
                        eEffect = SetEffectEngineInteger(eEffect, EFFECT_INTEGER_VFX, Ability_GetImpactObjectVfxId(stEvent.nAbility));
                        ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffect, oTarget, MONSTER_SUCCUBUS_SLEEP_DURATION, stEvent.oCaster, stEvent.nAbility);

                        // health regeneration
                        eEffect = EffectDecreaseProperty(PROPERTY_ATTRIBUTE_REGENERATION_HEALTH, MONSTER_SUCCUBUS_HEALTH_DEGEN_PENALTY,
                                                         PROPERTY_ATTRIBUTE_REGENERATION_HEALTH_COMBAT, MONSTER_SUCCUBUS_HEALTH_DEGEN_PENALTY);
                        ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffect, oTarget, MONSTER_SUCCUBUS_SLEEP_DURATION, stEvent.oCaster, stEvent.nAbility);
                        
                        // spirit dot
                        ApplyEffectDamageOverTime(oTarget, stEvent.oCaster, stEvent.nAbility, MONSTER_SUCCUBUS_CURSE_DAMAGE_TOTAL, MONSTER_SUCCUBUS_SLEEP_DURATION, DAMAGE_TYPE_SPIRIT);

                    }
                }
            }

            SendEventOnCastAt(stEvent.oTarget,stEvent.oCaster, stEvent.nAbility, TRUE);

            break;
        }
    }
}