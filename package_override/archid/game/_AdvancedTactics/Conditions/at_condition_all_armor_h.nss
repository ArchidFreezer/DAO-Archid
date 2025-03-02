#ifndef AT_CONDITION_ALL_ENEMIES_HAVE_ARMOR_TYPE_H
#defsym AT_CONDITION_ALL_ENEMIES_HAVE_ARMOR_TYPE_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _AT_AI_Condition_AllEnemiesHaveArmorType(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nArmorType);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
object _AT_AI_Condition_AllEnemiesHaveArmorType(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nArmorType)
{
    object[] arTargets = _AT_AI_GetEnemies();

    int nSize = GetArraySize(arTargets);

    if (nSize > 0)
    {
        int i;
        for (i = 0; i < nSize; i++)
        {
            if ((_AI_GetArmorType(arTargets[i]) & nArmorType) == 0)
                return OBJECT_INVALID;
        }

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