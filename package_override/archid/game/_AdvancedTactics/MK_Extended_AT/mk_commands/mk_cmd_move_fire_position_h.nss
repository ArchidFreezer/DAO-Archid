#ifndef MK_MOVE_TO_FIRE_POSITION_H
#defsym MK_MOVE_TO_FIRE_POSITION_H

//==============================================================================
//                              INCLUDES
//==============================================================================
#include "mk_comm_movetolineofsight_h"
#include "mk_cmd_invalid_h"
#include "mk_setcommandtimeout_h"
#include "mk_cond_tools_h"
#include "mk_constants_h"
#include "mk_constants_ai_h"


//==============================================================================
//                              CONSTANTS
//==============================================================================
const float MK_RANGE_BIAS = 5.0;

//==============================================================================
//                              DECLARATIONS
//==============================================================================
command MK_CommandMoveToFirePosition(object oTarget/*, float fRange, int nCheckLineOfSight*/);
//==============================================================================
//                              DEFINITIONS
//==============================================================================
/** @brief
*
* @param oTarget -
* @param fRange -
* @returns - {COMMAND_TYPE_INVALID} cannot find better Firing Position
*            {COMMAND_TYPE_MOVE_TO_LOCATION}
* @author MkBot
**/
command MK_CommandMoveToFirePosition(object oTarget/*, float fRange, int nCheckLineOfSight*/)
{
    command cResult;  
    /*
    if(fRange + MK_RANGE_BIAS < GetDistanceBetween(OBJECT_SELF, oTarget))
    {
        cResult = CommandMoveToObject(oTarget, TRUE, fRange);
        cResult = MK_SetCommandTimeout(cResult, MK_TIMEOUT_MOVE);
        return cResult;
    }
    */
    if (/*nCheckLineOfSight == TRUE && */CheckLineOfSightObject(OBJECT_SELF, oTarget) == FALSE)
    {
        cResult = _MK_CommandMoveToLineOfSightPositionKeepDistance(oTarget, 3.0); 
        int isFirePositionFound = MK_IsCommandValid(cResult);
        if (isFirePositionFound == FALSE)
            cResult = _MK_CommandMoveToLineOfSightPositionKeepDistance(oTarget, 6.0);
        return cResult;
    }

    return MK_CommandInvalid();
}

//void main(){MK_CommandMoveToFirePosition(OBJECT_SELF);}
#endif