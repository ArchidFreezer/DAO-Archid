#ifndef AT_CONDITION_AT_LEAST_X_ALLIES_ARE_ALIVE_H
#defsym AT_CONDITION_AT_LEAST_X_ALLIES_ARE_ALIVE_H

//==============================================================================
//                                INCLUDES
//==============================================================================
#include "af_ability_h"

/* Advanced Tactics */
#include "at_tools_conditions_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _AT_AI_Condition_AtLeastXAlliesAreAlive (int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nNum, int nParam2);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
object _AT_AI_Condition_AtLeastXAlliesAreAlive(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nNum, int nParam2)
{
    object[] arTargets;
    int nTargetsNum;
    int i;

    switch(nParam2)
    {
        case 0:
        {
            arTargets = _AT_AI_GetAlliesInParty();
            nTargetsNum = GetArraySize(arTargets);

            if (nTargetsNum < nNum)
                return OBJECT_INVALID;

            break;
        }
        case 1:
        {
            arTargets = _AT_AI_GetAlliesInParty(TRUE, FALSE, TRUE);
            nTargetsNum = GetArraySize(arTargets);

            int nCount = 0;
            for (i = 0; i < nTargetsNum; i++)
            {
                if (_AT_AI_IsTargetValidForBeneficialAbility(arTargets[i], AF_ABILITY_DISPEL_MAGIC) == TRUE)
                    nCount++;
            }

            if (nCount < nNum)
                return OBJECT_INVALID;

            break;
        }
        case 2:
        {
            arTargets = _AT_AI_GetAlliesInParty(TRUE, FALSE, TRUE);
            nTargetsNum = GetArraySize(arTargets);

            int nCount = 0;
            for (i = 0; i < nTargetsNum; i++)
            {
                if (_AI_HasStatLevel(arTargets[i], AI_STAT_TYPE_HP, -25) == TRUE)
                    nCount++;
            }

            if (nCount < nNum)
                return OBJECT_INVALID;

            break;
        }
        case 3:
        {
            arTargets = _AT_AI_GetAlliesInParty(TRUE, FALSE, TRUE);
            nTargetsNum = GetArraySize(arTargets);

            int nCount = 0;
            for (i = 0; i < nTargetsNum; i++)
            {
                if (_AI_HasStatLevel(arTargets[i], AI_STAT_TYPE_HP, -50) == TRUE)
                    nCount++;
            }

            if (nCount < nNum)
                return OBJECT_INVALID;

            break;
        }
        case 4:
        {
            arTargets = _AT_AI_GetAlliesInParty(TRUE, FALSE, TRUE);
            nTargetsNum = GetArraySize(arTargets);

            int nCount = 0;
            for (i = 0; i < nTargetsNum; i++)
            {
                if (_AI_HasStatLevel(arTargets[i], AI_STAT_TYPE_HP, -75) == TRUE)
                    nCount++;
            }

            if (nCount < nNum)
                return OBJECT_INVALID;

            break;
        }
        case 5:
        {
            arTargets = _AT_AI_GetAlliesInParty(TRUE, FALSE, TRUE);
            nTargetsNum = GetArraySize(arTargets);

            int nCount = 0;
            for (i = 0; i < nTargetsNum; i++)
            {
                if (_AI_HasStatLevel(arTargets[i], AI_STAT_TYPE_MANA_OR_STAMINA, -25) == TRUE)
                    nCount++;
            }

            if (nCount < nNum)
                return OBJECT_INVALID;

            break;
        }
        case 6:
        {
            arTargets = _AT_AI_GetAlliesInParty(TRUE, FALSE, TRUE);
            nTargetsNum = GetArraySize(arTargets);

            int nCount = 0;
            for (i = 0; i < nTargetsNum; i++)
            {
                if (_AI_HasStatLevel(arTargets[i], AI_STAT_TYPE_MANA_OR_STAMINA, -50) == TRUE)
                    nCount++;
            }

            if (nCount < nNum)
                return OBJECT_INVALID;

            break;
        }
        case 7:
        {
            arTargets = _AT_AI_GetAlliesInParty(TRUE, FALSE, TRUE);
            nTargetsNum = GetArraySize(arTargets);

            int nCount = 0;
            for (i = 0; i < nTargetsNum; i++)
            {
                if (_AI_HasStatLevel(arTargets[i], AI_STAT_TYPE_MANA_OR_STAMINA, -75) == TRUE)
                    nCount++;
            }

            if (nCount < nNum)
                return OBJECT_INVALID;

            break;
        }
        default:
        {
            return OBJECT_INVALID;
        }
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

    return OBJECT_INVALID;
}
#endif