#ifndef MK_AT_LEAST_X_ENEMIES_AT_RANGE_PARTY_H
#defsym MK_AT_LEAST_X_ENEMIES_AT_RANGE_PARTY_H

//==============================================================================
//                                INCLUDES
//==============================================================================
#include "af_ability_h"

/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_condition_most_hated_h"

/* MkBot */
/* MkBot */
#include "mk_constants_h"
#include "mk_constants_ai_h"

#include "mk_get_creatures_h"
#include "mk_cond_tools_h"

#include "mk_print_to_log_h"
#include "mk_other_h"

/* Talmud Storage*/
#include "talmud_storage_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
int _MK_SubCondition_Party_AtLeastXEnemiesAtRadius(int nNumOfTargets, float fRadius, int nIncludeSummoned);
object _MK_AI_Condition_Party_AtLeastXEnemiesAtRange(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nNumOfTargets, int nRangeId);

//==============================================================================
//                                DEFINITIONS
//==============================================================================
object _MK_AI_Condition_Party_AtLeastXEnemiesAtRange(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nNumOfTargets, int nRangeId)
{
    float fRadius = _MK_GetRangeFromID(nRangeId);

    object oTarget;
    switch( nTargetType )
    {
        case AI_TARGET_TYPE_SELF:
        {
            int nCondition = _MK_SubCondition_Party_AtLeastXEnemiesAtRadius(nNumOfTargets, fRadius, FALSE);
            //MK_PrintToLog( "nNumOfTargets"+IntToString(nNumOfTargets) );
            //MK_PrintToLog("fRadius="+FloatToString(fRadius, 4,1));
            //MK_PrintToLog( "nCondition"+IntToString(nCondition) );
            if ((_AT_AI_IsSelfValidForAbility(nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE)
            && (nCondition == TRUE) )
                return OBJECT_SELF;

            break;
        }
        case AI_TARGET_TYPE_HERO:
        case AI_TARGET_TYPE_FOLLOWER:
        case AI_TARGET_TYPE_MAIN_CONTROLLED:
        default:
        {
            oTarget = _AT_AI_GetPartyTarget(nTargetType, nTacticID);
            int nCondition = _MK_SubCondition_Party_AtLeastXEnemiesAtRadius(nNumOfTargets, fRadius, FALSE);
            //MK_PrintToLog( "nNumOfTargets"+IntToString(nNumOfTargets) );
            //MK_PrintToLog("fRadius="+FloatToString(fRadius, 4,1));
            //MK_PrintToLog( "nCondition"+IntToString(nCondition) );
            if ((_AT_AI_IsAllyValid(oTarget) == TRUE)
            && (_AT_AI_IsAllyValidForAbility(oTarget, nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE)
            && (nCondition == TRUE) )
                return oTarget;

            break;
        }
    }
    //MK_PrintToLog("return OBJECT_INVALID");
    return OBJECT_INVALID;
}

int _MK_SubCondition_Party_AtLeastXEnemiesAtRadius(int nNumOfTargets, float fRadius, int nIncludeSummoned)
{
    float fStart = 0.0f;
    float fEnd = 360.0f;
    int nCheckLiving = TRUE;
    //MkBot: Second Check if there is X enemies around any part member, if there are then return that party member (summoned excluded)
    object[] arAllies = _AT_AI_GetAlliesInParty(TRUE, FALSE, TRUE);
    int arAlliesSize = GetArraySize(arAllies);

    int nEnemiesCount = 0; //interesuje nas ile GLOBALNIE jest wrogow w zasiegu druzyny, a nie czy indywidualny Party Member ma obok siebie X wrogow
    int allyId;
    for( allyId = 0; allyId < arAlliesSize; allyId++ )
    {
        if( IsSummoned(arAllies[allyId]) && nIncludeSummoned == FALSE )
            continue;

        //Get all living creatures within sphere centered at given ally
        object oCenter = arAllies[allyId];
        object[] arTargets = GetObjectsInShape(OBJECT_TYPE_CREATURE, SHAPE_SPHERE, GetLocation(oCenter), fRadius, 0.0f, 0.0f, nCheckLiving);
        int nSize = GetArraySize(arTargets);

        //Count how many creatures are hostile (and not in stealth mode)
        int i;
        for (i = 0; i < nSize; i++)
        {
            if ((arTargets[i] != oCenter)
            &&  (IsObjectHostile(oCenter, arTargets[i]) == TRUE)
            &&  (IsModalAbilityActive(arTargets[i],AF_ABILITY_STEALTH) == FALSE) )
            nEnemiesCount++;
        }
    }

    if(nNumOfTargets == 0 &&  nEnemiesCount == 0) //no enemies
        return TRUE;
    if(nNumOfTargets > 0 && nEnemiesCount >= nNumOfTargets)  //at least X enemies
        return TRUE;

    return FALSE;
}

int _MK_AI_IsAtRangeOfFriends(object oEnemy, int nRangeID, object[] arFriends)
{
    int size = GetArraySize(arFriends);
    int i;
    for (i = 0; i < size; i++)
    {
        float fDist = GetDistanceBetween(oEnemy, arFriends[i]);
        float fRange = _MK_GetRangeFromID(nRangeID);
        if (fDist <= fRange)
        {
            return TRUE;
        }
    }

    return FALSE;
}

#endif