/*
    Advanced Tactics event script

    Listen EVENT_TYPE_COMMAND_PENDING
*/

#include "ability_h"

/* Advanced Tactics */
#include "at_tools_aoe_h"



void main()
{
    event ev = GetCurrentEvent();

    int nCommandType = GetEventInteger(ev, 0);
    int nCommandSubType = GetEventInteger(ev, 1);

    /* Advanced Tactics */
    /* AOE system */
    if (nCommandType == COMMAND_TYPE_USE_ABILITY && _AT_IsHostileAOE(nCommandSubType)) {
        struct aoe AOE = _AT_GetAOEFromEvent(ev);
        _AT_StoreAOE(AT_ARRAY_INCOMING_AOE, AOE);
    }
}
