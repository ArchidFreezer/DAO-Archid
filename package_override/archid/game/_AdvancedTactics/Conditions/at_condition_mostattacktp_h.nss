#ifndef AT_CONDITION_MOST_ENEMIES_USING_ATTACK_TYPE_H
#defsym AT_CONDITION_MOST_ENEMIES_USING_ATTACK_TYPE_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_subcond_useattacktype_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _AT_AI_Condition_MostEnemiesUsingAttackType(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nAttackType);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
object _AT_AI_Condition_MostEnemiesUsingAttackType(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nAttackType)
{
    object[] arTargets = _AT_AI_GetEnemies();
    int nEnemiesWithAttackType = 0;

    int nSize = GetArraySize(arTargets);

    int i;
    for (i = 0; i < nSize; i++)
    {
        if (_AT_AI_SubCondition_UsingAttackType(arTargets[i], nAttackType) == TRUE)
            nEnemiesWithAttackType++;
    }

    if (nEnemiesWithAttackType > (nSize - nEnemiesWithAttackType))
    {
        switch(nTargetType)
        {
            case AI_TARGET_TYPE_SELF:
            {
                if (_AT_AI_IsSelfValidForAbility(nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE)
                    return OBJECT_SELF;

                break;
            }
            case AI_TARGET_TYPE_HERO:
            case AI_TARGET_TYPE_FOLLOWER:
            case AI_TARGET_TYPE_MAIN_CONTROLLED:
            default:
            {
                arTargets[0] = _AT_AI_GetPartyTarget(nTargetType, nTacticID);

                if (_AT_AI_IsAllyValidForAbility(arTargets[0], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE)
                    return arTargets[0];

                break;
            }
        }
    }

    return OBJECT_INVALID;
}

#endif