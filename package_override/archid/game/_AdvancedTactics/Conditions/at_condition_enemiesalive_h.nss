#ifndef AT_CONDITION_AT_LEAST_X_ENEMIS_ALIVE_H
#defsym AT_CONDITION_AT_LEAST_X_ENEMIS_ALIVE_H


//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object   _AT_AI_Condition_AtLeastXEnemiesAreAlive          (int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nNum);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
object _AT_AI_Condition_AtLeastXEnemiesAreAlive(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nNum)
{
    object[] arTargets = _AT_AI_GetEnemies();

    if (GetArraySize(arTargets) >= nNum)
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