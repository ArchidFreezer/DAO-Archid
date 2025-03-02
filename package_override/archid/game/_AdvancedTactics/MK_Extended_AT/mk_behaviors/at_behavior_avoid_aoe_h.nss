#ifndef AT_BEHAVIOR_AVOID_AOE_H
#defsym AT_BEHAVIOR_AVOID_AOE_H

//==============================================================================
//                            INCLUDES
//==============================================================================
/*Core*/
#include "ai_behaviors_h"

/*Advanced Tactics*/
#include "at_tools_aoe_h"

/*MkBot*/
#include "mk_constants_ai_h"

//==============================================================================
//                          DECLARATIONS
//==============================================================================
command AT_BehaviorAvoidAOE();

//==============================================================================
//                          DEFINITIONS
//==============================================================================
command AT_BehaviorAvoidAOE()
{
//------------------------------------------------------------------------------
//              Advanced Tactics - Avoid AOE
//------------------------------------------------------------------------------
    command cRet;

    if ((AI_BehaviorCheck_AvoidAOE() == TRUE)
    && (GetLocalInt(OBJECT_SELF, AI_FLAG_STATIONARY) != AI_STATIONARY_STATE_HARD))
    {
        /* AOE system */
        struct aoe AOE = _AT_GetAOEOnCreature(OBJECT_SELF);

        if (_AT_IsAOEValid(AOE) == TRUE)
        {
            location lLoc = _AT_GetAvoidAOELocation(OBJECT_SELF, AOE);
            if (IsLocationValid(lLoc) == TRUE)
                cRet = CommandMoveToLocation(lLoc);
        }
    }

    return cRet;
}

//void main(){AT_BehaviorAvoidAOE();}
#endif