#include "af_constants_h"
/*
* EVENT_TYPE_ATTACK_IMPACT post script
* Runs after the normal processing of the event
*
* Used by:
*   Dain's Increases Hostility and Intimidation
*/
void main()
{
    event  ev = GetCurrentEvent();
    int    nAttackResult = GetEventInteger(ev, 0);
    object oAttacker = GetEventObject(ev, 0);
    object oTarget = GetEventObject(ev, 1);

    if (nAttackResult != COMBAT_RESULT_BLOCKED && nAttackResult != COMBAT_RESULT_MISS && GetHasEffects(oAttacker, AF_EFFECT_TYPE_HOSTILITY_INTIMIDATION))
        UpdateThreatTable(oTarget, oAttacker, 5.0f);
}