// -----------------------------------------------------------------------------
// af_mtalent_succ_scream.nss
// -----------------------------------------------------------------------------
/*
    Script for MONSTER_SUCCUBUS_SCREAM talent
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

            break;
        }

        case EVENT_TYPE_SPELLSCRIPT_IMPACT:
        {
            // Get a structure with the event parameters
            struct EventSpellScriptImpactStruct stEvent = Events_GetEventSpellScriptImpactParameters(ev);

            Log_Trace(LOG_CHANNEL_COMBAT_ABILITY, GetCurrentScriptName() + ".EVENT_TYPE_SPELLSCRIPT_IMPACT",Log_GetAbilityNameById(stEvent.nAbility));

            // Handle impact
             float fDamage = GetLevel(stEvent.oCaster) * MONSTER_SUCCUBUS_SCREAM_BASE_DAMAGE;

            effect eStun = EffectStun();
            ApplyEffectVisualEffect(stEvent.oCaster, stEvent.oCaster, MONSTER_SUCCUBUS_SCREAM_AOE_VFX, EFFECT_DURATION_TYPE_INSTANT, 0.0, stEvent.nAbility);

            // apply damage to targets
            object [] oTargets = GetObjectsInShape(OBJECT_TYPE_CREATURE, SHAPE_SPHERE, GetLocation(stEvent.oCaster), MONSTER_SUCCUBUS_SCREAM_RADIUS);
            int nCount = 0;
            int nNum = GetArraySize(oTargets);
            for (nCount = 0; nCount < nNum; nCount++)
            {
                // aoe doesn't harm itself or allies
                if (GetGroupId(oTargets[nCount]) != GetGroupId(stEvent.oCaster))
                {
                    Effects_ApplyInstantEffectDamage(oTargets[nCount], stEvent.oCaster, fDamage, DAMAGE_TYPE_SPIRIT, DAMAGE_EFFECT_FLAG_NONE, stEvent.nAbility);
                    ApplyEffectVisualEffect(stEvent.oCaster, oTargets[nCount], MONSTER_SUCCUBUS_SCREAM_CRUST_VFX, EFFECT_DURATION_TYPE_INSTANT, 0.0);

                    // mental resistance
                    if (ResistanceCheck(stEvent.oCaster, stEvent.oTarget, PROPERTY_ATTRIBUTE_SPELLPOWER, RESISTANCE_MENTAL) == FALSE)
                    {
                        float fDuration = GetRankAdjustedEffectDuration(oTargets[nCount], MONSTER_SUCCUBUS_SCREAM_STUN_DURATION);

                        // remove stacking effects
                        RemoveStackingEffects(oTargets[nCount], stEvent.oCaster, stEvent.nAbility);

                        ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eStun, oTargets[nCount], fDuration, stEvent.oCaster, stEvent.nAbility);
                    }
                }
            }

            SendEventOnCastAt(stEvent.oTarget,stEvent.oCaster, stEvent.nAbility, TRUE);

            break;
        }
    }
}