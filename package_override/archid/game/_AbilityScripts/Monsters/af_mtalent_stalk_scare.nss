// -----------------------------------------------------------------------------
// af_mtalent_stalk_scare.nss
// -----------------------------------------------------------------------------
/*
    Script for ABILITY_TALENT_MONSTER_STALKER_SCARE talent
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

            // remove stacking effects
            RemoveStackingEffects(stEvent.oTarget, stEvent.oCaster, stEvent.nAbility);

            // damage bonus, attack bonus
            effect eEffect = EffectDecreaseProperty(PROPERTY_ATTRIBUTE_ATTACK, STALKER_SCARE_ATTACK_PENALTY, PROPERTY_ATTRIBUTE_DEFENSE, STALKER_SCARE_DEFENSE_PENALTY);
            ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffect, stEvent.oTarget, STALKER_SCARE_DURATION, stEvent.oCaster, stEvent.nAbility);

            SendEventOnCastAt(stEvent.oTarget,stEvent.oCaster, stEvent.nAbility, TRUE);

            break;
        }
    }
}