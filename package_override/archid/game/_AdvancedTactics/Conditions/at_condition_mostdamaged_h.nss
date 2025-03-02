#ifndef AT_CONDITION_GET_NTH_MOST_DAMAGED_ENEMIES_H
#defsym AT_CONDITION_GET_NTH_MOST_DAMAGED_ENEMIES_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_condition_most_hated_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object   _AT_AI_Condition_GetNthMostDamagedCreatureInGroup (int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nHighLow);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
object _AT_AI_Condition_GetNthMostDamagedCreatureInGroup(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nHighLow)
{
    object[] arTargets;
    int nSize;
    int i;

    float fCurrentHP;
    object oNth = OBJECT_INVALID;
    float fNthHP = -1.0f;

    switch(nTargetType)
    {
        case AI_TARGET_TYPE_ALLY:
        {
            /* Advanced Tactics */
            /* Include self in ally if the ability allows it */
            if ((nAbilityTargetType & TARGET_TYPE_SELF) != 0)
            {
                if (_AT_AI_IsSelfValidForAbility(nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE)
                {
                    fNthHP = GetCurrentHealth(OBJECT_SELF);
                    oNth = OBJECT_SELF;
                }
            }

            arTargets = _AT_AI_GetAlliesInParty();
            nSize = GetArraySize(arTargets);

            if (nHighLow == 0)
            {
                for (i = 0; i < nSize; i++)
                {
                    if (_AT_AI_IsAllyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE)
                    {
                        fCurrentHP = GetCurrentHealth(arTargets[i]);
                        if ((fCurrentHP < fNthHP) || (fNthHP == -1.0))
                        {
                            fNthHP = fCurrentHP;
                            oNth = arTargets[i];
                        }
                    }
                }
            }
            else if (nHighLow == 1)
            {
                for (i = 0; i < nSize; i++)
                {
                    if (_AT_AI_IsAllyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE)
                    {
                        fCurrentHP = GetCurrentHealth(arTargets[i]);
                        if ((fCurrentHP > fNthHP) || (fNthHP == -1.0))
                        {
                            fNthHP = fCurrentHP;
                            oNth = arTargets[i];
                        }
                    }
                }
            }

            break;
        }
        case AI_TARGET_TYPE_ENEMY:
        {
            arTargets = _AT_AI_GetEnemies();
            nSize = GetArraySize(arTargets);

            if (nHighLow == 0)
            {
                for (i = 0; i < nSize; i++)
                {
                    if (_AT_AI_IsEnemyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE)
                    {
                        fCurrentHP = GetCurrentHealth(arTargets[i]);
                        if ((fCurrentHP < fNthHP) || (fNthHP == -1.0))
                        {
                            fNthHP = fCurrentHP;
                            oNth = arTargets[i];
                        }
                    }
                }
            }
            else if (nHighLow == 1)
            {
                for (i = 0; i < nSize; i++)
                {
                    if (_AT_AI_IsEnemyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE)
                    {
                        fCurrentHP = GetCurrentHealth(arTargets[i]);
                        if ((fCurrentHP > fNthHP) || (fNthHP == -1.0))
                        {
                            fNthHP = fCurrentHP;
                            oNth = arTargets[i];
                        }
                    }
                }
            }

            break;
        }
        default:
        {
            return OBJECT_INVALID;
        }
    }

    return oNth;
}
#endif