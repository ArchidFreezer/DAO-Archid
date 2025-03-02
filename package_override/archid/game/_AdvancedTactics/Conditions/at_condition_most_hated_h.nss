#ifndef AT_CONDITION_GET_MOST_HATED_ENEMY_H
#defsym AT_CONDITION_GET_MOST_HATED_ENEMY_H

//==============================================================================
//                                INCLUDES
//==============================================================================
#include "at_tools_conditions_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _AT_AI_Condition_GetMostHatedEnemy();

//==============================================================================
//                               DEFINITIONS
//==============================================================================
object _AT_AI_Condition_GetMostHatedEnemy()
{
    object oTargetOverride = _AI_GetTargetOverride();
    if (_AT_AI_IsEnemyValid(oTargetOverride))
        return oTargetOverride;
    else
        return AI_Threat_GetThreatTarget(OBJECT_SELF);
}

#endif