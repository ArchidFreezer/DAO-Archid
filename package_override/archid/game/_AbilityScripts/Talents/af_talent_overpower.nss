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
    int nResult = Combat_GetAttackResult(stEvent.oCaster, stEvent.oTarget, oWeapon, 0.0f, stEvent.nAbility);
    if (IsCombatHit(nResult) == TRUE) {
        // automatic critical
        nResult = COMBAT_RESULT_CRITICALHIT;

        // shield mastery bonus
        int bMaximum = HasAbility(stEvent.oCaster, ABILITY_TALENT_SHIELD_MASTERY);

        // normal damage
        float fDamage = Combat_Damage_GetAttackDamage(stEvent.oCaster, stEvent.oTarget, oWeapon, nResult, 0.0, bMaximum);
        effect eEffect = EffectImpact(fDamage, oWeapon,0, stEvent.nAbility);
        Combat_HandleAttackImpact(stEvent.oCaster, stEvent.oTarget, nResult, eEffect);

        if (stEvent.nHit == 3) {
            // physical resistance
            if (ResistanceCheck(stEvent.oCaster, stEvent.oTarget, PROPERTY_ATTRIBUTE_STRENGTH, RESISTANCE_PHYSICAL) == FALSE) {
                // remove stacking effects
                RemoveStackingEffects(stEvent.oTarget, stEvent.oCaster, stEvent.nAbility);

                // knockdown
                eEffect = EffectKnockdown(stEvent.oCaster, 0, stEvent.nAbility);
                if (IsHumanoid(stEvent.oTarget) == TRUE) {
                    eEffect = SetEffectEngineFloat(eEffect, EFFECT_FLOAT_KNOCKBACK_DISTANCE, -0.05f);
                } else {
                    eEffect = SetEffectEngineInteger(eEffect, EFFECT_INTEGER_DONT_INTERPOLATE, TRUE);
                }
                ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffect, stEvent.oTarget, RandomFloat(), stEvent.oCaster, stEvent.nAbility);

                // daze
                eEffect = EffectDaze();
                ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffect, stEvent.oTarget, OVERPOWER_DURATION, stEvent.oCaster, stEvent.nAbility);
            }
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