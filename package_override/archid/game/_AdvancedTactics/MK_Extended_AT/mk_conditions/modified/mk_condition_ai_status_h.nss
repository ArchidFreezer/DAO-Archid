#ifndef MK_CONDITION_GET_CREATURE_WITH_AI_STATUS_H
#defsym MK_CONDITION_GET_CREATURE_WITH_AI_STATUS_H

//==============================================================================
//                              INCLUDES
//==============================================================================
/* Core */
#include "ai_main_h_2"
#include "ai_conditions_h"

/* Advanced Tactics */
#include "at_tools_ai_constants_h"
#include "at_tools_conditions_h"
#include "at_ai_conditions_nochange_h"

/* MkBot */
#include "mk_constants_h"
#include "mk_constants_ai_h"

#include "mk_get_creatures_h"
#include "mk_cond_tools_h"

#include "mk_print_to_log_h"

//==============================================================================
//                          DECLARATIONS
//==============================================================================
object _MK_AI_Condition_GetCreatureWithAIStatus(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nAIStatus);
int _MK_AI_HasAIStatus(object oCreature, int nAIStatus);

//==============================================================================
//                          DEFINITIONS
//==============================================================================

/** @brief Return creature with given AI Status
*
* If we search for Enemy then current Attack Target is prefered.
* This condition is the only one that allows us to obtain a DEAD, SLEEPING or ROOTED
* creature through AI_STATUS_DEAD, AI_STATUS_SLEEP, AI_STATUS_ROOT respectively.

* @param nTacticCommand
* @param nTacticSubCommand
* @param nTargetType
* @param nTacticID
* @param nAbilityTargetType
* @author MkBot
*/
object _MK_AI_Condition_GetCreatureWithAIStatus(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nAIStatus)
{
    int nCheckLiving = nAIStatus != AI_STATUS_DEAD;
    int nCheckSleepRoot = nCheckLiving && nAIStatus != AI_STATUS_SLEEP && nAIStatus != AI_STATUS_ROOT;

    object[] arTargets;
    int nSize;
    int i;

    switch (nTargetType)
    {
        case AI_TARGET_TYPE_ENEMY:
        case AT_TARGET_TYPE_TARGET:
        case MK_TARGET_TYPE_SAVED_ENEMY:
        case AI_TARGET_TYPE_MOST_HATED:
        {
            arTargets  = _MK_AI_GetEnemiesFromTargetType(nTargetType, nCheckLiving);
            nSize = GetArraySize(arTargets);

            for (i = 0; i < nSize; i++)
            {
                if (_AT_AI_IsEnemyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE
                &&  _MK_AI_HasAIStatus(arTargets[i], nAIStatus) == TRUE
                &&  (nCheckSleepRoot && _MK_AI_IsSleepRoot(arTargets[i])) == FALSE)
                    return arTargets[i];
            }

            break;
        }
        case MK_TARGET_TYPE_PARTY_MEMBER:
        case AI_TARGET_TYPE_ALLY:
        case MK_TARGET_TYPE_TEAMMATE:
        case MK_TARGET_TYPE_TEAM_MEMBER:
        case AI_TARGET_TYPE_SELF:
        case AI_TARGET_TYPE_HERO:
        case AI_TARGET_TYPE_FOLLOWER:
        case AI_TARGET_TYPE_MAIN_CONTROLLED:
        case MK_TARGET_TYPE_SAVED_FRIEND:
        {
            arTargets = _MK_AI_GetFollowersFromTargetType(nTargetType, nTacticID, nCheckLiving);
            nSize = GetArraySize(arTargets);

            for (i = 0; i < nSize; i++)
            {
                if (_MK_AI_IsFriendValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE
                &&  _MK_AI_HasAIStatus(arTargets[i], nAIStatus) == TRUE)
                    return arTargets[i];
            }

            break;
        }
        default:
        {
            string sMsg = "[_MK_AI_Condition_GetCreatureWithAIStatus] ERROR: Unknown Target Type = " + IntToString(nTargetType);
            DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
            MK_PrintToLog(sMsg);

            break;
        }
    }

    return OBJECT_INVALID;
}

/** @brief Check whether creature has a given AI status
*
* @param oCreature - creature to check AI Status
* @param nAIStatus - ID of AI Status to check
* @author MkBot
*/
int _MK_AI_HasAIStatus(object oCreature, int nAIStatus)
{
    return _AT_AI_HasAIStatus(oCreature, nAIStatus);
}

#endif
