#ifndef MK_IS_ATTACKED_ATTACK_TYPE_H
#defsym MK_IS_ATTACKED_ATTACK_TYPE_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_subcond_useattacktype_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
int _MK_AI_IsAttackedByAttackType(object oAttacker, object oTarget, int nAttackType);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
/** @brief
*
* @param oAttacker -
* @param oTarget -
* @param nAttackType -
* @author MkBot
*/
int _MK_AI_IsAttackedByAttackType(object oAttacker, object oTarget, int nAttackType)
{
    if (GetAttackTarget(oAttacker) == oTarget
    &&  _AT_AI_SubCondition_UsingAttackType(oAttacker, nAttackType) == TRUE)
    {
        if (nAttackType == AI_ATTACK_TYPE_MELEE)
        {
            if (GetDistanceBetween(oTarget, oAttacker) <= AI_MELEE_RANGE)
                return TRUE;
        }
        else
            return TRUE;
    }

    return FALSE;
}

#endif
