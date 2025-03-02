#ifndef MK_CONDITION_AT_PARY_RANGE_H
#defsym MK_CONDITION_AT_PARY_RANGE_H
//==============================================================================
//                              INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_condition_most_hated_h"

/* MkBot */
#include "mk_cond_tools_h"
#include "mk_other_h"
#include "mk_constants_ai_h"

//==============================================================================
//                              DECLARATIONS
//==============================================================================
object MK_AI_Condition_AtRangeOfParty(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nRangeID, int nFollowersTargetType);

//==============================================================================
//                              DEFINITIONS
//==============================================================================

/** @brief Brief description of function
*
*   Description of functions
*
* @param nTacticCommand       - see constants : AI_COMMAND_, AT_COMMAND_, MK_COMMAND_
* @param nTacticSubCommand    - see constants : AT_ABILITY_
* @param nTargetType          - AI_TARGET_TYPE_ENEMY, AT_TARGET_TYPE_TARGET, MK_TARGET_TYPE_SAVED_ENEMY or AI_TARGET_TYPE_MOST_HATED
* @param nTacticID            - required for AI_TARGET_TYPE_FOLLOWER to acquire follower's ID from GUI
* @param nAbilityTargetType   - see constants : TARGET_TYPE_
* @param nRangeID             - see constants : AI_RANGE_ID_
* @param nFollowersTargetType - see constants : AI_RANGE_ID_
* @returns                    - valid target if found, else OBJECT_INVALID
* @author MkBot
**/
object MK_AI_Condition_AtRangeOfParty(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nRangeID, int nFollowersTargetType)
{
    switch(nTargetType)
    {
        case AI_TARGET_TYPE_ENEMY:
        case AT_TARGET_TYPE_TARGET:
        case MK_TARGET_TYPE_SAVED_ENEMY:
        case AI_TARGET_TYPE_MOST_HATED:
        {
            float fRange = _MK_GetRangeFromID(nRangeID);

            object[] arEnemies = _MK_AI_GetEnemiesFromTargetType(nTargetType);
            int nEnemiesSize = GetArraySize(arEnemies);

            object[] arFollowers = _MK_AI_GetFollowersFromTargetType(nFollowersTargetType, nTacticID, TRUE, MK_GET_PER_FOLLOWER_FROM_CONDITION_OBJECT);
            int nFollowersSize = GetArraySize(arFollowers);

            int i;
            int j;
            for (i = 0; i < nEnemiesSize; i++)
            {
                int nIsValidTarget = _AT_AI_IsEnemyValidForAbility(arEnemies[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) &&
                                     !_MK_AI_IsSleepRoot(arEnemies[i]);
                if (nIsValidTarget == FALSE)
                    continue;

                for(j = 0; j < nFollowersSize; j++)
                {
                    float fDistance = GetDistanceBetween(arFollowers[j], arEnemies[i]);
                    if (fDistance <= fRange)
                        return arEnemies[i];
                }
            }

            break;
        }
        default:
        {
            string sMsg = "Unknown or unsupported Target Type = " + IntToString(nTargetType);
            MK_Error(nTacticID, "MK_AI_Condition_AtRangeOfParty", sMsg);

            break;
        }
    }

    return OBJECT_INVALID;
}

#endif