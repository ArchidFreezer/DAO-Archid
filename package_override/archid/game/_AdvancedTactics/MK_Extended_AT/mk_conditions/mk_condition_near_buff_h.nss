#ifndef MK_CONDITION_GET_NEAREST_ENEMY_WITH_ANY_BUFF_EFFECT_H
#defsym MK_CONDITION_GET_NEAREST_ENEMY_WITH_ANY_BUFF_EFFECT_H

/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_condition_most_hated_h"

/* MkBot */
#include "mk_condition_ai_status_h"
#include "mk_other_h"
#include "mk_constants_ai_h"

/* Talmud Storage*/
#include "talmud_storage_h"

object _MK_AI_Condition_GetNearestEnemyWithAnyBuffEffect(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nRangeID, int nExcludeSleepRoot = TRUE);

object _MK_AI_Condition_GetNearestEnemyWithAnyBuffEffect(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nRangeID, int nExcludeSleepRoot)
{
    if(nTargetType == MK_TARGET_TYPE_SAVED_ENEMY)
    {
        int id = _MK_PartyMemberID();

        if(id < 0 )//in theory it should never happen
            return OBJECT_INVALID;

        object oTarget = FetchObjectFromArray("mkST",id);//idx starts from 1
        //DisplayFloatyMessage(OBJECT_SELF, "read["+IntToString(id+1)+"]="+ObjectToString(oTarget), FLOATY_MESSAGE, 0x888888, 5.0f);
        if ((_AT_AI_IsEnemyValid(oTarget) == TRUE)
        &&  (_AI_HasAnyBuffEffect(oTarget) == TRUE)
        &&  ((nRangeID == AI_RANGE_ID_INVALID) || (GetDistanceBetween(OBJECT_SELF, oTarget) <= _AI_GetRangeFromID(nRangeID)))
        &&  (_AT_AI_IsEnemyValidForAbility(oTarget, nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
        {
            return oTarget;
        }else{
            return OBJECT_INVALID;
        }
    }

    object[] arTargets;
    int nSize;
    int i;

    switch(nTargetType)
    {
        case AI_TARGET_TYPE_ENEMY:
        {
            object oSelectedTarget = GetAttackTarget(OBJECT_SELF);
            if ( (!nExcludeSleepRoot || !MK_IsSleepRoot(oSelectedTarget))
            && (_AT_AI_IsEnemyValid(oSelectedTarget) == TRUE)
            && (_AI_HasAnyBuffEffect(oSelectedTarget) == TRUE)
            && ((nRangeID == AI_RANGE_ID_INVALID) || (GetDistanceBetween(OBJECT_SELF, oSelectedTarget) <= _AI_GetRangeFromID(nRangeID)))
            && (_AT_AI_IsEnemyValidForAbility(oSelectedTarget, nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                return oSelectedTarget;

            arTargets = _AT_AI_GetEnemies();
            nSize = GetArraySize(arTargets);

            for (i = 0; i < nSize; i++)
            {
                if( nExcludeSleepRoot && MK_IsSleepRoot(arTargets[i]) )
                    continue;

                if ((_AI_HasAnyBuffEffect(arTargets[i]) == TRUE)
                && ((nRangeID == AI_RANGE_ID_INVALID) || (GetDistanceBetween(OBJECT_SELF, arTargets[i]) <= _AI_GetRangeFromID(nRangeID)))
                && (_AT_AI_IsEnemyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                    return arTargets[i];
            }

            break;
        }
        case AI_TARGET_TYPE_MOST_HATED:
        {
            arTargets[0] = _AT_AI_Condition_GetMostHatedEnemy();

            if ((_AT_AI_IsEnemyValid(arTargets[0]) == TRUE)
            && (_AI_HasAnyBuffEffect(arTargets[0]) == TRUE)
            && ((nRangeID == AI_RANGE_ID_INVALID) || (GetDistanceBetween(OBJECT_SELF, arTargets[0]) <= _AI_GetRangeFromID(nRangeID)))
            && (_AT_AI_IsEnemyValidForAbility(arTargets[0], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                return arTargets[0];

            break;
        }
        case AT_TARGET_TYPE_TARGET:
        {
            arTargets[0] = GetAttackTarget(OBJECT_SELF);

            if ((_AT_AI_IsEnemyValid(arTargets[0]) == TRUE)
            && (_AI_HasAnyBuffEffect(arTargets[0]) == TRUE)
            && ((nRangeID == AI_RANGE_ID_INVALID) || (GetDistanceBetween(OBJECT_SELF, arTargets[0]) <= _AI_GetRangeFromID(nRangeID)))
            && (_AT_AI_IsEnemyValidForAbility(arTargets[0], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                return arTargets[0];

            break;
        }
    }

    return OBJECT_INVALID;
}
#endif