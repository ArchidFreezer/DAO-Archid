/*
    Advanced Tactics event script

    Listen EVENT_TYPE_COMMAND_PENDING
*/

#include "ability_h"

/* Advanced Tactics */
/*
#include "at_ai_conditions_h"
#include "at_aoe_h"
#include "at_log_h"



void main()
{
    event ev = GetCurrentEvent();

    int nCommandType = GetEventInteger(ev, 0);
    int nCommandSubType = GetEventInteger(ev, 1);
    object oCommandOwner = GetEventObject(ev, 0);


    // Advanced Tactics
    // AOE system
    if ((nCommandType == COMMAND_TYPE_USE_ABILITY)
    && (_AT_IsHostileAOE(nCommandSubType) == TRUE))
    {
        struct aoe AOE = _AT_GetAOEFromEvent(ev);

        _AT_StoreAOE(AT_ARRAY_INCOMING_AOE, AOE);
    }

//--------------- if current command send by Tactic then    ---------------
//--------------- terminate if Target is sleeping or rooted ---------------
    if( IsFollower(oCommandOwner) )
    {
        command cCurrent = GetCurrentCommand(oCommandOwner);
        if ( GetCommandIsPlayerIssued(cCurrent) )
            return;

        if ((nCommandType == COMMAND_TYPE_ATTACK) || (nCommandType == COMMAND_TYPE_USE_ABILITY))
        {
            object oTarget = GetEventObject(ev, 1);
            int nIsRooted = _AT_AI_HasAIStatus(oTarget, AI_STATUS_ROOT);
            int nIsSleeping = _AT_AI_HasAIStatus(oTarget, AI_STATUS_SLEEP);
            if( nIsRooted || nIsSleeping )
            {
                DisplayFloatyMessage( oCommandOwner, "Target Sleeps/is Rooted", FLOATY_MESSAGE, 0xFF0000, 2.0);
                SetCommandResult(oCommandOwner, COMMAND_RESULT_INVALID);
                return;
            }
        }
    }
    HandleEvent(ev);
}       */