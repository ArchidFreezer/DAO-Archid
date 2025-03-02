#ifndef AT_CONDITION_SUMMONIG_H
#defsym AT_CONDITION_SUMMONIG_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _AT_Condition_Summoning(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nCase);
object AT_Condition_Summoning(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nCase);
int _AT_SubCondition_Summoning(object oAlly, int nCase);


//==============================================================================
//                               DEFINITIONS
//==============================================================================
object AT_Condition_Summoning(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nCase)
{
    return _AT_Condition_Summoning(nTacticCommand, nTacticSubCommand, nTargetType, nTacticID, nAbilityTargetType, nCase);    
        
}

object _AT_Condition_Summoning(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nCase)
{
    object[] arTargets;
    int nSize;
    int i;

    switch(nTargetType)
    {
        case AI_TARGET_TYPE_SELF:
        {
            if ((_AT_SubCondition_Summoning(OBJECT_SELF, nCase) == TRUE)
            && (_AT_AI_IsSelfValidForAbility(nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                return OBJECT_SELF;

            break;
        }
        case AI_TARGET_TYPE_ALLY:
        {
            /* Advanced Tactics */
            /* Include self in ally if the ability allows it */
            if ((nAbilityTargetType & TARGET_TYPE_SELF) != 0)
            {
                if ((_AT_SubCondition_Summoning(OBJECT_SELF, nCase) == TRUE)
                && (_AT_AI_IsSelfValidForAbility(nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                    return OBJECT_SELF;
            }

            arTargets = _AT_AI_GetAlliesInParty();
            nSize = GetArraySize(arTargets);

            for (i = 0; i < nSize; i++)
            {
                if ((_AT_SubCondition_Summoning(arTargets[i], nCase) == TRUE)
                && (_AT_AI_IsAllyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                    return arTargets[i];
            }

            break;
        }
        case AI_TARGET_TYPE_HERO:
        case AI_TARGET_TYPE_FOLLOWER:
        case AI_TARGET_TYPE_MAIN_CONTROLLED:
        default:
        {
            arTargets[0] = _AT_AI_GetPartyTarget(nTargetType, nTacticID);

            if ((_AT_SubCondition_Summoning(arTargets[0], nCase) == TRUE)
            && (_AT_AI_IsAllyValidForAbility(arTargets[0], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE))
                return arTargets[0];

            break;
        }
    }

    return OBJECT_INVALID;
}

int _AT_SubCondition_Summoning(object oAlly, int nCase)
{
    switch(nCase)
    {
        case 0:
        {
            if (IsSummoned(oAlly) == TRUE)
                return TRUE;

            break;
        }
        case 1:
        {
            if (GetCurrentSummon(oAlly) != OBJECT_INVALID)
                return TRUE;

            break;
        }
        case 2:
        {
            if (GetCurrentSummon(oAlly) == OBJECT_INVALID)
                return TRUE;

            break;
        }
    }

    return FALSE;
}
#endif