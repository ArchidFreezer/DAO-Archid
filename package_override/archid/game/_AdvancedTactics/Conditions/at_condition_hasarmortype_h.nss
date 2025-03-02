#ifndef AT_CONDITION_HAS_ARMOR_TYPE_H
#defsym AT_CONDITION_HAS_ARMOR_TYPE_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h" 
#include "at_condition_most_hated_h"
/* MkBot */
#include "mk_other_h"
/* Talmud Storage */
#include "talmud_storage_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _AT_AI_Condition_HasArmorType(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nArmorType);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
object _AT_AI_Condition_HasArmorType(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nArmorType)
{
    if(nTargetType == AT_TARGET_TYPE_SAVED)
    {
        int id = _MK_PartyMemberID();

        if(id < 0 )//in theory it should never happen
            return OBJECT_INVALID;

        object oTarget = FetchObjectFromArray("mkST",id);//idx starts from 1
        //DisplayFloatyMessage(OBJECT_SELF, "read["+IntToString(id+1)+"]="+ObjectToString(oTarget), FLOATY_MESSAGE, 0x888888, 5.0f);
        if ((_AT_AI_IsEnemyValid(oTarget) == TRUE)
        && ((_AI_GetArmorType(oTarget) & nArmorType) != 0)
        && (_AT_AI_IsEnemyValidForAbility(oTarget, nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
        {
            return oTarget;
        }else{
            return OBJECT_INVALID;
        }
    }

    object[] arTargets;
    int nSize;
    int i;

    switch (nTargetType)
    {
        case AI_TARGET_TYPE_ENEMY:
        {
            object oSelectedTarget = GetAttackTarget(OBJECT_SELF);
            if ((_AT_AI_IsEnemyValid(oSelectedTarget) == TRUE)
            && ((_AI_GetArmorType(oSelectedTarget) & nArmorType) != 0)
            && (_AT_AI_IsEnemyValidForAbility(oSelectedTarget, nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                return oSelectedTarget;

            arTargets = _AT_AI_GetEnemies();
            nSize = GetArraySize(arTargets);

            for (i = 0; i < nSize; i++)
            {
                if (((_AI_GetArmorType(arTargets[i]) & nArmorType) != 0)
                && (_AT_AI_IsEnemyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                    return arTargets[i];
            }

            break;
        }
        case AI_TARGET_TYPE_MOST_HATED:
        {
            arTargets[0] = _AT_AI_Condition_GetMostHatedEnemy();

            if ((_AT_AI_IsEnemyValid(arTargets[0]) == TRUE)
            && ((_AI_GetArmorType(arTargets[0]) & nArmorType) != 0)
            && (_AT_AI_IsEnemyValidForAbility(arTargets[0], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                return arTargets[0];

            break;
        }
        case AT_TARGET_TYPE_TARGET:
        {
            arTargets[0] = GetAttackTarget(OBJECT_SELF);

            if ((_AT_AI_IsEnemyValid(arTargets[0]) == TRUE)
            && ((_AI_GetArmorType(arTargets[0]) & nArmorType) != 0)
            && (_AT_AI_IsEnemyValidForAbility(arTargets[0], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                return arTargets[0];

            break;
        }
    }

    return OBJECT_INVALID;
}

#endif