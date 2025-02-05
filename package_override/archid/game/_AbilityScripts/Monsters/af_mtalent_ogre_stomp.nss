// -----------------------------------------------------------------------------
// af_mtalent_ogre_stomp.nss
// -----------------------------------------------------------------------------
/*
    Script for ABILITY_TALENT_MONSTER_OGRE_STOMP talent
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

            PlaySoundSet(stEvent.oCaster, SS_COMBAT_ATTACK_GRUNT);

            break;
        }

        case EVENT_TYPE_SPELLSCRIPT_IMPACT:
        {
            // Get a structure with the event parameters
            struct EventSpellScriptImpactStruct stEvent = Events_GetEventSpellScriptImpactParameters(ev);

            Log_Trace(LOG_CHANNEL_COMBAT_ABILITY, GetCurrentScriptName() + ".EVENT_TYPE_SPELLSCRIPT_IMPACT",Log_GetAbilityNameById(stEvent.nAbility));

            // Apply impact vfx and screen shake
            Ability_ApplyLocationImpactVFX(stEvent.nAbility, GetLocation(stEvent.oCaster));
            ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, EffectScreenShake(SCREEN_SHAKE_TYPE_OGRE_STOMP), stEvent.oTarget, 1.0f, stEvent.oCaster, stEvent.nAbility);

            //effect   eDamage    = EffectDamage(fDamage, DAMAGE_TYPE_PHYSICAL, DAMAGE_EFFECT_FLAG_UPDATE_GORE);
            object   oWeapon    = GetItemInEquipSlot(INVENTORY_SLOT_MAIN, stEvent.oCaster);
            effect   eKnockdown = EffectKnockdown(stEvent.oCaster, OGRE_STOMP_KNOCKDOWN_DEFENSE_PENALTY, stEvent.nAbility);
            object[] arTargets  = GetObjectsInShape(OBJECT_TYPE_CREATURE, SHAPE_SPHERE, GetLocation(stEvent.oCaster), OGRE_STOMP_RADIUS);

            int i, nSize = GetArraySize(arTargets);
            for (i = 0; i < nSize; i++) {
                object oTarget = arTargets[i];
                if (oTarget == stEvent.oCaster)
                    continue;

                float fDamage = 0.75 * Combat_Damage_GetAttackDamage(stEvent.oCaster, oTarget, oWeapon, COMBAT_RESULT_HIT, 0.0);
                effect eDamage = EffectDamage(fDamage, DAMAGE_TYPE_PHYSICAL, DAMAGE_EFFECT_FLAG_UPDATE_GORE);
                ApplyEffectOnObject(EFFECT_DURATION_TYPE_INSTANT, eDamage, oTarget, 0.0, stEvent.oCaster, stEvent.nAbility);

                if (ResistanceCheck(stEvent.oCaster, oTarget, PROPERTY_ATTRIBUTE_STRENGTH, RESISTANCE_PHYSICAL) == FALSE) {
                    // 1-4 second knockdown
                    float fDuration = RandFF(3.0, 1.0);
                    ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RandFF(3.0, 1.0), stEvent.oCaster, stEvent.nAbility);
                }
            }

            SendEventOnCastAt(stEvent.oTarget,stEvent.oCaster, stEvent.nAbility, TRUE);

            break;
        }
    }
}