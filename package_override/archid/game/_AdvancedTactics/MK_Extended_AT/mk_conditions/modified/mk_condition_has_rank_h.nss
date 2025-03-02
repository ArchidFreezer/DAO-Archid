#ifndef MK_CONDITION_HAS_RANK_H
#defsym MK_CONDITION_HAS_RANK_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_subcond_has_rank_h"   

/* MkBot */
#include "mk_constants_h"
#include "mk_constants_ai_h"

#include "mk_get_creatures_h"
#include "mk_cond_tools_h"

#include "mk_print_to_log_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _MK_AI_Condition_HasRank(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nTargetRank);

//==============================================================================
//                                DEFINITIONS
//==============================================================================
object _MK_AI_Condition_HasRank(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nTargetRank)
{
    object[] arTargets;
    int nSize;
    int i;

    switch (nTargetType)
    {      
        case AI_TARGET_TYPE_ENEMY:
        case AT_TARGET_TYPE_TARGET:
        case MK_TARGET_TYPE_SAVED_ENEMY:
        case AI_TARGET_TYPE_MOST_HATED:
        {
            arTargets = _MK_AI_GetEnemiesFromTargetType(nTargetType);
            nSize = GetArraySize(arTargets);

            for (i = 0; i < nSize; i++)
            {
                if (_AT_AI_IsEnemyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE
                &&  _MK_AI_IsSleepRoot(arTargets[i]) == FALSE
                &&  _AT_AI_SubCondition_HasRank(arTargets[i], nTargetRank) == TRUE)
                    return arTargets[i];
            }

            break;
        }
    }

    return OBJECT_INVALID;
}
#endif