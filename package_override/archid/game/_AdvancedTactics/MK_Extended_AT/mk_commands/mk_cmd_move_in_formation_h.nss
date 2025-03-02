#ifndef MK_COMMAND_MOVE_IN_FORMATION_H
#defsym MK_COMMAND_MOVE_IN_FORMATION_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* MkBot */
#include "mk_constants_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
command MK_CommandMoveToObjectInFormation(object oTarget);

//==============================================================================
//                                DEFINITIONS
//==============================================================================
command MK_CommandMoveToObjectInFormation(object oTarget)
{
    return CommandMoveToObject(oTarget, TRUE, 0.0, FALSE, MK_RANGE_SHORT);
}

//void main(){MK_CommandMoveToObjectInFormation(OBJECT_SELF);}
#endif
