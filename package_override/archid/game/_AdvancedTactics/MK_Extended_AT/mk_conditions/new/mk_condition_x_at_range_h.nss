#ifndef MK_CONDITION_GET_AT_LEAST_X_ENEMIES_AT_RADIUS_H
#defsym MK_CONDITION_GET_AT_LEAST_X_ENEMIES_AT_RADIUS_H

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
object _MK_AI_Condition_AtLeastXEnemiesAtRadius(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nNumOfTargets, float fRadius);
object _MK_AI_Condition_AtLeastXEnemiesAtRange(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nNumOfTargets, int nRangeId);

//==============================================================================
//                                DEFINITIONS
//==============================================================================
object _MK_AI_Condition_AtLeastXEnemiesAtRadius(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nNumOfTargets, float fRadius)
{
    float fStart = 0.0f;
    float fEnd = 360.0f;
    int nCheckLiving = TRUE;
    object oCenter;

    switch(nTargetType)
    {
        case AI_TARGET_TYPE_SELF:
        case AI_TARGET_TYPE_HERO:
        case AI_TARGET_TYPE_FOLLOWER:
        case AI_TARGET_TYPE_MAIN_CONTROLLED:
        {
            object[] arFollowers = _MK_AI_GetFollowersFromTargetType(nTargetType, nTacticID);
            oCenter = arFollowers[0];
            if (_MK_AI_IsFriendValidForAbility(oCenter, nTacticCommand, nTacticSubCommand, nAbilityTargetType) == FALSE)
                return OBJECT_INVALID; 
            
            break;
        }
        default:
        {
            string sMsg = "[_MK_AI_Condition_AtLeastXEnemiesAtRadius] ERROR: Unknown Target Type = " + IntToString(nTargetType);
            DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
            MK_PrintToLog(sMsg);

            break;
        }
    }

    object[] arTargets;
    arTargets = GetObjectsInShape(OBJECT_TYPE_CREATURE, SHAPE_SPHERE, GetLocation(oCenter), fRadius, 0.0f, 0.0f, nCheckLiving);

    int nSize = GetArraySize(arTargets);
    int nEnemiesCount = 0;
    int i;

    for (i = 0; i < nSize; i++)
    {
        if ((arTargets[i] != oCenter)
        &&  (IsObjectHostile(oCenter, arTargets[i]) == TRUE)
        &&  (IsModalAbilityActive(arTargets[i],AT_ABILITY_STEALTH) == FALSE) )
            nEnemiesCount++;
    }

    //MkBot: If subcondition "Surrounded by no enemies"
    if (nNumOfTargets == 0 && nEnemiesCount > 0)
        return OBJECT_INVALID;

    //MkBot: Otherwise "Surrounded by at least X enemies"
    if (nEnemiesCount >= nNumOfTargets)
        return oCenter;

    return OBJECT_INVALID;
}

object _MK_AI_Condition_AtLeastXEnemiesAtRange(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nNumOfTargets, int nRangeId)
{
    float fRadius = _MK_GetRangeFromID(nRangeId);
    return _MK_AI_Condition_AtLeastXEnemiesAtRadius(nTacticCommand, nTacticSubCommand, nTargetType, nTacticID, nAbilityTargetType, nNumOfTargets, fRadius);
}

#endif
