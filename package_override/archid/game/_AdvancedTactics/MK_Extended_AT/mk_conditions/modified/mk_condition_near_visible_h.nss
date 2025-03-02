#ifndef MK_CONDITION_GET_NEAREST_VISIBLE_CREATURE_H
#defsym MK_CONDITION_GET_NEAREST_VISIBLE_CREATURE_H

//==============================================================================
//                              INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"

/* MkBot */
#include "mk_constants_h"
#include "mk_constants_ai_h"

#include "mk_get_creatures_h"
#include "mk_cond_tools_h"

#include "mk_print_to_log_h"

//==============================================================================
//                          DECLARATIONS
//==============================================================================
object _MK_AI_Condition_GetNearestVisibleCreature (int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType);

//==============================================================================
//                          DEFINITIONS
//==============================================================================
object _MK_AI_Condition_GetNearestVisibleCreature(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType)
{
    object[] arTargets;
    int nSize;
    int i;

    switch(nTargetType)
    {
        case AI_TARGET_TYPE_ENEMY:
        {
            arTargets = _AT_AI_GetEnemies();
            nSize = GetArraySize(arTargets);

            for (i = 0; i < nSize; i++)
            {
                if (_AT_AI_IsEnemyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE
                &&  _MK_AI_IsSleepRoot(arTargets[i]) == FALSE)
                    return arTargets[i];
            }

            break;
        }
        /*
        //MkBot : Array of Followers is not sorted by distance to improve performance.
        case MK_TARGET_TYPE_PARTY_MEMBER:
        case AI_TARGET_TYPE_ALLY:
        case MK_TARGET_TYPE_TEAMMATE:
        case MK_TARGET_TYPE_TEAM_MEMBER:
        {
            arTargets = _MK_AI_GetFollowersFromTargetType(nTargetType, nTacticID);
            nSize = GetArraySize(arTargets);

            for (i = 0; i < nSize; i++)
            {
                if (_MK_AI_IsFriendValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE)
                    return arTargets[i];
            }

            break;
        }
        */
        default:
        {
            string sMsg = "[_MK_AI_Condition_GetNearestVisibleCreature] ERROR: Unknown Target Type = " + IntToString(nTargetType);
            DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
            MK_PrintToLog(sMsg);

            break;
        }
    }

    return OBJECT_INVALID;
}
#endif