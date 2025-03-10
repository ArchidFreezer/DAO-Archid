// -----------------------------------------------------------------------------
// Grease Override spell script based on code from Dheuster
// This is called in the af_ability_cast_impact event override script to handle the spellshaping ability
// Modified by Archid to reduce code duplication and generally improve readability
// -----------------------------------------------------------------------------
/*
    Area of effect that slows all creatures in it and gives them a small increase
    in mana regeneration. This version is a duplicate of the 1.01 version
    with additional checking for the Skill SpellShaping.
*/

// This must match the row in the logging_ m2da table
const int AF_LOGGROUP_GREASE = 6;

#include "aoe_effects_h"
#include "spell_constants_h"
#include "effect_dot2_h"
#include "af_spellshaping_h"
#include "af_log_h"

void main()
{
    event ev = GetCurrentEvent();
    int nEventType = GetEventType(ev); // CAST (directly from engine) or COMMAND_PENDING (re-directed by rules_core)

    switch(nEventType)
    {
        case EVENT_TYPE_SPELLSCRIPT_CAST: {
            // Get a structure with the event parameters
            struct EventSpellScriptCastStruct stEvent = Events_GetEventSpellScriptCastParameters(ev);

            AF_LogInfo("EVENT_TYPE_SPELLSCRIPT_CAST", AF_LOGGROUP_GREASE);

            // we just hand this through to cast_impact
            SetAbilityResult(stEvent.oCaster, stEvent.nResistanceCheckResult);
            break;
        }

        case EVENT_TYPE_ENTER: {
            int nAbility = GetEventInteger(ev,0);
            object oTarget = GetEventTarget(ev);
            object oCreator = GetEventCreator(ev);

            AF_LogInfo("Entering Grease: " + ToString(oTarget), AF_LOGGROUP_GREASE);

            if (IsSpellShapingTarget(oCreator, oTarget)) {
                if (!CheckSpellResistance(oTarget, oCreator, nAbility)) {
                    if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
                        ApplyAOEEffect_Grease(oTarget, oCreator, nAbility, OBJECT_SELF);
                } else {
                    UI_DisplayMessage(oTarget, UI_MESSAGE_RESISTED);
                }
            }
            break;
        }

        case EVENT_TYPE_AOE_HEARTBEAT: {
            AF_LogDebug("EVENT_TYPE_AOE_HEARTBEAT caught", AF_LOGGROUP_SPELLSHAPING);
            int nAbility = GetEventInteger(ev,0);
            object oCreator = GetEventCreator(ev);

            int nFlag = GetAOEFlags(OBJECT_SELF);
            AF_LogDebug("Grease Heartbeat " + ToString(oCreator), AF_LOGGROUP_GREASE);


            if ((nFlag & AOE_FLAG_DESTRUCTION_PENDING) == AOE_FLAG_DESTRUCTION_PENDING) {
                AF_LogDebug("Grease Heartbeat aborted, flagged for deletion", AF_LOGGROUP_GREASE);
                return;
            }

            object[] oTargets = GetCreaturesInAOE(OBJECT_SELF);
            int i;
            int nSize = GetArraySize(oTargets);
            for (i= 0; i < nSize && i < 10 /*max targets for performance reasons*/; i++) {
                if (HasDotEffectOfType(oTargets[i], DAMAGE_TYPE_FIRE)) {
                    object oIgniter = oTargets[i];

                    // Now try to figure out who created the fire in the first place
                    effect[] dot = GetDotEffectByDamageType(oTargets[i], DAMAGE_TYPE_FIRE);
                    if (GetArraySize(dot))
                        oIgniter = GetEffectCreator(dot[0]);

                    AF_LogDebug("Grease Heartbeat: Igniting grease", AF_LOGGROUP_GREASE);
                    IgniteGreaseAoe(OBJECT_SELF, oTargets[i]);

                    break;
                }
            }

            if (IsObjectValid(OBJECT_SELF))
                DelayEvent(GREASE_INTERVAL_DURATION, OBJECT_SELF, ev); // signal next heartbeat

            break;
        }
        case EVENT_TYPE_EXIT: {
            AF_LogDebug("EVENT_TYPE_EXIT caught", AF_LOGGROUP_SPELLSHAPING);
            int nAbility = GetEventInteger(ev,0);
            object oTarget = GetEventTarget(ev);
            object oCreator = GetEventCreator(ev);

            AF_LogInfo("EVENT_TYPE_EXIT " + ToString(oTarget), AF_LOGGROUP_GREASE);

            if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
                RemoveStackingEffects(oTarget, oCreator, nAbility);

            break;
        }
    }
}