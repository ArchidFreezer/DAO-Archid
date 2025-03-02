#ifndef AT_CONDITION_AT_LEAST_X_CREATURES_ARE_DEAD_H
#defsym AT_CONDITION_AT_LEAST_X_CREATURES_ARE_DEAD_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _AT_AI_Condition_AtLeastXCreaturesAreDead(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nNum);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
object _AT_AI_Condition_AtLeastXCreaturesAreDead(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nNum)
{
    object[] arTargets = _AT_AI_GetEnemies(FALSE, FALSE);

    int nSize = GetArraySize(arTargets);

    int nCorpseCount = 0;

    int i;
    for (i = 0; i < nSize; i++)
    {
        if (IsDead(arTargets[i])
        || IsDying(arTargets[i]))
            nCorpseCount++;
    }

    if (nCorpseCount >= nNum)
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