// -----------------------------------------------------------------------------
// af_mtalent_canine_howl.nss
// -----------------------------------------------------------------------------
/*
    Script for ABILITY_TALENT_MONSTER_CANINE_HOWL talent
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

            //get the rank of the creature - bosses do special howl stuff
            if (GetCreatureRank(stEvent.oCaster) == CREATURE_RANK_BOSS) {
                // impact damage
                float fDamage = 3.0 * GetLevel(stEvent.oCaster);
                // defense penalty
                effect eEffectPen = EffectDecreaseProperty(PROPERTY_ATTRIBUTE_DEFENSE, CANINE_HOWL_DEFENSE_PENALTY);
                // knockdown
                effect eEffectKnockdown = EffectKnockdown(stEvent.oCaster, 0, stEvent.nAbility);
                eEffectKnockdown = SetEffectEngineInteger(eEffectKnockdown, EFFECT_INTEGER_USE_INTERPOLATION_ANGLE, 2);
                eEffectKnockdown = SetEffectEngineVector(eEffectKnockdown, EFFECT_VECTOR_ORIGIN, GetPosition(stEvent.oCaster));
                // get creatures in range
                object[] oTargets = GetObjectsInShape(OBJECT_TYPE_CREATURE, SHAPE_SPHERE, GetLocation(stEvent.oCaster), CANINE_HOWL_RADIUS);
                int nCount = 0;
                int nMax = GetArraySize(oTargets);
                for (nCount = 0; nCount < nMax; nCount++) {
                    object oTarget = oTargets[nCount];
                    if (IsObjectHostile(stEvent.oCaster, oTarget)) {
                        // mental resistance
                        if (ResistanceCheck(stEvent.oCaster, oTarget, PROPERTY_ATTRIBUTE_STRENGTH, RESISTANCE_MENTAL) == FALSE) {
                            // remove stacking effects
                            RemoveStackingEffects(oTarget, stEvent.oCaster, stEvent.nAbility);

                            // apply defense penalty
                            ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffectPen, oTarget, CANINE_HOWL_DEFENSE_PENALTY_DURATION, stEvent.oCaster, stEvent.nAbility);
                        }
                        // physical resistance
                        if (ResistanceCheck(stEvent.oCaster, oTarget, PROPERTY_ATTRIBUTE_ATTACK, RESISTANCE_PHYSICAL) == FALSE) {
                            ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffectKnockdown, oTarget, RandomFloat(), stEvent.oCaster, stEvent.nAbility);
                            //damage
                            Effects_ApplyInstantEffectDamage(oTarget, stEvent.oCaster, fDamage, DAMAGE_TYPE_PHYSICAL, DAMAGE_EFFECT_FLAG_NONE, stEvent.nAbility);

                        } else { // half damage
                            //damage
                            Effects_ApplyInstantEffectDamage(oTarget, stEvent.oCaster, fDamage * 0.5, DAMAGE_TYPE_PHYSICAL, DAMAGE_EFFECT_FLAG_NONE, stEvent.nAbility);

                        }
                    }
                }
            } else { // Not a boss
                // apply attack bonus
                effect eEffect = EffectModifyProperty(PROPERTY_ATTRIBUTE_ATTACK, CANINE_HOWL_ATTACK_BONUS);
                ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffect, stEvent.oCaster, CANINE_HOWL_ATTACK_BONUS_DURATION, stEvent.oCaster, stEvent.nAbility);

                // defense penalty
                eEffect = EffectDecreaseProperty(PROPERTY_ATTRIBUTE_DEFENSE, CANINE_HOWL_DEFENSE_PENALTY);

                // get creatures in range
                object[] oTargets = GetObjectsInShape(OBJECT_TYPE_CREATURE, SHAPE_SPHERE, GetLocation(stEvent.oCaster), CANINE_HOWL_RADIUS);
                int nCount = 0;
                int nMax = GetArraySize(oTargets);
                for (nCount = 0; nCount < nMax; nCount++) {
                    if (IsObjectHostile(stEvent.oCaster, oTargets[nCount])) {
                        // mental resistance
                        if (ResistanceCheck(stEvent.oCaster, oTargets[nCount], PROPERTY_ATTRIBUTE_STRENGTH, RESISTANCE_MENTAL) == FALSE) {
                            // remove stacking effects
                            RemoveStackingEffects(oTargets[nCount], stEvent.oCaster, stEvent.nAbility);

                            // apply defense penalty
                            ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffect, oTargets[nCount], CANINE_HOWL_DEFENSE_PENALTY_DURATION, stEvent.oCaster, stEvent.nAbility);
                        }
                    }
                }
            }

            SendEventOnCastAt(stEvent.oTarget,stEvent.oCaster, stEvent.nAbility, TRUE);

            break;
        }
    }
}