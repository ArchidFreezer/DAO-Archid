#ifndef MK_BEHAVIOR_MOVE_H
#defsym MK_BEHAVIOR_MOVE_H
//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_ai_h"

/* MkBot */
#include "mk_constants_ai_h"
#include "mk_cmd_invalid_h"
#include "mk_cmd_move_in_formation_h"
#include "mk_setcommandtimeout_h"
#include "mk_get_creatures_h"
#include "mk_behavior_check_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
command MK_BehaviorMove(object oLastTarget, int nLastCommandType, int nLastCommandStatus);

command MK_ContinousMoveToNotStealthyTeamMemberNearestToEnemy(object oLastTarget, int nLastCommandType, int nLastCommandStatus);
int MK_IsMoveInProgress(object oLastTarget, int nLastCommandType, int nLastCommandStatus);
command MK_ContinueMoveTo(object oLastTarget);
command MK_MoveToNotStealthyTeamMemberNearestToEnemy();
object MK_GetNotStealthyTeamMemberNearestToEnemy();

//==============================================================================
//                                DEFINITIONS
//==============================================================================
command MK_BehaviorMove(object oLastTarget, int nLastCommandType, int nLastCommandStatus)
{   
    MK_PushToCallStackTrace("MK_BehaviorMove");
    command cResult = MK_CommandInvalid();
    
    int nTargetType = MK_BehaviorCheck_MoveTo();
    if (nTargetType == AI_TARGET_TYPE_MAIN_CONTROLLED)
    {
        cResult = _AT_AI_MoveToControlled(nLastCommandStatus);
    }
    else if (nTargetType == MK_TARGET_TYPE_TEAM_MEMBER)
    {
        cResult = MK_ContinousMoveToNotStealthyTeamMemberNearestToEnemy(oLastTarget, nLastCommandType, nLastCommandStatus);
    }
    else if (nTargetType != TARGET_TYPE_INVALID)
    {
        MK_Logger("Unsupported nTargetType = " + IntToString(nTargetType), MK_LOG_LEVEL_ERROR);
    }
    
    MK_RemoveLastFromCallStackTrace();
    return cResult;
}

/** @brief ***INTERNAL***
**/
command MK_ContinousMoveToNotStealthyTeamMemberNearestToEnemy(object oLastTarget, int nLastCommandType, int nLastCommandStatus)
{
    MK_PushToCallStackTrace("MK_ContinousMoveToNotStealthyTeamMemberNearestToEnemy");
    command cResult = MK_CommandInvalid();
    
    if (MK_IsMoveInProgress(oLastTarget, nLastCommandType, nLastCommandStatus) == TRUE)
        cResult = MK_ContinueMoveTo(oLastTarget);
    else
        cResult = MK_MoveToNotStealthyTeamMemberNearestToEnemy();

    MK_RemoveLastFromCallStackTrace();
    return cResult;
}

/** @brief ***INTERNAL***
**/
int MK_IsMoveInProgress(object oLastTarget, int nLastCommandType, int nLastCommandStatus)
{
    if (nLastCommandType == COMMAND_TYPE_MOVE_TO_OBJECT && 
        nLastCommandStatus == COMMAND_FAILED_TIMEOUT && 
        IsObjectValid(oLastTarget) == TRUE && 
        IsDead(oLastTarget) == FALSE && 
        IsDying(oLastTarget) == FALSE && 
        IsStealthy(oLastTarget) == FALSE)
    {
        return TRUE;
    }
    return FALSE;
}

/** @brief ***INTERNAL***
**/
command MK_ContinueMoveTo(object oLastTarget)
{
    MK_PushToCallStackTrace("MK_ContinueMoveTo");
    command cResult; 
    MK_Logger("Continue Move to " + ObjectToStringNameAndId(oLastTarget), MK_LOG_LEVEL_DEBUG);
    
    cResult = MK_CommandMoveToObjectInFormation(oLastTarget);
    cResult = MK_SetCommandTimeout(cResult, MK_TIMEOUT_BEHAVIOR_MOVE);
    
    MK_RemoveLastFromCallStackTrace();    
    return cResult;
}

/** @brief ***INTERNAL***
**/
command MK_MoveToNotStealthyTeamMemberNearestToEnemy()
{
    MK_PushToCallStackTrace("MK_MoveToNotStealthyTeamMemberNearestToEnemy");
    command cResult;

    object oTarget = MK_GetNotStealthyTeamMemberNearestToEnemy();    
    if (oTarget != OBJECT_SELF)
    {
        MK_Logger("Start Move to " + ObjectToStringNameAndId(oTarget), MK_LOG_LEVEL_DEBUG);
        cResult = MK_CommandMoveToObjectInFormation(oTarget);
        cResult = MK_SetCommandTimeout(cResult, MK_TIMEOUT_BEHAVIOR_MOVE);        
    }
    else
    {   
        MK_Logger("Don't Move", MK_LOG_LEVEL_DEBUG);
        cResult = _AT_AI_DoNothing(TRUE);
    }
    
    MK_RemoveLastFromCallStackTrace();    
    return cResult;    
}

/** @brief ***INTERNAL***
**/
object MK_GetNotStealthyTeamMemberNearestToEnemy()
{   
    MK_PushToCallStackTrace("MK_GetNotStealthyTeamMemberNearestToEnemy");
    
    object[] arEnemies = _MK_AI_GetEnemies(OBJECT_SELF, TRUE, TRUE);
    if (GetArraySize(arEnemies) == 0) 
    {
        MK_RemoveLastFromCallStackTrace(); 
        return OBJECT_SELF;
    }

    object oNearestToEnemy = OBJECT_SELF;
    float fNearestDistance = GetDistanceBetween(OBJECT_SELF, arEnemies[0]);

    object[] arFriends = _MK_AI_GetFollowersFromTargetType( MK_TARGET_TYPE_TEAMMATE,
                                                            MK_TACTIC_ID_INVALID,
                                                            TRUE);
    int i;
    int nSize = GetArraySize(arFriends);
    for (i = 0; i < nSize; i++)
    {
        if (IsStealthy(arFriends[i]) == TRUE)
            continue;

        object[] arEnemies = _MK_AI_GetEnemies(arFriends[i], TRUE, TRUE);
        float fDistance = GetDistanceBetween(arFriends[i], arEnemies[0]);

        if (fDistance < fNearestDistance)
        {
            oNearestToEnemy = arFriends[i];
            fNearestDistance = fDistance;
        }
    }
    
    MK_RemoveLastFromCallStackTrace(); 
    return oNearestToEnemy;
}

//void main(){MK_BehaviorMove(OBJECT_SELF,0,0);}
#endif