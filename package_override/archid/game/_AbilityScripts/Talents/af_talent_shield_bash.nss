#include "abi_templates"
#include "combat_h"
#include "talent_constants_h"

void _HandleImpact(struct EventSpellScriptImpactStruct stEvent) {

    // make sure there is a location, just in case
    if (IsObjectValid(stEvent.oTarget) == TRUE) {
        stEvent.lTarget = GetLocation(stEvent.oTarget);
    }

    object oWeapon  = GetItemInEquipSlot(INVENTORY_SLOT_OFFHAND, stEvent.oCaster);

    // if the attack hit
    int nResult = Combat_GetAttackResult(stEvent.oCaster, stEvent.oTarget, oWeapon, 10.0f, stEvent.nAbility);
    if (IsCombatHit(nResult) == TRUE) {
        // Check if shield mastery doubles attribute bonus
        int bDoubleAttBonus = FALSE;
        if (HasAbility(stEvent.oCaster, ABILITY_TALENT_SHIELD_MASTERY) == TRUE) {
            bDoubleAttBonus = TRUE;
        }

        // normal damage
        float fDamage = Combat_Damage_GetAttackDamage(stEvent.oCaster, stEvent.oTarget, oWeapon, nResult, 0.0, FALSE, bDoubleAttBonus);

        // apply impact
        effect eEffect = EffectImpact(fDamage, oWeapon,0, stEvent.nAbility);
        Combat_HandleAttackImpact(stEvent.oCaster, stEvent.oTarget, nResult, eEffect);

        // physical resistance
        if (ResistanceCheck(stEvent.oCaster, stEvent.oTarget, PROPERTY_ATTRIBUTE_STRENGTH, RESISTANCE_PHYSICAL) == FALSE) {
            // knockdown
            eEffect = EffectKnockdown(stEvent.oCaster, 0, stEvent.nAbility);
            if (IsHumanoid(stEvent.oTarget) == TRUE) {
                eEffect = SetEffectEngineFloat(eEffect, EFFECT_FLOAT_KNOCKBACK_DISTANCE, -0.05f);
            } else {
                eEffect = SetEffectEngineInteger(eEffect, EFFECT_INTEGER_DONT_INTERPOLATE, TRUE);
            }
            ApplyEffectVisualEffect(stEvent.oCaster, stEvent.oTarget, 1014, EFFECT_DURATION_TYPE_INSTANT, 0.0f, stEvent.nAbility);
            ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffect, stEvent.oTarget, RandomFloat(), stEvent.oCaster, stEvent.nAbility);
        }
    }

}

void main()
{
    event ev = GetCurrentEvent();
    int nEventType = GetEventType(ev);

    switch(nEventType) {
        case EVENT_TYPE_SPELLSCRIPT_PENDING: {
            Ability_SetSpellscriptPendingEventResult(COMMAND_RESULT_SUCCESS);
            break;
        }

        case EVENT_TYPE_SPELLSCRIPT_CAST: {
            // Get a structure with the event parameters
            struct EventSpellScriptCastStruct stEvent = Events_GetEventSpellScriptCastParameters(ev);

            // we just hand this through to cast_impact
            int nTarget = PROJECTILE_TARGET_INVALID;

            if (stEvent.nAbility ==  ABILITY_TALENT_PINNING_SHOT) {
                nTarget = Random(2)==0? PROJECTILE_TARGET_LOWERLEG_L :PROJECTILE_TARGET_LOWERLEG_R;
            }

            SetAbilityResult(stEvent.oCaster, stEvent.nResistanceCheckResult, nTarget);
            break;
        }

        case EVENT_TYPE_SPELLSCRIPT_IMPACT: {
            //--------------------------------------------------------------
            // Get a structure with the event parameters
            //--------------------------------------------------------------
            struct EventSpellScriptImpactStruct stEvent = Events_GetEventSpellScriptImpactParameters(ev);
            _HandleImpact(stEvent);
            break;
        }
    }
}