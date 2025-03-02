#ifndef MK_CONDITION_GET_NTH_MOST_DAMAGED_ENEMIES_H
#defsym MK_CONDITION_GET_NTH_MOST_DAMAGED_ENEMIES_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"

/* MkBot */
#include "mk_constants_h"
#include "mk_constants_ai_h"

#include "mk_get_creatures_h"
#include "mk_cond_tools_h"

#include "mk_print_to_log_h"
#include "log_effect_h"
//==============================================================================
//                                CONSTANTS
//==============================================================================
const int LOWEST_HP = 0;
const int HIGHEST_HP = 1;

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object   _MK_AI_Condition_GetNthMostDamagedCreatureInGroup (int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nHighLow);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
object _MK_AI_Condition_GetNthMostDamagedCreatureInGroup(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nHighLow)
{
    object[] arTargets;
    int nSize;
    int i;

    float fCurrentHP;
    float fBestHP = -1.0f;
    object oBestTarget = OBJECT_INVALID;

    switch(nTargetType)
    {
        case AI_TARGET_TYPE_ENEMY:
        {
            arTargets = _MK_AI_GetEnemiesFromTargetType(nTargetType);
            nSize = GetArraySize(arTargets);

            if (nHighLow == LOWEST_HP)
            {
                for (i = 0; i < nSize; i++)
                {
                    if (_AT_AI_IsEnemyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE
                    &&  _MK_AI_IsSleepRoot(arTargets[i]) == FALSE)
                    {
                        fCurrentHP = GetCurrentHealth(arTargets[i]);
                        if ((fCurrentHP < fBestHP) || (fBestHP == -1.0))
                        {
                            fBestHP = fCurrentHP;
                            oBestTarget = arTargets[i];
                        }
                    }
                }
            }
            else if (nHighLow == HIGHEST_HP)
            {
                for (i = 0; i < nSize; i++)
                {
                    if (_AT_AI_IsEnemyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE
                    &&  _MK_AI_IsSleepRoot(arTargets[i]) == FALSE)
                    {
                        fCurrentHP = GetCurrentHealth(arTargets[i]);
                        if (fCurrentHP > fBestHP)
                        {
                            fBestHP = fCurrentHP;
                            oBestTarget = arTargets[i];
                        }
                    }
                }
            } 
            else
            {
                string sMsg = "[_MK_AI_Condition_GetNthMostDamagedCreatureInGroup] ERROR: Unknown ConditionParameter nHighLow = " + IntToString(nHighLow);
                DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
                MK_PrintToLog(sMsg);
            }

            break;
        }
        case MK_TARGET_TYPE_PARTY_MEMBER:
        case AI_TARGET_TYPE_ALLY:
        case MK_TARGET_TYPE_TEAMMATE:
        case MK_TARGET_TYPE_TEAM_MEMBER:
        {
            arTargets = _MK_AI_GetFollowersFromTargetType(nTargetType, nTacticID);
            nSize = GetArraySize(arTargets);

            if (nHighLow == LOWEST_HP)
            {
                for (i = 0; i < nSize; i++)
                {
                    if (_MK_AI_IsFriendValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE)
                    {
                        fCurrentHP = GetCurrentHealth(arTargets[i]);
                        if ((fCurrentHP < fBestHP) || (fBestHP == -1.0))
                        {
                            fBestHP = fCurrentHP;
                            oBestTarget = arTargets[i];
                        }
                    }
                }
            }
            else if (HIGHEST_HP == 1)
            {
                for (i = 0; i < nSize; i++)
                {
                    if (_MK_AI_IsFriendValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE)
                    {
                        fCurrentHP = GetCurrentHealth(arTargets[i]);
                        if (fCurrentHP > fBestHP)
                        {
                            fBestHP = fCurrentHP;
                            oBestTarget = arTargets[i];
                        }
                    }
                }
            }

            break;
        }
        default:
        {
            string sMsg = "[_MK_AI_Condition_GetNthMostDamagedCreatureInGroup] ERROR: Unknown Target Type = " + IntToString(nTargetType);
            DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
            MK_PrintToLog(sMsg);

            break;
        }
    }

    return oBestTarget;
}

#endif
