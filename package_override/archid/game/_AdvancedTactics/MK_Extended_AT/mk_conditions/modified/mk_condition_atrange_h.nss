#ifndef MK_CONDITION_AT_RANGE_H
#defsym MK_CONDITION_AT_RANGE_H

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

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _MK_AI_Condition_AtRange(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nRange);
int _MK_AI_IsAtRange(object oEnemy, int nRange);
int _MK_AI_SubCondition_AtRange(object oEnemy, int nRange);
//==============================================================================
//                                DEFINITIONS
//==============================================================================
object _MK_AI_Condition_AtRange(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nRange)
{
    object[] arTargets;
    int nSize;
    int i;

    switch(nTargetType)
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
                &&  _MK_AI_IsAtRange(arTargets[i], nRange) == TRUE)
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
                &&  _MK_AI_IsAtRange(arTargets[i], nRange) == TRUE)
                    return arTargets[i];
            }

            break;
        }
        default:
        {
            string sMsg = "[_MK_AI_Condition_AtRange] ERROR: Unknown Target Type = " + IntToString(nTargetType);
            DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
            MK_PrintToLog(sMsg);

            break;
        }
    }

    return OBJECT_INVALID;
}

int _MK_AI_SubCondition_AtRange(object oEnemy, int nRange)
{
    return _MK_AI_IsAtRange(oEnemy, nRange);
}

/** @brief Check whether given enemy is at/further/between given distance(s)
*
* @param oEnemy - distance is measured between OBJECT_SELF and oEnemy.
* @param nRange - range condition ID
* @author MkBot
*/
int _MK_AI_IsAtRange(object oEnemy, int nRange)
{
    float fDistance = GetDistanceBetween(OBJECT_SELF, oEnemy);

    switch(nRange)
    {
//------ Between
        case MK_RANGE_ID_BETWEEN_SHORT_AND_MEDIUM:
        {
            if ((fDistance > AI_RANGE_SHORT)
            && (fDistance <= AI_RANGE_MEDIUM))
                return TRUE;

            break;
        }
        case MK_RANGE_ID_BETWEEN_MEDIUM_AND_LONG:
        {
            if ((fDistance > AI_RANGE_MEDIUM)
            && (fDistance <= AI_RANGE_LONG))
                return TRUE;

            break;
        }
//------ At
        case MK_RANGE_ID_AT_SHORT:
        {
            if (fDistance <= MK_RANGE_SHORT)
                return TRUE;

            break;
        }
        case MK_RANGE_ID_AT_MEDIUM:
        {
            if (fDistance <= MK_RANGE_MEDIUM)
                return TRUE;

            break;
        }
        case MK_RANGE_ID_AT_LONG:
        {
            if (fDistance <= MK_RANGE_LONG)
                return TRUE;

            break;
        }
        case MK_RANGE_ID_AT_DOUBLE_SHORT:
        {
            if (fDistance <= MK_RANGE_DOUBLE_SHORT)
                return TRUE;

            break;
        }
        case MK_RANGE_ID_AT_DOUBLE_MEDIUM:
        {
            if (fDistance <= MK_RANGE_DOUBLE_MEDIUM)
                return TRUE;

            break;
        }
        case MK_RANGE_ID_AT_BOW:
        {
            if (fDistance <= MK_RANGE_BOW)
                return TRUE;

            break;
        }
//------ Furher than
        case MK_RANGE_ID_FURTHER_THAN_SHORT: //MkBot: added in Line of Sight Condition
        {
            if ( fDistance > MK_RANGE_SHORT )
                return TRUE;
            break;
        }
        case MK_RANGE_ID_FURTHER_THAN_MEDIUM: //MkBot: added in Line of Sight Condition
        {
            if ( fDistance > MK_RANGE_MEDIUM )
                return TRUE;
            break;
        }
        case MK_RANGE_ID_FURTHER_THAN_LONG: //MkBot: added in Line of Sight Condition
        {
            if ( fDistance > MK_RANGE_LONG )
                return TRUE;
            break;
        }
        case MK_RANGE_ID_FURTHER_THAN_DOUBLE_SHORT: //MkBot: added in Line of Sight Condition
        {
            if ( fDistance > MK_RANGE_DOUBLE_SHORT )
                return TRUE;
            break;
        }
        case MK_RANGE_ID_FURTHER_THAN_DOUBLE_MEDIUM: //MkBot: added in Line of Sight Condition
        {
            if ( fDistance > MK_RANGE_DOUBLE_MEDIUM )
                return TRUE;
            break;
        }
        case MK_RANGE_ID_FURTHER_THAN_BOW: //MkBot: added in Line of Sight Condition
        {
            if ( fDistance > MK_RANGE_BOW )
                return TRUE;
            break;
        }

//------ In line of Sight
        case MK_RANGE_ID_IN_LINE_OF_SIGHT: //MkBot: added in Line of Sight Condition
        {
            if ( CheckLineOfSightObject(OBJECT_SELF, oEnemy) )
                return TRUE;
            break;
        }
    }

    return FALSE;
}

#endif