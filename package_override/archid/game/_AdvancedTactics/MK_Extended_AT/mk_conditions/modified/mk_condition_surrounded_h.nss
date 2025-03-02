#ifndef MK_CONDITION_SURROUNDED_BY_AT_LEAST_X_ENEMIES_H
#defsym MK_CONDITION_SURROUNDED_BY_AT_LEAST_X_ENEMIES_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Core */
#include "talent_constants_h"

/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_condition_surrounded_h"

/* MkBot */
#include "mk_condition_x_at_range_h"
#include "mk_constants_ai_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _MK_AI_Condition_SurroundedByAtLeastXEnemies(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nNumOfTargets, int nRangeId = 0);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
//MkBot: Surrounded by no enemies fix
object _MK_AI_Condition_SurroundedByAtLeastXEnemies(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nNumOfTargets, int nRangeId)
{
    if( nRangeId == AI_RANGE_ID_INVALID )
    {
        if( nTargetType == MK_TARGET_TYPE_PARTY_MEMBER )
        {
            DisplayFloatyMessage(OBJECT_SELF,"Invalid SubCondition for Party Member. Try: At least X enemiens at Y range", FLOATY_MESSAGE, 0xFF0000, 5.0);
            return OBJECT_INVALID;

        }else
        {
            return _AT_AI_Condition_SurroundedByAtLeastXEnemies(nTacticCommand, nTacticSubCommand, nTargetType, nTacticID, nAbilityTargetType, nNumOfTargets);
        }
    }else
    {
        return _MK_AI_Condition_AtLeastXEnemiesAtRange(nTacticCommand, nTacticSubCommand, nTargetType, nTacticID, nAbilityTargetType, nNumOfTargets, nRangeId);
    }
}
#endif