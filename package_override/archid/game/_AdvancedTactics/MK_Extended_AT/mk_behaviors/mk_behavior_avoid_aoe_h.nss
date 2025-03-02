#ifndef MK_BEHAVIOR_AVOID_AOE_H
#defsym MK_BEHAVIOR_AVOID_AOE_H

//==============================================================================
//                            INCLUDES
//==============================================================================
// Core
#include "ai_behaviors_h"

// MkBot
#include "mk_cmd_avoid_aoe_h"
#include "mk_cmd_invalid_h"

//==============================================================================
//                          DECLARATIONS
//==============================================================================
command MK_BehaviorAvoidAOE();

//==============================================================================
//                          DEFINITIONS
//==============================================================================
command MK_BehaviorAvoidAOE()
{
    if (AI_BehaviorCheck_AvoidAOE() == TRUE && 
        GetLocalInt(OBJECT_SELF, AI_FLAG_STATIONARY) != AI_STATIONARY_STATE_HARD)
    {
        return MK_CommandAvoidAOE();    
    }

    return MK_CommandInvalid();
}

//void main(){MK_BehaviorAvoidAOE();}
#endif