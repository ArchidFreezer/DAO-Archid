// -----------------------------------------------------------------------------
// af_mtalent_desire_tstrike.nss
// -----------------------------------------------------------------------------
/*
    Script for ABILITY_TALENT_MONSTER_ABOMINATION_TRIPLESTRIKE_DESIRE talent
*/
// -----------------------------------------------------------------------------
// georg / petert
// -----------------------------------------------------------------------------

#include "log_h"
#include "abi_templates"
#include "sys_traps_h"

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

            effect eEffect = EffectVisualEffect(ABOMINATION_TRIPPLESTRIKE_VFX);
            ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffect, stEvent.oCaster, ABOMINATION_TRIPPLESTRIKE_DURATION, stEvent.oCaster, stEvent.nAbility);

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

            // normal combat damage
            object oWeapon  = GetItemInEquipSlot(INVENTORY_SLOT_MAIN, stEvent.oCaster);
            int nResult     = Combat_GetAttackResult(stEvent.oCaster, stEvent.oTarget, oWeapon, 0.0f, stEvent.nAbility);

            float fDamage   = Combat_Damage_GetAttackDamage(stEvent.oCaster, stEvent.oTarget, oWeapon, nResult, 0.0);

            effect eImpactEffect = EffectImpact(fDamage, oWeapon, 0, stEvent.nAbility);
            Combat_HandleAttackImpact(stEvent.oCaster, stEvent.oTarget, nResult, eImpactEffect);

            // debuf resistances
            if(stEvent.nHit == 3)
            {
                // remove stacking effects
                RemoveStackingEffects(stEvent.oTarget, stEvent.oCaster, stEvent.nAbility);

                effect eEffect = EffectDecreaseProperty(PROPERTY_ATTRIBUTE_RESISTANCE_MENTAL, ABOMINATION_RESISTANCE_PENALTY, PROPERTY_ATTRIBUTE_RESISTANCE_PHYSICAL, ABOMINATION_RESISTANCE_PENALTY);
                ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffect, stEvent.oTarget, ABOMINATION_DEBUF_DURATION, stEvent.oCaster, stEvent.nAbility);
            }

            SendEventOnCastAt(stEvent.oTarget,stEvent.oCaster, stEvent.nAbility, TRUE);

            break;
        }
    }
}