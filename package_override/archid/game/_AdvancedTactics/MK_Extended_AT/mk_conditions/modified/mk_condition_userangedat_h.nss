#ifndef MK_CONDITION_USING_RANGED_WEAPON_AT_RANGE_H
#defsym MK_CONDITION_USING_RANGED_WEAPON_AT_RANGE_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_subcond_useattacktype_h"

/* MkBot */
#include "mk_constants_h"
#include "mk_constants_ai_h"

#include "mk_get_creatures_h"
#include "mk_cond_tools_h"
#include "mk_condition_atrange_h"

#include "mk_print_to_log_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _MK_AI_Condition_UsingRangedWeaponsAtRange(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nRange);

//==============================================================================
//                                DEFINITIONS
//==============================================================================
object _MK_AI_Condition_UsingRangedWeaponsAtRange(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nRange)
{
    object[] arTargets;
    int nSize;
    int i;

    int nAttackType = AI_ATTACK_TYPE_RANGED | AI_ATTACK_TYPE_MAGIC;

    switch (nTargetType)
    {
        case AI_TARGET_TYPE_ENEMY:
        case AT_TARGET_TYPE_TARGET:
        case MK_TARGET_TYPE_SAVED_ENEMY:
        case AI_TARGET_TYPE_MOST_HATED:
        {
            arTargets = _MK_AI_GetEnemiesFromTargetType(nTargetType);
            nSize = GetArraySize(arTargets);

            for (i = 0; i < nSize; i++)
            {
                if (_AT_AI_IsEnemyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE
                &&  _MK_AI_IsSleepRoot(arTargets[i]) == FALSE
                &&  _AT_AI_SubCondition_UsingAttackType(arTargets[i], nAttackType) == TRUE
                &&  _MK_AI_SubCondition_AtRange(arTargets[i], nRange) == TRUE)
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
            arTargets = _MK_AI_GetFollowersFromTargetType(nTargetType, nTacticID);
            nSize = GetArraySize(arTargets);

            for (i = 0; i < nSize; i++)
            {
                if (_MK_AI_IsFriendValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE
                &&  _AT_AI_SubCondition_UsingAttackType(arTargets[i], nAttackType) == TRUE
                &&  _MK_AI_SubCondition_AtRange(arTargets[i], nRange) == TRUE)
                    return arTargets[i];
            }

            break;
        }
        
        default:
        {
            string sMsg = "[_MK_AI_Condition_UsingRangedWeaponsAtRange] ERROR: Unknown Target Type = " + IntToString(nTargetType);
            DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
            MK_PrintToLog(sMsg);
        }
    }

    return OBJECT_INVALID;
}
#endif
