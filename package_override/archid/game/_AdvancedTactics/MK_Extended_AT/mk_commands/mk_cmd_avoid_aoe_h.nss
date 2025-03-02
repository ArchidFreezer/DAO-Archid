#ifndef MK_COMMAND_AVOID_AOE_H
#defsym MK_COMMAND_AVOID_AOE_H

//==============================================================================
//                            INCLUDES
//==============================================================================
/*Advanced Tactics*/
#include "at_tools_aoe_h"

/*MkBot*/
#include "mk_constants_ai_h"
#include "mk_cmd_invalid_h"

//==============================================================================
//                          DECLARATIONS
//==============================================================================
command MK_CommandAvoidAOE();

//==============================================================================
//                          DEFINITIONS
//==============================================================================
command MK_CommandAvoidAOE()
{
    struct aoe AOE = _AT_GetAOEOnCreature(OBJECT_SELF);
    if (_AT_IsAOEValid(AOE) == TRUE)
    {
        location lLoc = _AT_GetAvoidAOELocation(OBJECT_SELF, AOE);
        if (IsLocationValid(lLoc) == TRUE)
            return CommandMoveToLocation(lLoc);
    }
    return MK_CommandInvalid();
}

//void main(){MK_CommandAvoidAOE();}
#endif