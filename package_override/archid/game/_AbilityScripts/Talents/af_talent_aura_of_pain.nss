#include "abi_templates"
#include "talent_constants_h"
#include "plt_tut_modal"

// add effects
void _ActivateModalAbility(struct EventSpellScriptImpactStruct stEvent)
{
    effect[] eEffects;
    event eHeartbeat;

    if(IsFollower(stEvent.oCaster)) {
        WR_SetPlotFlag(PLT_TUT_MODAL, TUT_MODAL_1, TRUE);
    }

        eEffects[0] = EffectModifyProperty(PROPERTY_ATTRIBUTE_REGENERATION_HEALTH, PAIN_HEALTH_REGENERATION_PENALTY,
                                                                             PROPERTY_ATTRIBUTE_REGENERATION_HEALTH_COMBAT, PAIN_HEALTH_REGENERATION_PENALTY);
        eEffects[1] = EffectAreaOfEffect(PAIN_AOE, R"talent_aura_of_pain.ncs", PAIN_AOE_VFX);

    int nVfx = Ability_GetImpactObjectVfxId(stEvent.nAbility);
    eEffects[0] = SetEffectEngineInteger(eEffects[0], EFFECT_INTEGER_VFX, nVfx);
    Ability_ApplyUpkeepEffects(stEvent.oCaster, stEvent.nAbility, eEffects, stEvent.oTarget);

    if (IsEventValid(eHeartbeat))
        DelayEvent(2.0, stEvent.oTarget, eHeartbeat, "talent_aura_of_pain");
}

// remove effects
void _DeactivateModalAbility(object oCaster, int nAbility) {
    Effects_RemoveUpkeepEffect(oCaster, nAbility);
}

void main()
{
    event ev = GetCurrentEvent();
    int nEventType = GetEventType(ev);

    switch(nEventType)
    {
        case EVENT_TYPE_SPELLSCRIPT_PENDING:
        {
            // hand through
            Ability_SetSpellscriptPendingEventResult(COMMAND_RESULT_SUCCESS);

            break;
        }

        case EVENT_TYPE_SPELLSCRIPT_CAST:
        {
            // Get a structure with the event parameters
            struct EventSpellScriptCastStruct stEvent = Events_GetEventSpellScriptCastParameters(ev);

            // we just hand this through to cast_impact
            SetAbilityResult(stEvent.oCaster, stEvent.nResistanceCheckResult);

            break;
        }

        case EVENT_TYPE_SPELLSCRIPT_IMPACT:
        {
            // Get a structure with the event parameters
            struct EventSpellScriptImpactStruct stEvent = Events_GetEventSpellScriptImpactParameters(ev);

            // Remove any previously existing effects from same spellid to avoid stacking
            Ability_PreventAbilityEffectStacking(stEvent.oTarget, stEvent.oCaster, stEvent.nAbility);

            // activate ability
            _ActivateModalAbility(stEvent);

            break;
        }

        case EVENT_TYPE_SPELLSCRIPT_DEACTIVATE:
        {
            // Get a structure with the event parameters
            struct EventSpellScriptDeactivateStruct stEvent = Events_GetEventSpellScriptDeactivateParameters(ev);

            // is ability active?
            if (IsModalAbilityActive(stEvent.oCaster, stEvent.nAbility) == TRUE)
            {
                _DeactivateModalAbility(stEvent.oCaster, stEvent.nAbility);
            }

            // Setting Return Value (abort means we aborted the ability)
            Ability_SetSpellscriptPendingEventResult(COMMAND_RESULT_INVALID);

            break;
        }

        case EVENT_TYPE_HEARTBEAT:
        {
            int nAbility = GetEventInteger(ev, 0);
            if (IsModalAbilityActive(OBJECT_SELF, nAbility)) {
                if (GetGameMode() == GM_COMBAT) {
                    Effects_ApplyInstantEffectDamage(OBJECT_SELF, OBJECT_SELF, 10.0, DAMAGE_TYPE_PLOT, 0, nAbility);
                }
                DelayEvent(2.0, OBJECT_SELF, ev, "talent_aura_of_pain");
            }
        }

        case EVENT_TYPE_AOE_HEARTBEAT:
        {
            int nAbility = GetEventInteger(ev,0);
            object oCreator = GetEventCreator(ev);

            if (IsObjectValid(OBJECT_SELF) && IsModalAbilityActive(oCreator, nAbility)) {
                // run through all creatures in AoE
                if(GetGameMode() == GM_COMBAT) {
                    object[] oTargets = GetCreaturesInAOE(OBJECT_SELF);
                    int i = 0;
                    int nMax = GetArraySize(oTargets);
                    int nVfx = Ability_GetImpactObjectVfxId(nAbility);
                    for (i = 0; i < nMax; i++) {
                        object oTarget = oTargets[i];
                        if (IsObjectHostile(oCreator, oTarget))
                            ApplyEffectDamageOverTime(oTarget, oCreator, nAbility, PAIN_INTERVAL_DAMAGE, PAIN_INTERVAL_DURATION, DAMAGE_TYPE_SPIRIT, nVfx);
                        else if (oCreator == oTarget)
                            ApplyEffectDamageOverTime(oTarget, oCreator, nAbility, PAIN_INTERVAL_DAMAGE, PAIN_INTERVAL_DURATION, DAMAGE_TYPE_PLOT, nVfx);
                    }
                }

                DelayEvent(PAIN_INTERVAL_DURATION + 0.05f, OBJECT_SELF, ev);
            }

            break;
        }
    }
}