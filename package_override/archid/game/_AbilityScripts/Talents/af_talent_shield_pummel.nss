#include "abi_templates"
#include "combat_h"
#include "talent_constants_h"

void _HandleImpact(struct EventSpellScriptImpactStruct stEvent) {

    // make sure there is a location, just in case
    if (IsObjectValid(stEvent.oTarget) == TRUE) {
        stEvent.lTarget = GetLocation(stEvent.oTarget);
    }

    // weapon on first hit, shield on subsequent
    object oWeapon;
    float fAPBonus = 0.0f;
    if (stEvent.nHit == 1) {
        oWeapon  = GetItemInEquipSlot(INVENTORY_SLOT_MAIN, stEvent.oCaster);
    } else {
        oWeapon  = GetItemInEquipSlot(INVENTORY_SLOT_OFFHAND, stEvent.oCaster);
        fAPBonus = 2.0f;
    }

    // if the attack hit
    int nResult = Combat_GetAttackResult(stEvent.oCaster, stEvent.oTarget, oWeapon, 10.0f, stEvent.nAbility);
    if (IsCombatHit(nResult) == TRUE || stEvent.nHit>1) {
        // Check if shield mastery doubles attribute bonus
        int bDoubleAttBonus = FALSE;
        if (stEvent.nHit > 1) { //shield strike only
            if (HasAbility(stEvent.oCaster, ABILITY_TALENT_SHIELD_MASTERY) == TRUE) {
                bDoubleAttBonus = TRUE;
            }
        }

        // normal damage
        float fDamage = Combat_Damage_GetAttackDamage(stEvent.oCaster, stEvent.oTarget, oWeapon, nResult, fAPBonus, FALSE, bDoubleAttBonus);

        // apply impact
        effect eEffect = EffectImpact(fDamage, oWeapon,0, stEvent.nAbility);
        Combat_HandleAttackImpact(stEvent.oCaster, stEvent.oTarget, nResult, eEffect);

        // final hit stuns
        if (stEvent.nHit == 3) {
            // physical resistance
            if (ResistanceCheck(stEvent.oCaster, stEvent.oTarget, PROPERTY_ATTRIBUTE_STRENGTH, RESISTANCE_PHYSICAL) == FALSE) {
                float fDuration = GetRankAdjustedEffectDuration(stEvent.oTarget, SHIELD_PUMMEL_DURATION);

                // remove stacking effects
                RemoveStackingEffects(stEvent.oTarget, stEvent.oCaster, stEvent.nAbility);

                // stun
                eEffect = EffectStun();
                ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffect, stEvent.oTarget, fDuration, stEvent.oCaster, stEvent.nAbility);
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